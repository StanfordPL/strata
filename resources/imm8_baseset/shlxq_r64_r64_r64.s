  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                     #  Line  RIP   Bytes  Opcode             
.target:                   #        0     0      OPC=<label>        
  cmpb %cl, %ch            #  1     0     2      OPC=cmpb_rh_r8     
  callq .read_pf_into_rbx  #  2     0x2   5      OPC=callq_label    
  xchgq %rcx, %rdx         #  3     0x7   3      OPC=xchgq_r64_r64  
  shlq %cl, %rdx           #  4     0xa   3      OPC=shlq_r64_cl    
  xaddq %rbx, %rdx         #  5     0xd   4      OPC=xaddq_r64_r64  
  retq                     #  6     0x11  1      OPC=retq           
                                                                    
.size target, .-target
