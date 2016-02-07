  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movsbq %bl, %rdx                   #  1     0     4      OPC=movsbq_r64_r8   
  movq $0xfffffffffffffff8, %rcx     #  2     0x4   10     OPC=movq_r64_imm64  
  callq .move_064_032_rcx_r10d_r11d  #  3     0xe   5      OPC=callq_label     
  addb %cl, %r10b                    #  4     0x13  3      OPC=addb_r8_r8      
  callq .read_cf_into_rcx            #  5     0x16  5      OPC=callq_label     
  callq .clear_sf                    #  6     0x1b  5      OPC=callq_label     
  sarq %cl, %rdx                     #  7     0x20  3      OPC=sarq_r64_cl     
  movswq %dx, %rbx                   #  8     0x23  4      OPC=movswq_r64_r16  
  callq .clear_of                    #  9     0x27  5      OPC=callq_label     
  retq                               #  10    0x2c  1      OPC=retq            
                                                                               
.size target, .-target
