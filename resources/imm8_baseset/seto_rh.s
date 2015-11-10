  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode             
.target:                   #        0     0      OPC=<label>        
  callq .read_of_into_rbx  #  1     0     5      OPC=callq_label    
  vmovd %ebx, %xmm6        #  2     0x5   4      OPC=vmovd_xmm_r32  
  movd %xmm6, %eax         #  3     0x9   4      OPC=movd_r32_xmm   
  xaddb %ah, %bl           #  4     0xd   3      OPC=xaddb_r8_rh    
  retq                     #  5     0x10  1      OPC=retq           
                                                                    
.size target, .-target
