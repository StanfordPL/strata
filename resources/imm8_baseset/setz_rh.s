  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  callq .read_zf_into_rcx            #  1     0     5      OPC=callq_label     
  movslq %ecx, %r8                   #  2     0x5   3      OPC=movslq_r64_r32  
  callq .move_032_016_ecx_r10w_r11w  #  3     0x8   5      OPC=callq_label     
  callq .move_016_032_r10w_r11w_ebx  #  4     0xd   5      OPC=callq_label     
  callq .move_016_008_bx_r8b_r9b     #  5     0x12  5      OPC=callq_label     
  callq .move_016_008_cx_r12b_r13b   #  6     0x17  5      OPC=callq_label     
  movslq %r8d, %r13                  #  7     0x1c  3      OPC=movslq_r64_r32  
  callq .move_008_016_r12b_r13b_cx   #  8     0x1f  5      OPC=callq_label     
  movslq %ecx, %rax                  #  9     0x24  3      OPC=movslq_r64_r32  
  retq                               #  10    0x27  1      OPC=retq            
                                                                               
.size target, .-target
