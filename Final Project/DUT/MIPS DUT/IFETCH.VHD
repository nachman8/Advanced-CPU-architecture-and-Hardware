-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
	GENERIC (MemWidth	: INTEGER;
			 SIM		: BOOLEAN);
	PORT(	Instruction 	: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			PC_out 	    	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			Next_PC_out		: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			BNE 			: IN 	STD_LOGIC;
			BEQ      	 	: IN 	STD_LOGIC;
			Jump_Add	    : IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			Jr_Add			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			Jump			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			Zero 			: IN 	STD_LOGIC;
			INTA			: IN	STD_LOGIC;
			ISR_start		: IN 	STD_LOGIC;
			ISR_ADRESS		: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			clock, reset 	: IN 	STD_LOGIC);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4 	 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL next_PC, PC_branch_plus4 : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Mem_Addr : STD_LOGIC_VECTOR( MemWidth-1 DOWNTO 0 );
	SIGNAL MEM_inst	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
BEGIN
	--process(INTA,ISR_start,clock) begin
	--	IF (rising_edge(CLOCK)) THEN
	--		if INTA = '0' then
	--			Instruction <= X"FC000000";
	--		else 
	--			Instruction <= MEM_inst;
	--		end if;
	--	end if;
	--end process;
	Instruction <= X"FC000000" WHEN INTA = '0' else
				   MEM_inst;
	Next_PC_out <= "00" & PC(9 downto 2);

	ModelSim: 
	IF (SIM = TRUE) GENERATE
			Mem_Addr <= next_PC;
	END GENERATE ModelSim;
	
	FPGA: 
	IF (SIM = FALSE) GENERATE
			Mem_Addr <= next_PC & "00";
	END GENERATE FPGA;

inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => MemWidth,
		--numwords_a => 1024,
		--lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = ITCM",
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\intelFPGA_lite\Final Project\Hanan Files\SW QA - ASM codes\GPIO\test0\ITCM.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 		=> MEM_inst );
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
					-- copy output signals - allows read inside module
		PC_out 			<= PC;
		PC_plus_4_out 	<= PC_plus_4;
						-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
       	PC_plus_4( 1 DOWNTO 0 )  <= "00";
		-- Mux to select Branch Address or PC + 4 
		PC_branch_plus4  <= Add_result  WHEN (( ( BEQ = '1' ) AND ( Zero = '1' )) or (( BNE = '1' ) AND ( Zero = '0' ))) ELSE
			                   PC_plus_4( 9 DOWNTO 2 );
						-- Mux to select jump or Branch_PC + 4        
		next_PC  <= X"00" WHEN Reset = '1' ELSE
				   jump_Add  WHEN Jump = "01" ELSE
				   Jr_Add  WHEN Jump = "10" ELSE
				   "00" & ISR_ADRESS(7 downto 2) WHEN INTA = '0' ELSE
			       PC_branch_plus4;
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ;
			ELSE 
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
	END PROCESS;
END behavior;


