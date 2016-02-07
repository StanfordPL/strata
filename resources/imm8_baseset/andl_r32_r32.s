  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                    #  Line  RIP   Bytes  Opcode                 
.target:                  #        0     0      OPC=<label>            
  notl %ebx               #  1     0     2      OPC=notl_r32           
  andnl %ecx, %ebx, %ebx  #  2     0x2   5      OPC=andnl_r32_r32_r32  
  rolw $0x1, %cx          #  3     0x7   3      OPC=rolw_r16_one       
  popcntl %ecx, %r9d      #  4     0xa   5      OPC=popcntl_r32_r32    
  callq .set_szp_for_ebx  #  5     0xf   5      OPC=callq_label        
  retq                    #  6     0x14  1      OPC=retq               
                                                                       
.size target, .-target
