#!/usr/bin/python

# ------------------------------------------------------------------------------
#
# Create assembly functions from templates.
#
# Author: Stefan Heule <sheule@cs.stanford.edu>
#
# ------------------------------------------------------------------------------

import sys
import re
import os
import shutil

import fs



# ------------------------------------------
# main entry point
# ------------------------------------------

def main():
  if len(sys.argv) != 3:
    print "usage: " + sys.argv[0] + " <input folder> <output folder>"
    sys.exit(1)

  indir = sys.argv[1]
  outdir = sys.argv[2]

  # remove old files
  if os.path.exists(outdir):
    shutil.rmtree(outdir)
  os.makedirs(outdir)

  templates = 0
  total = 0
  for fn in os.listdir(indir):
    fn = os.path.join(indir, fn)
    if os.path.isfile(fn):
      with open(fn, 'r') as content_file:
        content = content_file.read()
        templates += 1
        fncs = process(content)
        for f in fncs:
          total += 1
          f.save(outdir)

  for f in (single_eflag() + set_szp() + move_byte()):
    total += 1
    f.save(outdir)

  print "Processed %d split-in-two templates, 4 move-byte templates and 6 flag templates to get a total of %d funcions." % (
    templates, total)


# ------------------------------------------
# code to produce all combinations
# ------------------------------------------

flags = {
  'cf': 0,
  'pf': 2,
  'af': 4,
  'zf': 6,
  'sf': 7,
  'of': 11,
}
setcc = {
  'af': '???',
  'cf': 'setnae',
  'pf': 'setp',
  'zf': 'setz',
  'sf': 'sets',
  'of': 'seto',
}
# masks and notmasks for all flags:
# af
# 0x10
# 0xffffffef
# of
# 0x800
# 0xfffff7ff
# zf
# 0x40
# 0xffffffbf
# cf
# 0x1
# 0xfffffffe
# pf
# 0x4
# 0xfffffffb
# sf
# 0x80
# 0xffffff7f

def get_mask(flag):
  return ~get_notmask(flag)


def get_notmask(flag):
  id = flags[flag]
  return ~(1 << id)


def mask_str(m):
  return tohex(m, 32)


def single_eflag():
  read_template = """  .text
  .globl read_[flag]_into_[reg]
  .type [name], @function
#! maybe-read { %[flag] }
#! maybe-write { %[reg] }
.[name]:
  # ----------------------------------------------------------------------------
  # read the [flag] flag into [reg]
  # ----------------------------------------------------------------------------
  #
  movq $0x0, %[reg]
  [setcc] %[reg8]
  retq

.size [name], .-[name]
  retq
"""
  clear_template = """  .text
  .globl clear_[flag]
  .type [name], @function
#! maybe-read { }
#! maybe-write { %[flag] }
#! must-undef { %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # clear the [flag] flag
  # ----------------------------------------------------------------------------
  #
  pushfq
  popq %r15
  andq $[notmask], %r15
  pushq %r15
  popfq
  retq

.size [name], .-[name]
  retq
"""
  set_template = """  .text
  .globl set_[flag]
  .type [name], @function
#! maybe-read { }
#! maybe-write { %[flag] }
#! must-undef { %r14 %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # set the [flag] flag
  # ----------------------------------------------------------------------------
  #
  pushfq
  popq %r15
  movq $[mask], %r14 # avoid sign extend when doing the or
  orq %r14, %r15
  pushq %r15
  popfq
  retq

.size [name], .-[name]
  retq
"""
  write_template = """  .text
  .globl write_[reg]_to_[flag]
  .type [name], @function
#! maybe-read { %[reg] }
#! maybe-write { %[flag] }
#! must-undef { %r14 %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # set the [flag] flag
  # ----------------------------------------------------------------------------
  #
  # read flags
  pushfq
  popq %r15

  # zero out [flag]
  movq $[notmask], %r14 # avoid sign extend when doing the or
  andq %r14, %r15

  # replicate the last bit in [reg] to all bits
  movb %[reg], %r14b
  shlq $0x3f, %r14
  sarq $0x3f, %r14

  # test if we need to set the flag
  testq %r14, %r14
  je .lbl[rand0]
  movq $[mask], %r14 # avoid sign extend when doing the or
  orq %r14, %r15

.lbl[rand0]:

  # write new flags
  pushq %r15
  popfq
  retq

.size [name], .-[name]
  retq
"""
  result = []
  for flag in flags.keys():
    for template in [set_template, clear_template, read_template, write_template]:
      if template == read_template and flag == "af":
        continue  # no support for reading the af flag at the moment
      regs = [""]
      regs2 = [""]
      if template == read_template:
        regs = list_regs("gp8", 1)[0:2]
        regs2 = list_regs("gp64", 1)[0:2]
      if template == write_template:
        regs2 = list_regs("gp8", 1)[1:3]
        regs = list_regs("gp64", 1)[1:3]
      for reg_idx in range(len(regs)):
        content = template.replace("[flag]", flag) \
          .replace("[reg]", regs2[reg_idx]) \
          .replace("[reg8]", regs[reg_idx]) \
          .replace("[setcc]", setcc[flag]) \
          .replace("[mask]", mask_str(get_mask(flag))) \
          .replace("[notmask]", mask_str(get_notmask(flag)))
        for i in range(10):
          content = content.replace("[rand%d]" % i, str(next_counter()))
        name = produce_name(content, {})
        code = produce_code(content, name, {})
        result.append(Function(name, code))
  return result


