  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                    #  Line  RIP   Bytes  Opcode                 
.target:                  #        0     0      OPC=<label>            
  movzbq %bl, %rdx        #  1     0     4      OPC=movzbq_r64_r8      
  movb %ah, %dh           #  2     0x4   2      OPC=movb_rh_rh         
  movq $0x0, %rbx         #  3     0x6   10     OPC=movq_r64_imm64     
  orb %dh, %bl            #  4     0x10  2      OPC=orb_r8_rh          
  andnq %rbx, %rdx, %r12  #  5     0x12  5      OPC=andnq_r64_r64_r64  
  xorb %r12b, %bl         #  6     0x17  3      OPC=xorb_r8_r8         
  retq                    #  7     0x1a  1      OPC=retq               
                                                                       
.size target, .-target
