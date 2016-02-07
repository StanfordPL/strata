  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                               #  Line  RIP   Bytes  Opcode           
.target:                             #        0     0      OPC=<label>      
  callq .clear_pf                    #  1     0     5      OPC=callq_label  
  callq .read_pf_into_rcx            #  2     0x5   5      OPC=callq_label  
  movb %bh, %cl                      #  3     0xa   2      OPC=movb_r8_rh   
  callq .move_064_032_rcx_r8d_r9d    #  4     0xc   5      OPC=callq_label  
  callq .move_032_064_r8d_r9d_rdx    #  5     0x11  5      OPC=callq_label  
  callq .move_064_032_rdx_r10d_r11d  #  6     0x16  5      OPC=callq_label  
  callq .move_032_064_r10d_r11d_rcx  #  7     0x1b  5      OPC=callq_label  
  movb %cl, %ah                      #  8     0x20  2      OPC=movb_rh_r8   
  retq                               #  9     0x22  1      OPC=retq         
                                                                            
.size target, .-target
