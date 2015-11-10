  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP   Bytes  Opcode             
.target:                 #        0     0      OPC=<label>        
  movsbl %ah, %edx       #  1     0     3      OPC=movsbl_r32_rh  
  movsbw %ah, %cx        #  2     0x3   4      OPC=movsbw_r16_rh  
  xaddb %dh, %cl         #  3     0x7   3      OPC=xaddb_r8_rh    
  sarw $0x1, %dx         #  4     0xa   3      OPC=sarw_r16_one   
  xchgb %ah, %dl         #  5     0xd   2      OPC=xchgb_r8_rh    
  callq .write_cl_to_of  #  6     0xf   5      OPC=callq_label    
  retq                   #  7     0x14  1      OPC=retq           
                                                                  
.size target, .-target
