  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                               #  Line  RIP   Bytes  Opcode               
.target:                             #        0     0      OPC=<label>          
  callq .move_032_016_ebx_r10w_r11w  #  1     0     5      OPC=callq_label      
  callq .move_032_016_ecx_r8w_r9w    #  2     0x5   5      OPC=callq_label      
  movzwq %r10w, %rdx                 #  3     0xa   4      OPC=movzwq_r64_r16   
  popcntq %rdx, %rbx                 #  4     0xe   5      OPC=popcntq_r64_r64  
  callq .read_cf_into_rcx            #  5     0x13  5      OPC=callq_label      
  movq $0x40, %rbx                   #  6     0x18  10     OPC=movq_r64_imm64   
  callq .move_016_032_r10w_r11w_ecx  #  7     0x22  5      OPC=callq_label      
  callq .move_016_032_r8w_r9w_ebx    #  8     0x27  5      OPC=callq_label      
  retq                               #  9     0x2c  1      OPC=retq             
                                                                                
.size target, .-target
