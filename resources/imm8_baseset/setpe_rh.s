  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movq $0x5, %rax                    #  1     0     10     OPC=movq_r64_imm64  
  callq .read_pf_into_rcx            #  2     0xa   5      OPC=callq_label     
  incb %al                           #  3     0xf   2      OPC=incb_r8         
  callq .move_032_016_ecx_r12w_r13w  #  4     0x11  5      OPC=callq_label     
  xchgw %ax, %r12w                   #  5     0x16  4      OPC=xchgw_r16_r16   
  xaddb %ah, %cl                     #  6     0x1a  3      OPC=xaddb_r8_rh     
  retq                               #  7     0x1d  1      OPC=retq            
                                                                               
.size target, .-target
