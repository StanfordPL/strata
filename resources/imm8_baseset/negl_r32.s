  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movq $0xffffffffffffffff, %rcx  #  1     0     10     OPC=movq_r64_imm64  
  xaddl %ecx, %ebx                #  2     0xa   3      OPC=xaddl_r32_r32   
  notl %ebx                       #  3     0xd   2      OPC=notl_r32        
  callq .set_szp_for_ebx          #  4     0xf   5      OPC=callq_label     
  retq                            #  5     0x14  1      OPC=retq            
                                                                            
.size target, .-target
