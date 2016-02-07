  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                #  Line  RIP   Bytes  Opcode              
.target:              #        0     0      OPC=<label>         
  movswl %cx, %r10d   #  1     0     4      OPC=movswl_r32_r16  
  callq .clear_cf     #  2     0x4   5      OPC=callq_label     
  movzwl %bx, %ecx    #  3     0x9   3      OPC=movzwl_r32_r16  
  adcw %cx, %r10w     #  4     0xc   4      OPC=adcw_r16_r16    
  movslq %r10d, %r11  #  5     0x10  3      OPC=movslq_r64_r32  
  movswq %r11w, %rbx  #  6     0x13  4      OPC=movswq_r64_r16  
  retq                #  7     0x17  1      OPC=retq            
                                                                
.size target, .-target
