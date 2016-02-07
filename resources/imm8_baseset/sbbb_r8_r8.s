  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP   Bytes  Opcode           
.target:                 #        0     0      OPC=<label>      
  cmc                    #  1     0     1      OPC=cmc          
  notb %cl               #  2     0x1   2      OPC=notb_r8      
  adcb %bl, %cl          #  3     0x3   2      OPC=adcb_r8_r8   
  cmc                    #  4     0x5   1      OPC=cmc          
  setnge %bl             #  5     0x6   3      OPC=setnge_r8    
  xchgb %cl, %bl         #  6     0x9   2      OPC=xchgb_r8_r8  
  callq .set_szp_for_bl  #  7     0xb   5      OPC=callq_label  
  retq                   #  8     0x10  1      OPC=retq         
                                                                
.size target, .-target
