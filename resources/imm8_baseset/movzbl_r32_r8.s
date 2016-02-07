  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movq $0x4, %r9                  #  1     0     10     OPC=movq_r64_imm64  
  callq .write_cl_to_sf           #  2     0xa   5      OPC=callq_label     
  callq .read_sf_into_rbx         #  3     0xf   5      OPC=callq_label     
  movb %cl, %bh                   #  4     0x14  2      OPC=movb_rh_r8      
  callq .move_016_008_bx_r8b_r9b  #  5     0x16  5      OPC=callq_label     
  movq %r9, %rbx                  #  6     0x1b  3      OPC=movq_r64_r64    
  retq                            #  7     0x1e  1      OPC=retq            
                                                                            
.size target, .-target
