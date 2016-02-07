  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                #  Line  RIP  Bytes  Opcode               
.target:              #        0    0      OPC=<label>          
  setns %dh           #  1     0    3      OPC=setns_rh         
  xaddb %dh, %dh      #  2     0x3  3      OPC=xaddb_rh_rh      
  cmovbeq %rcx, %rbx  #  3     0x6  4      OPC=cmovbeq_r64_r64  
  retq                #  4     0xa  1      OPC=retq             
                                                                
.size target, .-target
