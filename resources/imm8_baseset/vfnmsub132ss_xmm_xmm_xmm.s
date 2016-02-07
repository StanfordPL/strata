  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                        
.target:                                        #        0     0      OPC=<label>                   
  vpmovzxdq %xmm2, %xmm10                       #  1     0     5      OPC=vpmovzxdq_xmm_xmm         
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7  #  2     0x5   5      OPC=callq_label               
  pmovzxdq %xmm1, %xmm10                        #  3     0xa   6      OPC=pmovzxdq_xmm_xmm          
  vunpckhpd %xmm3, %xmm4, %xmm11                #  4     0x10  4      OPC=vunpckhpd_xmm_xmm_xmm     
  movsd %xmm4, %xmm10                           #  5     0x14  5      OPC=movsd_xmm_xmm             
  callq .move_128_256_xmm10_xmm11_ymm2          #  6     0x19  5      OPC=callq_label               
  vfnmsub231ps %ymm11, %ymm10, %ymm2            #  7     0x1e  5      OPC=vfnmsub231ps_ymm_ymm_ymm  
  vfnmadd132ss %xmm3, %xmm2, %xmm1              #  8     0x23  5      OPC=vfnmadd132ss_xmm_xmm_xmm  
  retq                                          #  9     0x28  1      OPC=retq                      
                                                                                                    
.size target, .-target
