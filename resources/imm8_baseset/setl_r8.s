  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP  Bytes  Opcode              
.target:                   #        0    0      OPC=<label>         
  callq .read_sf_into_rbx  #  1     0    5      OPC=callq_label     
  movzwq %bx, %rdx         #  2     0x5  4      OPC=movzwq_r64_r16  
  seto %dl                 #  3     0x9  3      OPC=seto_r8         
  xorq %rdx, %rbx          #  4     0xc  3      OPC=xorq_r64_r64    
  retq                     #  5     0xf  1      OPC=retq            
                                                                    
.size target, .-target
