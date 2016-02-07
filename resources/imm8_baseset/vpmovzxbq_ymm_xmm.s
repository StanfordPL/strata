  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                      #  Line  RIP   Bytes  Opcode                 
.target:                                    #        0     0      OPC=<label>            
  vpmovzxbq %xmm2, %xmm1                    #  1     0     5      OPC=vpmovzxbq_xmm_xmm  
  vpmovzxbd %xmm2, %xmm2                    #  2     0x5   5      OPC=vpmovzxbd_xmm_xmm  
  callq .move_128_032_xmm2_eax_edx_r8d_r9d  #  3     0xa   5      OPC=callq_label        
  callq .move_r9b_to_byte_16_of_ymm1        #  4     0xf   5      OPC=callq_label        
  callq .move_r8b_to_byte_16_of_ymm1        #  5     0x14  5      OPC=callq_label        
  callq .move_r9b_to_byte_24_of_ymm1        #  6     0x19  5      OPC=callq_label        
  retq                                      #  7     0x1e  1      OPC=retq               
                                                                                         
.size target, .-target
