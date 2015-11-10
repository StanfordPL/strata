  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP  Bytes  Opcode             
.target:                 #        0    0      OPC=<label>        
  movl %ebx, %eax        #  1     0    2      OPC=movl_r32_r32   
  cltd                   #  2     0x2  1      OPC=cltd           
  xaddl %ebx, %eax       #  3     0x3  3      OPC=xaddl_r32_r32  
  sarq $0x1, %rbx        #  4     0x6  3      OPC=sarq_r64_one   
  callq .write_dl_to_of  #  5     0x9  5      OPC=callq_label    
  retq                   #  6     0xe  1      OPC=retq           
                                                                 
.size target, .-target