def set_szp():
  template = """  .text
  .globl set_szp_for_[reg]
  .type [name], @function
#! maybe-read { %[reg] }
#! maybe-write { %zf %pf %sf }
#! must-undef { %r14 %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # set the zf, sf, pf according to the result in %r8
  # ----------------------------------------------------------------------------
  #
  pushfq
  popq %r15
  # clear zf, sf and pf
  andq $0xffffff3b, %r15
  # set zf if necessary
  test[instr_postfix] %[reg], %[reg]
  jne .lbl[rand0]
  orq $0x40, %r15
.lbl[rand0]:
  # set sf if necessary
  test[instr_postfix] %[reg], %[reg]
  jns .lbl[rand1]
  movq $0x80, %r14 # avoid sign extend when doing the or
  orq %r14, %r15
.lbl[rand1]:
  # set zf if necessary
  test[instr_postfix] %[reg], %[reg]
  jnp .lbl[rand2]
  orq $0x4, %r15
.lbl[rand2]:
  pushq %r15
  popfq
  retq

.size [name], .-[name]
  retq

"""
  result = []
  for type in ["gp8", "gp16", "gp32", "gp64"]:
    for reg in list_regs(type, 1)[0:1]:
      content = template.replace("[reg]", reg) \
        .replace("[instr_postfix]", instr_postfix(type))
      for i in range(10):
        content = content.replace("[rand%d]" % i, str(next_counter()))
      name = produce_name(content, {"[reg]": reg})
      code = produce_code(content, name, {})
      result.append(Function(name, code))
  return result


counter = 0


def next_counter():
  global counter
  counter += 1
  return counter - 1


