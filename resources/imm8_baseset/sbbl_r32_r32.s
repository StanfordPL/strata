  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                    #  Line  RIP  Bytes  Opcode              
.target:                  #        0    0      OPC=<label>         
  movslq %ecx, %rdx       #  1     0    3      OPC=movslq_r64_r32  
  notl %ebx               #  2     0x3  2      OPC=notl_r32        
  adcl %edx, %ebx         #  3     0x5  2      OPC=adcl_r32_r32    
  notl %ebx               #  4     0x7  2      OPC=notl_r32        
  callq .set_szp_for_ebx  #  5     0x9  5      OPC=callq_label     
  retq                    #  6     0xe  1      OPC=retq            
                                                                   
.size target, .-target
