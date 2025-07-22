onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 17 -group tb /mcu_tb/HEX0
add wave -noupdate -height 17 -group tb /mcu_tb/HEX1
add wave -noupdate -height 17 -group tb /mcu_tb/HEX2
add wave -noupdate -height 17 -group tb /mcu_tb/HEX3
add wave -noupdate -height 17 -group tb /mcu_tb/HEX4
add wave -noupdate -height 17 -group tb /mcu_tb/HEX5
add wave -noupdate -height 17 -group tb /mcu_tb/Switches
add wave -noupdate -height 17 -group tb /mcu_tb/LEDR
add wave -noupdate -height 17 -group tb /mcu_tb/KEY0
add wave -noupdate -height 17 -group tb /mcu_tb/KEY1
add wave -noupdate -height 17 -group tb /mcu_tb/KEY2
add wave -noupdate -height 17 -group tb /mcu_tb/KEY3
add wave -noupdate -height 17 -group tb /mcu_tb/reset
add wave -noupdate -height 17 -group tb /mcu_tb/clock
add wave -noupdate -height 17 -group tb /mcu_tb/ena
add wave -noupdate -height 17 -group FETCH -radix hexadecimal /mcu_tb/MCU_L/MIPS_Int/IFE/Instruction
add wave -noupdate -height 17 -group FETCH -radix hexadecimal /mcu_tb/MCU_L/MIPS_Int/IFE/PC_plus_4_out
add wave -noupdate -height 17 -group FETCH -radix hexadecimal /mcu_tb/MCU_L/MIPS_Int/IFE/PC_out
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/Add_result
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/BNE
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/BEQ
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/Jump_Add
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/Jr_Add
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/Jump
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/Zero
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/INTA
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/ISR_start
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/ISR_ADRESS
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/clock
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/reset
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/PC
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/PC_plus_4
add wave -noupdate -height 17 -group FETCH -radix decimal /mcu_tb/MCU_L/MIPS_Int/IFE/next_PC
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/PC_branch_plus4
add wave -noupdate -height 17 -group FETCH -radix hexadecimal /mcu_tb/MCU_L/MIPS_Int/IFE/Mem_Addr
add wave -noupdate -height 17 -group FETCH /mcu_tb/MCU_L/MIPS_Int/IFE/MEM_inst
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/read_data_1
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/read_data_2
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/Instruction
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/read_data
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/ALU_result
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/RegWrite
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/MemtoReg
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/RegDst
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/Jump_Add
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/Jal
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/PC_plus_4
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/Sign_extend
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/GIE
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/INTA
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/Jump
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/JAL_ISR
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/ISR_ADRESS
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/clock
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/reset
add wave -noupdate -height 17 -group DECODE -radix decimal -childformat {{/mcu_tb/MCU_L/MIPS_Int/ID/register_array(0) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(1) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(2) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(3) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(4) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(5) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(6) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(7) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(8) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(9) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(10) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(11) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(12) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(13) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(14) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(15) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(16) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(17) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(18) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(19) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(20) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(21) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(22) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(23) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(24) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(25) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(26) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(27) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(28) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(29) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(30) -radix hexadecimal} {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(31) -radix hexadecimal}} -expand -subitemconfig {/mcu_tb/MCU_L/MIPS_Int/ID/register_array(0) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(1) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(2) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(3) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(4) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(5) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(6) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(7) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(8) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(9) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(10) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(11) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(12) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(13) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(14) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(15) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(16) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(17) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(18) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(19) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(20) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(21) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(22) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(23) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(24) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(25) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(26) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(27) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(28) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(29) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(30) {-height 18 -radix hexadecimal} /mcu_tb/MCU_L/MIPS_Int/ID/register_array(31) {-height 18 -radix hexadecimal}} /mcu_tb/MCU_L/MIPS_Int/ID/register_array
add wave -noupdate -height 17 -group DECODE -radix hexadecimal /mcu_tb/MCU_L/MIPS_Int/ID/Next_pc
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/write_register_address
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/data
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/Jal_Add
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/write_data
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/read_register_1_address
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/read_register_2_address
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/write_register_address_1
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/write_register_address_0
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/RA
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/Instruction_immediate_value
add wave -noupdate -height 17 -group DECODE /mcu_tb/MCU_L/MIPS_Int/ID/ISR_ADRESS_REG
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/Opcode
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/Func
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/RegDst
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/ALUSrc
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/MemtoReg
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/RegWrite
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/MemRead
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/MemWrite
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/BEQ
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/BNE
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/Jal
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/JAL_ISR
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/Jump
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/ALUop
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/clock
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/reset
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/R_format
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/I_format
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/shift
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/beq_s
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/bne_s
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/j
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/jr
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/jal_s
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/slt
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/lw
add wave -noupdate -height 17 -group CONTROL /mcu_tb/MCU_L/MIPS_Int/CTL/sw
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/Read_data_1
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/Read_data_2
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/Sign_extend
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/Func
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/Opcode
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/ALUOp
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/ALUSrc
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/Zero
add wave -noupdate -height 17 -group EXECUTE -radix hexadecimal /mcu_tb/MCU_L/MIPS_Int/EXE/ALU_Result
add wave -noupdate -height 17 -group EXECUTE -radix hexadecimal /mcu_tb/MCU_L/MIPS_Int/EXE/Add_Result
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/PC_plus_4
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/Jr_Add
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/clock
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/reset
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/Ainput
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/Binput
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/ALU_output_mux
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/Branch_Add
add wave -noupdate -height 17 -group EXECUTE /mcu_tb/MCU_L/MIPS_Int/EXE/ALU_ctl
add wave -noupdate -height 17 -group MEMORY -radix hexadecimal /mcu_tb/MCU_L/MIPS_Int/MEM/read_data
add wave -noupdate -height 17 -group MEMORY /mcu_tb/MCU_L/MIPS_Int/MEM/address
add wave -noupdate -height 17 -group MEMORY /mcu_tb/MCU_L/MIPS_Int/MEM/write_data
add wave -noupdate -height 17 -group MEMORY /mcu_tb/MCU_L/MIPS_Int/MEM/MemRead
add wave -noupdate -height 17 -group MEMORY /mcu_tb/MCU_L/MIPS_Int/MEM/Memwrite
add wave -noupdate -height 17 -group MEMORY /mcu_tb/MCU_L/MIPS_Int/MEM/clock
add wave -noupdate -height 17 -group MEMORY /mcu_tb/MCU_L/MIPS_Int/MEM/reset
add wave -noupdate -height 17 -group MEMORY /mcu_tb/MCU_L/MIPS_Int/MEM/JAL_ISR
add wave -noupdate -height 17 -group MEMORY /mcu_tb/MCU_L/MIPS_Int/MEM/DataBus
add wave -noupdate -height 17 -group MEMORY -radix hexadecimal /mcu_tb/MCU_L/MIPS_Int/MEM/MEM_address
add wave -noupdate -height 17 -group MEMORY /mcu_tb/MCU_L/MIPS_Int/MEM/write_clock
add wave -noupdate -height 17 -group MEMORY /mcu_tb/MCU_L/MIPS_Int/MEM/Write_Ena
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/Clock
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/Reset
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/Data
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/AddrBus
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/MemRead
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/MemWrite
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/BT_CS
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/PWMout
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/Set_BTIFG
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/IRQ_2
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/BTCCR0
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/BTCCR1
add wave -noupdate -height 17 -expand -group timer -radix binary -childformat {{/mcu_tb/MCU_L/Basic_Timer/BTCTL(7) -radix binary} {/mcu_tb/MCU_L/Basic_Timer/BTCTL(6) -radix binary} {/mcu_tb/MCU_L/Basic_Timer/BTCTL(5) -radix binary} {/mcu_tb/MCU_L/Basic_Timer/BTCTL(4) -radix binary} {/mcu_tb/MCU_L/Basic_Timer/BTCTL(3) -radix binary} {/mcu_tb/MCU_L/Basic_Timer/BTCTL(2) -radix binary} {/mcu_tb/MCU_L/Basic_Timer/BTCTL(1) -radix binary} {/mcu_tb/MCU_L/Basic_Timer/BTCTL(0) -radix binary}} -expand -subitemconfig {/mcu_tb/MCU_L/Basic_Timer/BTCTL(7) {-height 18 -radix binary} /mcu_tb/MCU_L/Basic_Timer/BTCTL(6) {-height 18 -radix binary} /mcu_tb/MCU_L/Basic_Timer/BTCTL(5) {-height 18 -radix binary} /mcu_tb/MCU_L/Basic_Timer/BTCTL(4) {-height 18 -radix binary} /mcu_tb/MCU_L/Basic_Timer/BTCTL(3) {-height 18 -radix binary} /mcu_tb/MCU_L/Basic_Timer/BTCTL(2) {-height 18 -radix binary} /mcu_tb/MCU_L/Basic_Timer/BTCTL(1) {-height 18 -radix binary} /mcu_tb/MCU_L/Basic_Timer/BTCTL(0) {-height 18 -radix binary}} /mcu_tb/MCU_L/Basic_Timer/BTCTL
add wave -noupdate -height 17 -expand -group timer -radix decimal /mcu_tb/MCU_L/Basic_Timer/BTCNT
add wave -noupdate -height 17 -expand -group timer /mcu_tb/MCU_L/Basic_Timer/data_type
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/reset
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/clock
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/MemReadBus
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/MemWriteBus
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/AddressBus
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/DataBus
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/IntrSrc
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/ChipSelect
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/INTR
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/INTA
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/IRQ_OUT
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/INTR_Active
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/GIE
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/IRQ
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/CLR_IRQ
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/IRQ_STATUS
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/CLR_IRQ_STATUS
add wave -noupdate -height 17 -group interrupt -radix hexadecimal /mcu_tb/MCU_L/Intr_Controller/IE
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/IFG
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/TypeReg
add wave -noupdate -height 17 -group interrupt /mcu_tb/MCU_L/Intr_Controller/INTA_Delayed
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/DIVCLK
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/Reset
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/MemRead
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/MemWrite
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/Divider_CS
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/DIVIFG
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/AddrBus
add wave -noupdate -height 17 -group divider -radix hexadecimal /mcu_tb/MCU_L/DIV_Int/DataBus
add wave -noupdate -height 17 -group divider -radix hexadecimal /mcu_tb/MCU_L/DIV_Int/dividend_s
add wave -noupdate -height 17 -group divider -radix hexadecimal /mcu_tb/MCU_L/DIV_Int/divisior_s
add wave -noupdate -height 17 -group divider -radix hexadecimal /mcu_tb/MCU_L/DIV_Int/quotient_s
add wave -noupdate -height 17 -group divider -radix hexadecimal /mcu_tb/MCU_L/DIV_Int/residue_s
add wave -noupdate -height 17 -group divider -radix hexadecimal /mcu_tb/MCU_L/DIV_Int/residue_register
add wave -noupdate -height 17 -group divider -radix hexadecimal /mcu_tb/MCU_L/DIV_Int/quotient_register
add wave -noupdate -height 17 -group divider -radix hexadecimal /mcu_tb/MCU_L/DIV_Int/data_in
add wave -noupdate -height 17 -group divider -radix hexadecimal /mcu_tb/MCU_L/DIV_Int/data_out
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/DIVIFG_s
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/clock_s
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/unit_intake_s
add wave -noupdate -height 17 -group divider /mcu_tb/MCU_L/DIV_Int/data_type
add wave -noupdate -radix decimal /mcu_tb/MCU_L/Basic_Timer/BT0/counter
add wave -noupdate /mcu_tb/MCU_L/Basic_Timer/BT0/BTHOLD
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {303286 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 315
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
WaveRestoreZoom {0 ps} {1488522 ps}
