  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movsbq %bl, %rdx                   #  1     0     4      OPC=movsbq_r64_r8   
  movsbw %cl, %r13w                  #  2     0x4   5      OPC=movsbw_r16_r8   
  movswq %r13w, %r9                  #  3     0x9   4      OPC=movswq_r64_r16  
  orq %r9, %rdx                      #  4     0xd   3      OPC=orq_r64_r64     
  callq .move_064_032_rdx_r10d_r11d  #  5     0x10  5      OPC=callq_label     
  clc                                #  6     0x15  1      OPC=clc             
  callq .move_008_016_r10b_r11b_bx   #  7     0x16  5      OPC=callq_label     
  callq .set_szp_for_bl              #  8     0x1b  5      OPC=callq_label     
  retq                               #  9     0x20  1      OPC=retq            
                                                                               
.size target, .-target
