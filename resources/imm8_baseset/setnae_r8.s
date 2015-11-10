  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  callq .read_cf_into_rbx           #  1     0     5      OPC=callq_label     
  callq .move_032_016_ebx_r8w_r9w   #  2     0x5   5      OPC=callq_label     
  callq .move_008_016_r8b_r9b_cx    #  3     0xa   5      OPC=callq_label     
  movswq %cx, %rbx                  #  4     0xf   4      OPC=movswq_r64_r16  
  callq .move_r9b_to_byte_2_of_rbx  #  5     0x13  5      OPC=callq_label     
  retq                              #  6     0x18  1      OPC=retq            
                                                                              
.size target, .-target
