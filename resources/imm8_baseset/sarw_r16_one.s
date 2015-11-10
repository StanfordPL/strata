  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode                 
.target:                            #        0     0      OPC=<label>            
  movswq %bx, %rcx                  #  1     0     4      OPC=movswq_r64_r16     
  movsbl %bh, %ebx                  #  2     0x4   3      OPC=movsbl_r32_rh      
  popcntw %cx, %dx                  #  3     0x7   5      OPC=popcntw_r16_r16    
  callq .move_032_016_ebx_r8w_r9w   #  4     0xc   5      OPC=callq_label        
  setae %bl                         #  5     0x11  3      OPC=setae_r8           
  callq .write_cl_to_cf             #  6     0x14  5      OPC=callq_label        
  callq .move_r9b_to_byte_3_of_rbx  #  7     0x19  5      OPC=callq_label        
  shrxq %rbx, %rcx, %rbx            #  8     0x1e  5      OPC=shrxq_r64_r64_r64  
  callq .set_szp_for_ebx            #  9     0x23  5      OPC=callq_label        
  retq                              #  10    0x28  1      OPC=retq               
                                                                                 
.size target, .-target
