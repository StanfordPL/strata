  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                     #  Line  RIP   Bytes  Opcode                 
.target:                   #        0     0      OPC=<label>            
  movsbq %cl, %r11         #  1     0     4      OPC=movsbq_r64_r8      
  movq %r11, %xmm9         #  2     0x4   5      OPC=movq_xmm_r64       
  vpmovzxdq %xmm9, %ymm13  #  3     0x9   5      OPC=vpmovzxdq_ymm_xmm  
  vmovd %xmm13, %r10d      #  4     0xe   5      OPC=vmovd_r32_xmm      
  movsbl %bl, %r13d        #  5     0x13  4      OPC=movsbl_r32_r8      
  andl %r10d, %r13d        #  6     0x17  3      OPC=andl_r32_r32       
  retq                     #  7     0x1a  1      OPC=retq               
                                                                        
.size target, .-target
