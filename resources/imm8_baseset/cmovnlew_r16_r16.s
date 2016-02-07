  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode               
.target:                            #        0     0      OPC=<label>          
  cmovngw %bx, %cx                  #  1     0     4      OPC=cmovngw_r16_r16  
  movswq %cx, %rbx                  #  2     0x4   4      OPC=movswq_r64_r16   
  callq .move_016_008_cx_r8b_r9b    #  3     0x8   5      OPC=callq_label      
  callq .move_r9b_to_byte_3_of_rbx  #  4     0xd   5      OPC=callq_label      
  retq                              #  5     0x12  1      OPC=retq             
                                                                               
.size target, .-target
