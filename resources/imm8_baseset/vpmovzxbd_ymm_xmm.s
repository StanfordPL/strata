  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                  
.target:                                          #        0     0      OPC=<label>             
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label         
  vpmovzxbd %xmm9, %xmm15                         #  2     0x5   5      OPC=vpmovzxbd_xmm_xmm   
  vmovsd %xmm15, %xmm15, %xmm9                    #  3     0xa   5      OPC=vmovsd_xmm_xmm_xmm  
  vpmovzxbd %xmm8, %xmm8                          #  4     0xf   5      OPC=vpmovzxbd_xmm_xmm   
  callq .move_128_256_xmm8_xmm9_ymm1              #  5     0x14  5      OPC=callq_label         
  retq                                            #  6     0x19  1      OPC=retq                
                                                                                                
.size target, .-target
