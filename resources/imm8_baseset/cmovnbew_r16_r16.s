  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                  #  Line  RIP  Bytes  Opcode                
.target:                #        0    0      OPC=<label>           
  movswl %cx, %esi      #  1     0    3      OPC=movswl_r32_r16    
  movzwq %si, %r13      #  2     0x3  4      OPC=movzwq_r64_r16    
  cmovnbel %r13d, %ebx  #  3     0x7  4      OPC=cmovnbel_r32_r32  
  retq                  #  4     0xb  1      OPC=retq              
                                                                   
.size target, .-target
