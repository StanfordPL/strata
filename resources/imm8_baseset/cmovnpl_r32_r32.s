  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  setpe %r11b        #  1     0    4      OPC=setpe_r8        
  movl %ecx, %edi    #  2     0x4  2      OPC=movl_r32_r32    
  orb %r11b, %r11b   #  3     0x6  3      OPC=orb_r8_r8       
  cmovel %edi, %ebx  #  4     0x9  3      OPC=cmovel_r32_r32  
  retq               #  5     0xc  1      OPC=retq            
                                                              
.size target, .-target
