  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                            #  Line  RIP   Bytes  Opcode             
.target:                          #        0     0      OPC=<label>        
  movd %xmm2, %ebp                #  1     0     4      OPC=movd_r32_xmm   
  movzbl %bpl, %r8d               #  2     0x4   4      OPC=movzbl_r32_r8  
  movzbq %bpl, %r9                #  3     0x8   4      OPC=movzbq_r64_r8  
  vmovd %xmm2, %edx               #  4     0xc   4      OPC=vmovd_r32_xmm  
  callq .move_016_008_dx_r8b_r9b  #  5     0x10  5      OPC=callq_label    
  callq .move_064_128_r8_r9_xmm1  #  6     0x15  5      OPC=callq_label    
  retq                            #  7     0x1a  1      OPC=retq           
                                                                           
.size target, .-target
