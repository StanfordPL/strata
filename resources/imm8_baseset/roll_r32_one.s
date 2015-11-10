  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movslq %ebx, %rdx                  #  1     0     3      OPC=movslq_r64_r32  
  callq .move_064_032_rdx_r12d_r13d  #  2     0x3   5      OPC=callq_label     
  movw %r13w, %dx                    #  3     0x8   4      OPC=movw_r16_r16    
  callq .write_dl_to_cf              #  4     0xc   5      OPC=callq_label     
  adcl %r12d, %ebx                   #  5     0x11  3      OPC=adcl_r32_r32    
  retq                               #  6     0x14  1      OPC=retq            
                                                                               
.size target, .-target
