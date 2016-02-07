  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode              
.target:                   #        0     0      OPC=<label>         
  callq .read_zf_into_rcx  #  1     0     5      OPC=callq_label     
  movswq %cx, %rbx         #  2     0x5   4      OPC=movswq_r64_r16  
  setae %ah                #  3     0x9   3      OPC=setae_rh        
  cmoveq %rbx, %rax        #  4     0xc   4      OPC=cmoveq_r64_r64  
  retq                     #  5     0x10  1      OPC=retq            
                                                                     
.size target, .-target
