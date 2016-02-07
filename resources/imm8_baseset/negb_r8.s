  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                             #  Line  RIP   Bytes  Opcode              
.target:                           #        0     0      OPC=<label>         
  movzbl %bl, %ecx                 #  1     0     3      OPC=movzbl_r32_r8   
  callq .move_032_016_ecx_r8w_r9w  #  2     0x3   5      OPC=callq_label     
  movq $0x80, %r9                  #  3     0x8   10     OPC=movq_r64_imm64  
  negw %r8w                        #  4     0x12  4      OPC=negw_r16        
  setnz %r9b                       #  5     0x16  4      OPC=setnz_r8        
  callq .move_016_032_r8w_r9w_ebx  #  6     0x1a  5      OPC=callq_label     
  xaddb %r8b, %cl                  #  7     0x1f  4      OPC=xaddb_r8_r8     
  callq .set_szp_for_bl            #  8     0x23  5      OPC=callq_label     
  retq                             #  9     0x28  1      OPC=retq            
                                                                             
.size target, .-target
