  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP   Bytes  Opcode                        
.target:                            #        0     0      OPC=<label>                   
  pmovzxdq %xmm3, %xmm0             #  1     0     5      OPC=pmovzxdq_xmm_xmm          
  vcvttsd2sil %xmm0, %r13d          #  2     0x5   4      OPC=vcvttsd2sil_r32_xmm       
  salq $0x1, %r13                   #  3     0x9   3      OPC=salq_r64_one              
  movupd %xmm1, %xmm6               #  4     0xc   4      OPC=movupd_xmm_xmm            
  cvtsi2sdq %r13, %xmm1             #  5     0x10  5      OPC=cvtsi2sdq_xmm_r64         
  vfnmsub132sd %xmm0, %xmm2, %xmm1  #  6     0x15  5      OPC=vfnmsub132sd_xmm_xmm_xmm  
  vfmadd132sd %xmm3, %xmm6, %xmm1   #  7     0x1a  5      OPC=vfmadd132sd_xmm_xmm_xmm   
  retq                              #  8     0x1f  1      OPC=retq                      
                                                                                        
.size target, .-target
