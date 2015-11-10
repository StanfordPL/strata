  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  movzbl %ah, %esp  #  1     0    3      OPC=movzbl_r32_rh  
  xorq %r10, %r10   #  2     0x3  3      OPC=xorq_r64_r64   
  xchgw %sp, %r10w  #  3     0x6  4      OPC=xchgw_r16_r16  
  cmpb %bl, %r10b   #  4     0xa  3      OPC=cmpb_r8_r8     
  retq              #  5     0xd  1      OPC=retq           
                                                            
.size target, .-target
