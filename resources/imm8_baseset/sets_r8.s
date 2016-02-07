  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP  Bytes  Opcode              
.target:                   #        0    0      OPC=<label>         
  callq .read_sf_into_rbx  #  1     0    5      OPC=callq_label     
  salb $0x1, %bh           #  2     0x5  2      OPC=salb_rh_one     
  movl %ebx, %edi          #  3     0x7  2      OPC=movl_r32_r32    
  movzwq %di, %rbx         #  4     0x9  4      OPC=movzwq_r64_r16  
  retq                     #  5     0xd  1      OPC=retq            
                                                                    
.size target, .-target
