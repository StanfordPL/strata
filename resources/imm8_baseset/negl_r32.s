  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                    #  Line  RIP  Bytes  Opcode              
.target:                  #        0    0      OPC=<label>         
  movslq %ebx, %rdx       #  1     0    3      OPC=movslq_r64_r32  
  negq %rdx               #  2     0x3  3      OPC=negq_r64        
  xaddl %ebx, %edx        #  3     0x6  3      OPC=xaddl_r32_r32   
  callq .set_szp_for_ebx  #  4     0x9  5      OPC=callq_label     
  retq                    #  5     0xe  1      OPC=retq            
                                                                   
.size target, .-target