def move_byte():
  move_from_gp = """  .text
  .globl move_byte_[i]_of_[big_reg]_to_[small_reg]
  .type [name], @function
#! maybe-read { %[big_reg_min] }
#! maybe-write { %[small_reg] }
#! must-undef { %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # move the byte [i] of [big_reg] to [small_reg]
  # ----------------------------------------------------------------------------
  #
  pushfq
  movq %[big_reg], %r15
  shrq $[8i], %r15
  movb %r15b, %[small_reg]
  popfq
  retq

.size [name], .-[name]
  retq

"""
  move_to_gp = """  .text
  .globl move_[small_reg]_to_byte_[i]_of_[big_reg]
  .type [name], @function
#! maybe-read { %[small_reg] %[big_reg_min] }
#! maybe-write { %[big_reg_min] }
#! must-undef { %r14 %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # move [small_reg] to the byte [i] of [big_reg]
  # ----------------------------------------------------------------------------
  #
  pushfq
  xorq %r15, %r15
  movb %[small_reg], %r15b
  shlq $[8i], %r15
  movq $0xff, %r14
  shlq $[8i], %r14
  notq %r14
  andq %r14, %[big_reg]
  orq %r15, %[big_reg]
  popfq
  retq

.size [name], .-[name]
  retq

"""
  move_from_sse_lower = """  .text
  .globl move_byte_[i]_of_[big_reg]_to_[small_reg]
  .type [name], @function
#! maybe-read { %[big_reg_min] }
#! maybe-write { %[small_reg] }
#! must-undef { %ymm15 %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # move the byte [i] of [big_reg] to [small_reg]
  # ----------------------------------------------------------------------------
  #
  vmovupd %[big_reg], %ymm15
  psrldq $[ihex], %xmm15
  movq %xmm15, %r15
  movb %r15b, %[small_reg]
  retq

.size [name], .-[name]
  retq

"""
  move_from_sse_upper = """  .text
  .globl move_byte_[i]_of_[big_reg]_to_[small_reg]
  .type [name], @function
#! maybe-read { %[big_reg_min] }
#! maybe-write { %[small_reg] }
#! must-undef { %ymm15 %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # move the byte [i] of [big_reg] to [small_reg]
  # ----------------------------------------------------------------------------
  #
  vmovupd %[big_reg], %ymm15
  vperm2f128 $0x1, %ymm15, %ymm15, %ymm15
  psrldq $[i-16hex], %xmm15
  movq %xmm15, %r15
  movb %r15b, %[small_reg]
  retq

.size [name], .-[name]
  retq

"""
  move_to_sse_lower = """  .text
  .globl move_[small_reg]_to_byte_[i]_of_[big_reg]
  .type [name], @function
#! maybe-read { %[small_reg] %[big_reg_min] }
#! maybe-write { %[big_reg_min] }
#! must-undef { %r14 %r15 %ymm14 %ymm15 }
.[name]:
  # ----------------------------------------------------------------------------
  # move [small_reg] to the byte [i] of [big_reg]
  # ----------------------------------------------------------------------------
  #
  # zero all-ones xmm15
  movq $-0x1, %r15
  movq %r15, %xmm15
  vpbroadcastw %xmm15, %xmm15
  vbroadcastsd %xmm15, %ymm15

  # load 0xFF into ymm14
  vpxor %ymm14, %ymm14, %ymm14
  movq $0xff, %r14
  movq %r14, %xmm14
  pslldq $[ihex], %xmm14
  vpxor %ymm15, %ymm14, %ymm14 # not %ymm14

  # load byte into ymm15
  vpxor %ymm15, %ymm15, %ymm15
  movq $0x0, %r15
  movb %[small_reg], %r15b
  movq %r15, %xmm15
  pslldq $[ihex], %xmm15

  vpand %ymm14, %[big_reg], %[big_reg]
  vpor %ymm15, %[big_reg], %[big_reg]
  retq

.size [name], .-[name]
  retq

"""
  move_to_sse_upper = """  .text
  .globl move_[small_reg]_to_byte_[i]_of_[big_reg]
  .type [name], @function
#! maybe-read { %[small_reg] %[big_reg_min] }
#! maybe-write { %[big_reg_min] }
#! must-undef { %r14 %r15 %ymm14 %ymm15 }
.[name]:
  # ----------------------------------------------------------------------------
  # move [small_reg] to the byte [i] of [big_reg]
  # ----------------------------------------------------------------------------
  #
  # zero all-ones xmm15
  movq $-0x1, %r15
  movq %r15, %xmm15
  vpbroadcastw %xmm15, %xmm15
  vbroadcastsd %xmm15, %ymm15

  # load 0xFF into ymm14
  vpxor %ymm14, %ymm14, %ymm14
  movq $0xff, %r14
  movq %r14, %xmm14
  pslldq $[i-16hex], %xmm14
  vpxor %ymm15, %ymm14, %ymm14 # not %ymm14

  # load byte into ymm15
  vpxor %ymm15, %ymm15, %ymm15
  movq $0x0, %r15
  movb %[small_reg], %r15b
  movq %r15, %xmm15
  pslldq $[i-16hex], %xmm15

  vperm2f128 $0x1, %ymm14, %ymm14, %ymm14
  vperm2f128 $0x1, %ymm15, %ymm15, %ymm15

  vpand %ymm14, %[big_reg], %[big_reg]
  vpor %ymm15, %[big_reg], %[big_reg]
  retq

.size [name], .-[name]
  retq

"""
  result = []
  for start, stop, type, templates in [(2, 8, "gp64", [move_from_gp, move_to_gp]),
                                       (0, 16, "ymm", [move_from_sse_lower, move_to_sse_lower]),
                                       (16, 32, "ymm", [move_from_sse_upper, move_to_sse_upper])]:
    for i in range(start, stop):
      for src_i in [0, 1]:
        src = list_regs("gp8", 0)[src_i]
        for dest_i in [0]:
          dest = list_regs(type, 1)[dest_i]
          for template in templates:
            if type == "ymm":
              min = "ymm" if i > 15 else "xmm"
            else:
              min = "gp8"
              if i >= 1:
                min = "gp16"
              if i >= 2:
                min = "gp32"
              if i >= 4:
                min = "gp64"
            content = template.replace("[small_reg]", src) \
              .replace("[i]", str(i)) \
              .replace("[ihex]", hex(i)) \
              .replace("[i-16]", str(i - 16)) \
              .replace("[i-16hex]", hex(i - 16)) \
              .replace("[8i]", hex(i * 8)) \
              .replace("[big_reg_min]", list_regs(min, 1)[dest_i]) \
              .replace("[big_reg_b]", list_regs("gp8", 1)[dest_i]) \
              .replace("[big_reg]", dest)
            name = produce_name(content, {"[small_reg]": src, "[big_reg]": dest, "[i]": str(i)})
            code = produce_code(content, name, {})
            result.append(Function(name, code))
  return result

