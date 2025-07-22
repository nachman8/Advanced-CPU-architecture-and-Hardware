						--  Dmemory module (implements the data
						--  memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory IS
	GENERIC (MemWidth	: INTEGER;
			 SIM		: BOOLEAN);					
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset			: IN 	STD_LOGIC;
			JAL_ISR				: IN 	STD_LOGIC;
			DataBus				: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 ));
END dmemory;

ARCHITECTURE behavior OF dmemory IS
SIGNAL MEM_address	: STD_LOGIC_VECTOR(MemWidth-1 DOWNTO 0);
SIGNAL write_clock  : STD_LOGIC;
SIGNAL Write_Ena 	: STD_LOGIC;
BEGIN

Write_Ena <= '1' when address(11) = '0' and Memwrite = '1' else '0'; --- dont write when its SFR

----ModelSim/FPGA--- 
	PROCESS(JAL_ISR,clock) BEGIN
	IF (falling_edge(CLOCK)) THEN
		IF (SIM = TRUE) then
			if JAL_ISR = '0' then
				MEM_address <= address(9 DOWNTO 2);
			else MEM_address <= DataBus(9 DOWNTO 2);
			end if;
	----FPGA------ 
		ELSIF (SIM = FALSE) then
			if JAL_ISR = '0' then
				MEM_address <= address(9 DOWNTO 2) & "00";
			else MEM_address <= DataBus(9 DOWNTO 2) & "00";
			end if;
		end if;
	end if;
	END PROCESS;

	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => MemWidth,
		--numwords_a => 1024,
		--lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = DTCM",
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\intelFPGA_lite\Final Project\Hanan Files\SW QA - ASM codes\GPIO\test0\DTCM.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => Write_Ena,
		clock0 => write_clock,
		address_a => MEM_address,
		data_a => write_data,
		q_a => read_data	);
-- Load memory address register with write clock
		write_clock <= NOT clock;
END behavior;

