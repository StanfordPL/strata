  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                        
.target:                                          #        0     0      OPC=<label>                   
  callq .move_128_032_xmm1_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label               
  vunpckhpd %xmm8, %xmm9, %xmm5                   #  2     0x5   5      OPC=vunpckhpd_xmm_xmm_xmm     
  vfnmsub132ps %ymm5, %ymm5, %ymm5                #  3     0xa   5      OPC=vfnmsub132ps_ymm_ymm_ymm  
  vfmsub132ps %xmm3, %xmm3, %xmm5                 #  4     0xf   5      OPC=vfmsub132ps_xmm_xmm_xmm   
  vfnmadd213ps %xmm5, %xmm2, %xmm1                #  5     0x14  5      OPC=vfnmadd213ps_xmm_xmm_xmm  
  retq                                            #  6     0x19  1      OPC=retq                      
                                                                                                      
.size target, .-target
