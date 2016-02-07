  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                #  Line  RIP  Bytes  Opcode              
.target:              #        0    0      OPC=<label>         
  movsbq %bl, %r14    #  1     0    4      OPC=movsbq_r64_r8   
  adcb %r14b, %r14b   #  2     0x4  3      OPC=adcb_r8_r8      
  movswq %r14w, %r10  #  3     0x7  4      OPC=movswq_r64_r16  
  movswq %r10w, %rbx  #  4     0xb  4      OPC=movswq_r64_r16  
  retq                #  5     0xf  1      OPC=retq            
                                                               
.size target, .-target
