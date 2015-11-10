  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                   #  Line  RIP   Bytes  Opcode              
.target:                 #        0     0      OPC=<label>         
  movswq %bx, %r13       #  1     0     4      OPC=movswq_r64_r16  
  decq %r13              #  2     0x4   3      OPC=decq_r64        
  vmovd %r13d, %xmm14    #  3     0x7   5      OPC=vmovd_xmm_r32   
  incw %r13w             #  4     0xc   4      OPC=incw_r16        
  vmovq %xmm14, %xmm2    #  5     0x10  5      OPC=vmovq_xmm_xmm   
  movq %xmm2, %rbx       #  6     0x15  5      OPC=movq_r64_xmm    
  callq .set_szp_for_bx  #  7     0x1a  5      OPC=callq_label     
  retq                   #  8     0x1f  1      OPC=retq            
                                                                   
.size target, .-target
