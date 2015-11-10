  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  movzbq %bl, %r10                  #  1     0     4      OPC=movzbq_r64_r8   
  movq $0xfffffffffffffffe, %r11    #  2     0x4   10     OPC=movq_r64_imm64  
  movzbl %ah, %ecx                  #  3     0xe   3      OPC=movzbl_r32_rh   
  xorq %rcx, %r10                   #  4     0x11  3      OPC=xorq_r64_r64    
  callq .move_008_016_r10b_r11b_bx  #  5     0x14  5      OPC=callq_label     
  callq .set_szp_for_bl             #  6     0x19  5      OPC=callq_label     
  retq                              #  7     0x1e  1      OPC=retq            
                                                                              
.size target, .-target