# ------------------------------------------
# code to produce all combinations
# ------------------------------------------

reg_regex = re.compile("^r([0-9]+)(w|b|d|)$")
reg_map = {
  "b": {
    "0": "al",
    "1": "bl",
    "2": "cl",
    "3": "dl",
    "4": "sil",
    "5": "dil",
    "6": "bpl",
    "7": "spl",
  },
  "w": {
    "0": "ax",
    "1": "bx",
    "2": "cx",
    "3": "dx",
    "4": "si",
    "5": "di",
    "6": "bp",
    "7": "sp",
  },
  "d": {
    "0": "eax",
    "1": "ebx",
    "2": "ecx",
    "3": "edx",
    "4": "esi",
    "5": "edi",
    "6": "ebp",
    "7": "esp",
  },
  "": {
    "0": "rax",
    "1": "rbx",
    "2": "rcx",
    "3": "rdx",
    "4": "rsi",
    "5": "rdi",
    "6": "rbp",
    "7": "rsp",
  }
}

# map registers like r0 to their real name, e.g. rax
def correct_name(reg):
  match = re.search(reg_regex, reg)
  if match == None:
    return reg
  if int(match.group(1)) > 7:
    return reg
  return reg_map[match.group(2)][match.group(1)]


# instruction postfix for a certain type
def instr_postfix(type):
  m = {
    'gp8': 'b',
    'gp16': 'w',
    'gp32': 'l',
    'gp64': 'q',
  }
  assert (type in m)
  return m[type]

# the list of all register types
reg_types = ['ymm', 'xmm', 'mm', 'gp64', 'gp32', 'gp16', 'gp8']
# width of all types
type_width = [256, 128, 64, 64, 32, 16, 8]

