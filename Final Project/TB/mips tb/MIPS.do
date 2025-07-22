onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/clock
add wave -noupdate -height 17 -expand -group FETCH -radix hexadecimal /mips_tb/U_0/IFE/Instruction
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/PC_plus_4_out
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/PC_out
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/Add_result
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/BNE
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/BEQ
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/Jump_Add
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/Jr_Add
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/Jump
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/Zero
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/reset
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/PC
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/PC_plus_4
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/next_PC
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/Mem_Addr
add wave -noupdate -height 17 -expand -group FETCH /mips_tb/U_0/IFE/PC_branch_plus4
add wave -noupdate -height 17 -expand -group DECODE -radix hexadecimal /mips_tb/U_0/ID/read_data_1
add wave -noupdate -height 17 -expand -group DECODE -radix hexadecimal /mips_tb/U_0/ID/read_data_2
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/Instruction
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/read_data
add wave -noupdate -height 17 -expand -group DECODE -radix hexadecimal /mips_tb/U_0/ID/ALU_result
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/RegWrite
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/MemtoReg
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/RegDst
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/Jump_Add
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/Jal
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/PC_plus_4
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/Sign_extend
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/clock
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/reset
add wave -noupdate -height 17 -expand -group DECODE -radix decimal -childformat {{/mips_tb/U_0/ID/register_array(0) -radix decimal} {/mips_tb/U_0/ID/register_array(1) -radix decimal} {/mips_tb/U_0/ID/register_array(2) -radix decimal} {/mips_tb/U_0/ID/register_array(3) -radix decimal} {/mips_tb/U_0/ID/register_array(4) -radix decimal} {/mips_tb/U_0/ID/register_array(5) -radix decimal} {/mips_tb/U_0/ID/register_array(6) -radix decimal} {/mips_tb/U_0/ID/register_array(7) -radix decimal} {/mips_tb/U_0/ID/register_array(8) -radix decimal} {/mips_tb/U_0/ID/register_array(9) -radix decimal} {/mips_tb/U_0/ID/register_array(10) -radix decimal} {/mips_tb/U_0/ID/register_array(11) -radix decimal} {/mips_tb/U_0/ID/register_array(12) -radix decimal} {/mips_tb/U_0/ID/register_array(13) -radix decimal} {/mips_tb/U_0/ID/register_array(14) -radix decimal} {/mips_tb/U_0/ID/register_array(15) -radix decimal} {/mips_tb/U_0/ID/register_array(16) -radix decimal} {/mips_tb/U_0/ID/register_array(17) -radix decimal} {/mips_tb/U_0/ID/register_array(18) -radix decimal} {/mips_tb/U_0/ID/register_array(19) -radix decimal} {/mips_tb/U_0/ID/register_array(20) -radix decimal} {/mips_tb/U_0/ID/register_array(21) -radix decimal} {/mips_tb/U_0/ID/register_array(22) -radix decimal} {/mips_tb/U_0/ID/register_array(23) -radix decimal} {/mips_tb/U_0/ID/register_array(24) -radix decimal} {/mips_tb/U_0/ID/register_array(25) -radix decimal} {/mips_tb/U_0/ID/register_array(26) -radix decimal} {/mips_tb/U_0/ID/register_array(27) -radix decimal} {/mips_tb/U_0/ID/register_array(28) -radix decimal} {/mips_tb/U_0/ID/register_array(29) -radix decimal} {/mips_tb/U_0/ID/register_array(30) -radix decimal} {/mips_tb/U_0/ID/register_array(31) -radix decimal}} -subitemconfig {/mips_tb/U_0/ID/register_array(0) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(1) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(2) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(3) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(4) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(5) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(6) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(7) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(8) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(9) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(10) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(11) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(12) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(13) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(14) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(15) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(16) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(17) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(18) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(19) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(20) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(21) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(22) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(23) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(24) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(25) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(26) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(27) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(28) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(29) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(30) {-height 18 -radix decimal} /mips_tb/U_0/ID/register_array(31) {-height 18 -radix decimal}} /mips_tb/U_0/ID/register_array
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/write_register_address
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/data
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/Jal_Add
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/write_data
add wave -noupdate -height 17 -expand -group DECODE -radix hexadecimal /mips_tb/U_0/ID/read_register_1_address
add wave -noupdate -height 17 -expand -group DECODE -radix hexadecimal /mips_tb/U_0/ID/read_register_2_address
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/write_register_address_1
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/write_register_address_0
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/RA
add wave -noupdate -height 17 -expand -group DECODE /mips_tb/U_0/ID/Instruction_immediate_value
add wave -noupdate -height 17 -expand -group EXECUTE -radix hexadecimal /mips_tb/U_0/EXE/Read_data_1
add wave -noupdate -height 17 -expand -group EXECUTE -radix hexadecimal /mips_tb/U_0/EXE/Read_data_2
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/Sign_extend
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/Func
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/Opcode
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/ALUOp
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/ALUSrc
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/Zero
add wave -noupdate -height 17 -expand -group EXECUTE -radix decimal /mips_tb/U_0/EXE/ALU_Result
add wave -noupdate -height 17 -expand -group EXECUTE -radix decimal /mips_tb/U_0/EXE/Add_Result
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/PC_plus_4
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/Jr_Add
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/clock
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/reset
add wave -noupdate -height 17 -expand -group EXECUTE -radix hexadecimal /mips_tb/U_0/EXE/Ainput
add wave -noupdate -height 17 -expand -group EXECUTE -radix hexadecimal /mips_tb/U_0/EXE/Binput
add wave -noupdate -height 17 -expand -group EXECUTE -radix hexadecimal /mips_tb/U_0/EXE/ALU_output_mux
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/Branch_Add
add wave -noupdate -height 17 -expand -group EXECUTE /mips_tb/U_0/EXE/ALU_ctl
add wave -noupdate -height 17 -group MEMORY /mips_tb/U_0/MEM/read_data
add wave -noupdate -height 17 -group MEMORY /mips_tb/U_0/MEM/address
add wave -noupdate -height 17 -group MEMORY -radix hexadecimal /mips_tb/U_0/MEM/write_data
add wave -noupdate -height 17 -group MEMORY /mips_tb/U_0/MEM/MemRead
add wave -noupdate -height 17 -group MEMORY /mips_tb/U_0/MEM/Memwrite
add wave -noupdate -height 17 -group MEMORY /mips_tb/U_0/MEM/clock
add wave -noupdate -height 17 -group MEMORY /mips_tb/U_0/MEM/reset
add wave -noupdate -height 17 -group MEMORY /mips_tb/U_0/MEM/write_clock
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/Opcode
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/Func
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/RegDst
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/ALUSrc
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/MemtoReg
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/RegWrite
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/MemRead
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/MemWrite
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/BEQ
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/BNE
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/Jal
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/Jump
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/ALUop
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/clock
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/reset
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/R_format
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/I_format
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/shift
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/beq_s
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/bne_s
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/j
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/jr
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/jal_s
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/slt
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/lw
add wave -noupdate -height 17 -expand -group CONTROL /mips_tb/U_0/CTL/sw
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {538046 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 268
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2528817 ps}
