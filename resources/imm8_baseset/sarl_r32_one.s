  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                 #  Line  RIP  Bytes  Opcode                
.target:               #        0    0      OPC=<label>           
  movzbl %bl, %eax     #  1     0    3      OPC=movzbl_r32_r8     
  cmpxchgl %ebx, %ebx  #  2     0x3  3      OPC=cmpxchgl_r32_r32  
  xorb %bl, %bh        #  3     0x6  2      OPC=xorb_rh_r8        
  cltq                 #  4     0x8  2      OPC=cltq              
  sarq $0x1, %rax      #  5     0xa  3      OPC=sarq_r64_one      
  xchgl %ebx, %eax     #  6     0xd  1      OPC=xchgl_eax_r32     
  retq                 #  7     0xe  1      OPC=retq              
                                                                  
.size target, .-target
