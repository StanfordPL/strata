  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                 
.target:                                          #        0     0      OPC=<label>            
  movq $0x0, %r14                                 #  1     0     10     OPC=movq_r64_imm64     
  vmovd %r14d, %xmm2                              #  2     0xa   5      OPC=vmovd_xmm_r32      
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  3     0xf   5      OPC=callq_label        
  cvtss2sil %xmm9, %ebx                           #  4     0x14  5      OPC=cvtss2sil_r32_xmm  
  setpo %bh                                       #  5     0x19  3      OPC=setpo_rh           
  xchgb %bl, %bh                                  #  6     0x1c  2      OPC=xchgb_rh_r8        
  retq                                            #  7     0x1e  1      OPC=retq               
                                                                                               
.size target, .-target
