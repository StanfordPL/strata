  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP   Bytes  Opcode             
.target:                 #        0     0      OPC=<label>        
  notb %ah               #  1     0     2      OPC=notb_rh        
  adcb %ah, %bh          #  2     0x2   2      OPC=adcb_rh_rh     
  xchgb %ah, %bh         #  3     0x4   2      OPC=xchgb_rh_rh    
  notb %ah               #  4     0x6   2      OPC=notb_rh        
  movsbl %ah, %ebx       #  5     0x8   3      OPC=movsbl_r32_rh  
  callq .set_szp_for_bx  #  6     0xb   5      OPC=callq_label    
  retq                   #  7     0x10  1      OPC=retq           
                                                                  
.size target, .-target
