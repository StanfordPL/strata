  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                           #  Line  RIP   Bytes  Opcode                    
.target:                         #        0     0      OPC=<label>               
  movq $0xffffffffffffffff, %r9  #  1     0     10     OPC=movq_r64_imm64        
  movq %r9, %xmm9                #  2     0xa   5      OPC=movq_xmm_r64          
  vbroadcastss %xmm9, %ymm11     #  3     0xf   5      OPC=vbroadcastss_ymm_xmm  
  vpaddd %ymm3, %ymm11, %ymm3    #  4     0x14  4      OPC=vpaddd_ymm_ymm_ymm    
  vpxor %ymm3, %ymm11, %ymm1     #  5     0x18  4      OPC=vpxor_ymm_ymm_ymm     
  vpaddd %ymm2, %ymm1, %ymm1     #  6     0x1c  4      OPC=vpaddd_ymm_ymm_ymm    
  retq                           #  7     0x20  1      OPC=retq                  
                                                                                 
.size target, .-target
