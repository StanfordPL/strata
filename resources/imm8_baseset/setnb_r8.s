  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode              
.target:                   #        0     0      OPC=<label>         
  callq .read_cf_into_rcx  #  1     0     5      OPC=callq_label     
  movq $0x6, %rbx          #  2     0x5   10     OPC=movq_r64_imm64  
  orl %ebx, %ebx           #  3     0xf   2      OPC=orl_r32_r32     
  setnle %bl               #  4     0x11  3      OPC=setnle_r8       
  xorw %cx, %bx            #  5     0x14  3      OPC=xorw_r16_r16    
  retq                     #  6     0x17  1      OPC=retq            
                                                                     
.size target, .-target
