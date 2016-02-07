  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                             #  Line  RIP   Bytes  Opcode             
.target:                           #        0     0      OPC=<label>        
  callq .move_064_032_rbx_r8d_r9d  #  1     0     5      OPC=callq_label    
  bswap %r9d                       #  2     0x5   3      OPC=bswap_r32      
  bswap %r8d                       #  3     0x8   3      OPC=bswap_r32      
  xchgq %r9, %r8                   #  4     0xb   3      OPC=xchgq_r64_r64  
  callq .move_032_064_r8d_r9d_rdx  #  5     0xe   5      OPC=callq_label    
  movq %rdx, %rbx                  #  6     0x13  3      OPC=movq_r64_r64   
  retq                             #  7     0x16  1      OPC=retq           
                                                                            
.size target, .-target
