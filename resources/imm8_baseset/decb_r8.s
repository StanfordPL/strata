  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movq $0xfffffffffffffffe, %r12  #  1     0     10     OPC=movq_r64_imm64  
  callq .set_cf                   #  2     0xa   5      OPC=callq_label     
  adcb %r12b, %bl                 #  3     0xf   3      OPC=adcb_r8_r8      
  retq                            #  4     0x12  1      OPC=retq            
                                                                            
.size target, .-target
