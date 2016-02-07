  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  callq .read_pf_into_rcx           #  1     0     5      OPC=callq_label     
  movq $0x40, %rbx                  #  2     0x5   10     OPC=movq_r64_imm64  
  callq .move_016_008_cx_r8b_r9b    #  3     0xf   5      OPC=callq_label     
  decb %bl                          #  4     0x14  2      OPC=decb_r8         
  callq .move_byte_4_of_rbx_to_r9b  #  5     0x16  5      OPC=callq_label     
  callq .move_008_016_r8b_r9b_bx    #  6     0x1b  5      OPC=callq_label     
  callq .move_r9b_to_byte_4_of_rbx  #  7     0x20  5      OPC=callq_label     
  retq                              #  8     0x25  1      OPC=retq            
                                                                              
.size target, .-target
