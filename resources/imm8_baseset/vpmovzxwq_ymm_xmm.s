  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                      #  Line  RIP   Bytes  Opcode                 
.target:                                    #        0     0      OPC=<label>            
  pmovzxwq %xmm2, %xmm12                    #  1     0     6      OPC=pmovzxwq_xmm_xmm   
  callq .move_128_032_xmm2_eax_edx_r8d_r9d  #  2     0x6   5      OPC=callq_label        
  vmovd %edx, %xmm0                         #  3     0xb   4      OPC=vmovd_xmm_r32      
  vpmovzxwq %xmm0, %xmm13                   #  4     0xf   5      OPC=vpmovzxwq_xmm_xmm  
  callq .move_128_256_xmm12_xmm13_ymm1      #  5     0x14  5      OPC=callq_label        
  retq                                      #  6     0x19  1      OPC=retq               
                                                                                         
.size target, .-target
