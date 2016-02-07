  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode                 
.target:                            #        0     0      OPC=<label>            
  vmovq %xmm2, %rax                 #  1     0     5      OPC=vmovq_r64_xmm      
  callq .move_128_064_xmm2_r12_r13  #  2     0x5   5      OPC=callq_label        
  xaddw %r12w, %ax                  #  3     0xa   5      OPC=xaddw_r16_r16      
  vzeroall                          #  4     0xf   3      OPC=vzeroall           
  callq .move_064_128_r12_r13_xmm2  #  5     0x12  5      OPC=callq_label        
  vcvtpd2ps %ymm2, %xmm1            #  6     0x17  4      OPC=vcvtpd2ps_xmm_ymm  
  retq                              #  7     0x1b  1      OPC=retq               
                                                                                 
.size target, .-target