# return a list of all registers of a given type
def list_regs(type, kind):
  if kind == 1:
    start = 1
  else:
    start = 8
  prefix = "r"
  postfix = ""
  if type == 'gp8':
    postfix = "b"
  elif type == 'gp16':
    postfix = "w"
  elif type == 'gp32':
    postfix = "d"
  elif type == 'gp64':
    pass
  elif type == 'xmm':
    prefix = "xmm"
  elif type == 'mm':
    prefix = "mm"
    start = 1
  elif type == 'ymm':
    prefix = "ymm"
  else:
    print "ERROR, unknown register type: " + type
    sys.exit(1)

  return map(lambda idx: correct_name(prefix + str(idx) + postfix), range(start, start + 6))


# the width of a type
def get_width(t):
  return type_width[reg_types.index(t)]


# get all variables in the source code that we need to replace
def get_variables(content):
  res = {}
  types = "|".join(reg_types)
  for match in re.finditer(re.compile("\[(" + types + ")_([0-9]+)(_as-(" + types + "))?\]"), content):
    variable = match.group(1) + "_" + match.group(2)
    base = match.group(1)
    type = base
    if match.group(3) is not None:
      type = match.group(4)
    if variable not in res:
      res[variable] = {
        'var': variable,
        'base': base,
        'extra': set(),
      }
    if type != base:
      res[variable]['extra'].add(type)
  return res


# return all combination of variable to value mappings
def all_mappings(variables, name):
  types = list(set(map(lambda x: x['base'], variables.values())))
  if len(types) == 2 and len(variables) == 5:
    if "move_128_032" in name or "move_032_128" in name:
      regs = ['eax', 'edx', 'r8d', 'r9d', 'r10d', 'r11d', 'r12d', 'r13d']
      res = []
      for reg in list_regs(types[0], 1)[0:3]:
        m0 = {}
        m0['xmm_0'] = reg
        m1 = {}
        m1['xmm_0'] = reg
        for dest in range(4):
          m0['gp32_' + str(dest)] = regs[dest]
          m1['gp32_' + str(dest)] = regs[dest+4]
        res.append(m0)
        res.append(m1)
    elif "move_064_016" in name or "move_016_064" in name:
      regs = ['ax', 'dx', 'r8w', 'r9w', 'r10w', 'r11w', 'r12w', 'r13w']
      res = []
      for reg in list_regs('mm', 1)[0:3]:
        m0 = {}
        m0['mm_0'] = reg
        m1 = {}
        m1['mm_0'] = reg
        for dest in range(4):
          m0['gp16_' + str(dest)] = regs[dest]
          m1['gp16_' + str(dest)] = regs[dest+4]
        res.append(m0)
        res.append(m1)
    else:
      print "ERROR, unknown type of template 2.6"
      sys.exit(1)
  elif len(types) == 2:
    if get_width(types[0]) < get_width(types[1]):
      input_type = types[1]
    else:
      input_type = types[0]

    inputs_regs = {}
    for r in reg_types:
      inputs_regs[r] = list_regs(r, 1)
    outputs_regs = {}
    for r in reg_types:
      outputs_regs[r] = list_regs(r, 0)

    input_vars = []
    output_vars = []
    for k, v in sorted(variables.iteritems()):
      if v['base'] == input_type:
        input_vars.append(v)
      else:
        output_vars.append(v)

    if len(input_vars) == 1 and len(output_vars) == 2:
      res = []
      for i in range(3):
        for o in range(3):
          m = {}
          # also add mapping for other that base-types
          m[input_vars[0]['var']] = inputs_regs[input_vars[0]['base']][i]
          for t in input_vars[0]['extra']:
            m[input_vars[0]['var'] + "_as-" + t] = inputs_regs[t][i]
          for k in range(2):
            m[output_vars[k]['var']] = outputs_regs[output_vars[1]['base']][2 * o + k]
            for t in output_vars[k]['extra']:
              m[output_vars[k]['var'] + "_as-" + t] = output_vars[t][2 * o + k]
          res.append(m)
    else:
      print "ERROR, unknown type of template 1"
      sys.exit(1)
  elif len(types) == 1 and len(variables) == 1:
    if "set_flag" in name:
      res = []
      for reg in list_regs(types[0], 1):
        m = {}
        m[variables[0]] = reg
        res.append(m)
    else:
      print "ERROR, unknown type of template 2"
      sys.exit(1)
  elif len(types) == 1 and len(variables) == 5:
    if "move_128_032" in name or "move_032_128" in name:
      res = []
      for reg in list_regs(types[0], 1)[0:3]:
        m0 = {}
        m0['xmm_0'] = reg
        m1 = {}
        m1['xmm_0'] = reg
        for dest in range(4):
          m0['xmm_' + str(dest + 1)] = 'xmm' + str(dest + 4)
          m1['xmm_' + str(dest + 1)] = 'xmm' + str(dest + 8)
        res.append(m0)
        res.append(m1)
    else:
      print "ERROR, unknown type of template 2.5"
      sys.exit(1)
  elif len(types) == 1 and len(variables) == 3:
    if "move_128_64" in name or "move_64_128" in name:
      res = []
      for reg in list_regs(types[0], 1)[0:3]:
        m0 = {}
        m0['xmm_0'] = reg
        m0['xmm_1'] = 'xmm10'
        m0['xmm_2'] = 'xmm11'
        m1 = {}
        m1['xmm_0'] = reg
        m1['xmm_1'] = 'xmm12'
        m1['xmm_2'] = 'xmm13'
        m2 = {}
        m2['xmm_0'] = reg
        m2['xmm_1'] = 'xmm8'
        m2['xmm_2'] = 'xmm9'
        res.append(m0)
        res.append(m1)
        res.append(m2)
    else:
      print "ERROR, unknown type of template 2.5"
      sys.exit(1)
  else:
    print "ERROR, unknown type of template 3"
    sys.exit(1)
  return res


