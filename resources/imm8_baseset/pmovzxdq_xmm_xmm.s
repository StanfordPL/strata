  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                    #  Line  RIP  Bytes  Opcode                 
.target:                  #        0    0      OPC=<label>            
  vpmovzxdq %xmm2, %xmm2  #  1     0    5      OPC=vpmovzxdq_xmm_xmm  
  movaps %xmm2, %xmm1     #  2     0x5  3      OPC=movaps_xmm_xmm     
  retq                    #  3     0x8  1      OPC=retq               
                                                                      
.size target, .-target
