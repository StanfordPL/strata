  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                                          #  Line  RIP   Bytes  Opcode             
.target:                                        #        0     0      OPC=<label>        
  vmovd %ebx, %xmm3                             #  1     0     4      OPC=vmovd_xmm_r32  
  callq .move_128_032_xmm3_r10d_r11d_r12d_r13d  #  2     0x4   5      OPC=callq_label    
  rolb $0x1, %r12b                              #  3     0x9   3      OPC=rolb_r8_one    
  sbbl %r10d, %eax                              #  4     0xc   3      OPC=sbbl_r32_r32   
  callq .move_128_032_xmm3_eax_edx_r8d_r9d      #  5     0xf   5      OPC=callq_label    
  retq                                          #  6     0x14  1      OPC=retq           
                                                                                         
.size target, .-target
