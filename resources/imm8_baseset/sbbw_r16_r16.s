  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                   #  Line  RIP   Bytes  Opcode              
.target:                 #        0     0      OPC=<label>         
  notw %bx               #  1     0     3      OPC=notw_r16        
  adcw %bx, %cx          #  2     0x3   3      OPC=adcw_r16_r16    
  movzwl %cx, %ebx       #  3     0x6   3      OPC=movzwl_r32_r16  
  notq %rbx              #  4     0x9   3      OPC=notq_r64        
  callq .set_szp_for_bx  #  5     0xc   5      OPC=callq_label     
  retq                   #  6     0x11  1      OPC=retq            
                                                                   
.size target, .-target
