  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                             #  Line  RIP   Bytes  Opcode                 
.target:                           #        0     0      OPC=<label>            
  callq .move_064_032_rbx_r8d_r9d  #  1     0     5      OPC=callq_label        
  roll $0x1, %ebx                  #  2     0x5   2      OPC=roll_r32_one       
  callq .move_032_064_r8d_r9d_rdx  #  3     0x7   5      OPC=callq_label        
  orb %dl, %bh                     #  4     0xc   2      OPC=orb_rh_r8          
  setnc %bl                        #  5     0xe   3      OPC=setnc_r8           
  setle %bh                        #  6     0x11  3      OPC=setle_rh           
  sarxq %rbx, %rdx, %rbx           #  7     0x14  5      OPC=sarxq_r64_r64_r64  
  callq .set_szp_for_rbx           #  8     0x19  5      OPC=callq_label        
  callq .write_dl_to_cf            #  9     0x1e  5      OPC=callq_label        
  retq                             #  10    0x23  1      OPC=retq               
                                                                                
.size target, .-target