# filter mappings with the same register occurring multiple times
def filter_mappings(mappings):
  return filter(lambda m: len(m.values()) == len(list(set(m.values()))), mappings)


# process the content, returning a list of Funcions
def process(content):
  variables = get_variables(content)
  mappings = filter_mappings(all_mappings(variables, raw_name(content)))
  res = []
  for m in mappings:
    name = produce_name(content, m)
    code = produce_code(content, name, m)
    res.append(Function(name, code))
  return res


# get the name given a mapping
def produce_name(content, mapping):
  match = re.search(re.compile("^  \.globl ([a-zA-Z0-9_\[\].\-+=]+)$", re.MULTILINE), content)
  if match == None:
    print "ERROR: name of function not found"
    sys.exit(1)
  return instantiate(raw_name(content), mapping)


def raw_name(content):
  match = re.search(re.compile("^  \.globl ([a-zA-Z0-9_\[\].\-+=]+)$", re.MULTILINE), content)
  if match == None:
    print "ERROR: name of function not found"
    sys.exit(1)
  return match.group(1)


# get the code given a mapping
def produce_code(content, name, mapping):
  return instantiate(content, mapping).replace("[name]", name)


# instantiate a string with a mapping
def instantiate(s, mapping):
  for v, r in mapping.iteritems():
    s = s.replace("[" + v + "]", r)
  return s


# a function (can be written to a file)
class Function(object):
  def __init__(self, name, content):
    self.name = name
    self.content = content

  def save(self, outdir):
    assert not os.path.exists(os.path.join(outdir, self.name + ".s"))
    fs.write_file(os.path.join(outdir, self.name + ".s"), self.content)

  def __repr__(self):
    return self.name


# ------------------------------------------
# helper functions
# ------------------------------------------


def tohex(val, nbits):
  return hex((val + (1 << nbits)) % (1 << nbits))


if __name__ == '__main__':
  main()
