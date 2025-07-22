				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

ENTITY MIPS IS
	GENERIC  (MemWidth    : INTEGER;
			 SIM          : BOOLEAN);
	PORT( reset, clock					: IN 	STD_LOGIC; 
		-- Output important signals to pins for easy display in Simulator
		PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,	
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out, Zero_out,MemRead_out, MemWrite_out,
		Regwrite_out					: OUT 	STD_LOGIC;
		GIE								: OUT	STD_LOGIC;
		INTA							: OUT	STD_LOGIC;
		INTR							: IN	STD_LOGIC;

		------ GPIO Connection -------------------------
		CtrlBus						: INOUT		STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		AddrBus						: OUT		STD_LOGIC_VECTOR( 11 DOWNTO 0 );
		DataBus						: INOUT		STD_LOGIC_VECTOR( 31 DOWNTO 0 ));


END 	MIPS;

ARCHITECTURE structure OF MIPS IS

	COMPONENT Ifetch
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
	END COMPONENT; 

	COMPONENT Idecode
	  PORT(	read_data_1	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			MemtoReg 	: IN 	STD_LOGIC;
			RegDst 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			Jump_Add	: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			Jal 		: IN 	STD_LOGIC;
			PC_plus_4 	: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			Next_pc 	: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			Sign_extend : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			GIE			: OUT 	STD_LOGIC;
			INTA		: IN	STD_LOGIC;
			Jump 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			JAL_ISR		: IN 	STD_LOGIC;
			ISR_ADRESS 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			clock,reset	: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT control
	PORT( 	
		Opcode 			: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
		Func			: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
		RegDst 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- decide wether R31 or R (decode)
		ALUSrc 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- decide if Immediate or R inputs
		MemtoReg 		: OUT 	STD_LOGIC;
		RegWrite 		: OUT 	STD_LOGIC;
		MemRead 		: OUT 	STD_LOGIC;
		MemWrite 		: OUT 	STD_LOGIC;
		BEQ 			: OUT 	STD_LOGIC;
		BNE 			: OUT 	STD_LOGIC;
		Jal				: OUT 	STD_LOGIC;							-- for Decode
		JAL_ISR			: OUT 	STD_LOGIC;							-- for ISR jump
		Jump 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );		-- for Fetch and Decode
		ALUop 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		clock, reset	: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT  Execute
	PORT(	Read_data_1 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Func           	: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			Opcode 			: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALUOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ALUSrc 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			Zero 			: OUT	STD_LOGIC;
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			Jr_Add			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			clock, reset	: IN 	STD_LOGIC );
	END COMPONENT;


	COMPONENT dmemory
	GENERIC (MemWidth	: INTEGER;
			 SIM		: BOOLEAN);					
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset			: IN 	STD_LOGIC;
			JAL_ISR				: IN 	STD_LOGIC;
			DataBus				: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 ));
	END COMPONENT;

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_Mem 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc 			: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL BEQ 				: STD_LOGIC;
	SIGNAL BNE 				: STD_LOGIC;	
	SIGNAL RegDst 			: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL Zero 			: STD_LOGIC;
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemtoReg 		: STD_LOGIC;
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUop 			: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Jump 	     	: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL Jal 		        : STD_LOGIC;
	SIGNAL JAL_ISR			: STD_LOGIC;
	SIGNAL INTA_s			: STD_LOGIC;
	SIGNAL ISR_start		: STD_LOGIC;    -- indicator for PC <= ISR ADRESS
	SIGNAL Jr_Add			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Jump_Add			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ISR_ADRESS		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Next_pc			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );

BEGIN
					-- copy important signals to output pins for easy 
					-- display in Simulator
   Instruction_out 	<= Instruction;
   ALU_result_out 	<= ALU_result;
   read_data_1_out 	<= read_data_1;
   read_data_2_out 	<= read_data_2;
   write_data_out  	<= read_data WHEN MemtoReg = '1' ELSE ALU_result;
   Branch_out 		<= BEQ;
   Zero_out 		<= Zero;
   RegWrite_out 	<= RegWrite;
   MemWrite_out 	<= MemWrite;
   MemRead_out		<= MemRead;
					-- connect the 5 MIPS components  
					
	--------------------------------------------------------------------
	PROCESS (clock, INTR, reset)
		VARIABLE INTR_STATE 	: STD_LOGIC_VECTOR(1 DOWNTO 0);
	BEGIN
		IF reset = '1' THEN
			INTR_STATE 	:= "00";
			ISR_start <= '0';
			INTA_s 	<= '1';
		
		ELSIF (rising_edge(clock)) THEN
			IF (INTR_STATE = "00") THEN
				IF (INTR = '1') THEN
					INTA_s	<= '0';
					INTR_STATE	:= "01";
					--JAL_ISR     <= '1' happends in control
				END IF;
				
			ELSIF (INTR_STATE = "01") THEN		
				INTA_s	 <= '1';
				ISR_start <= '1';
				-- need to clear flags somehow
				INTR_STATE 	:= "10";
								
			ELSE 
				INTR_STATE 	:= "00";
				ISR_start <= '1';
			END IF;
		
		END IF;
	END PROCESS;				
	--------------------------------------------  
	INTA <= INTA_s;
	CtrlBus <=  "10" when MemWrite = '1' else
					"01" when MemRead = '1' else 
					"ZZ";
	AddrBus <=  ALU_result(11 downto 0)	when (MemWrite = '1' or MemRead = '1')	else (others => '0');
	DataBus	<= read_data_2	when (MemWrite = '1' AND ALU_result(11) = '1') else (others => 'Z');  ---- OUTPUT TO SFR
	read_data	<= DataBus WHEN (MemRead = '1' AND ALU_result(11) = '1' ) ELSE read_data_Mem;  ---- INPUT FROM SFR
	--------------------------------------------------------------------------
  IFE : Ifetch
  	GENERIC MAP(MemWidth => MemWidth, SIM => SIM) 
 	 PORT MAP (	Instruction 	=> Instruction,
    	    	PC_plus_4_out 	=> PC_plus_4,
				Add_result 		=> Add_result,
				BEQ 			=> BEQ,
				BNE        		=> BNE,
				Jump            => Jump,
				Zero 			=> Zero,
				PC_out 			=> PC, 
                Jump_Add		=> Jump_Add,
				Jr_Add          => Jr_Add,
				INTA			=> INTA_s, 
				ISR_start		=> ISR_start,
				ISR_ADRESS      => ISR_ADRESS,
				Next_PC_out		=> Next_pc,
				clock 			=> clock,  
				reset 			=> reset );

   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1,
        		read_data_2 	=> read_data_2,
        		Instruction 	=> Instruction,
        		read_data 		=> read_data,
				ALU_result 		=> ALU_result,
				RegWrite 		=> RegWrite,
				MemtoReg 		=> MemtoReg,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend,
				Jump_Add        => Jump_Add,
				Jal 			=> Jal,
				PC_plus_4		=> PC_plus_4,
				GIE				=> GIE,
				Jump            => Jump,
				ISR_ADRESS		=> ISR_ADRESS,
				JAL_ISR			=> JAL_ISR,
				INTA			=> INTA_s,
				Next_pc			=>Next_pc,
        		clock 			=> clock,  
				reset 			=> reset );


   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction ( 31 DOWNTO 26 ),
				Func           => Instruction ( 5 DOWNTO 0 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				BEQ 			=> BEQ,
				BNE 			=> BNE,
				ALUop 			=> ALUop,
				Jump 			=> Jump,
				Jal 			=> Jal,
				JAL_ISR			=> JAL_ISR,
                clock 			=> clock,
				reset 			=> reset );

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1,
             	Read_data_2 	=> read_data_2,
				Sign_extend 	=> Sign_extend,
				Func           => Instruction ( 5 DOWNTO 0 ),
                Opcode 			=> Instruction ( 31 DOWNTO 26 ),
				ALUOp 			=> ALUop,
				ALUSrc 			=> ALUSrc,
				Zero 			=> Zero,
                ALU_Result		=> ALU_result,
				Add_Result 		=> Add_Result,
				PC_plus_4		=> PC_plus_4,
				Jr_Add		    => Jr_Add,
                Clock		 	=> clock,
				Reset			=> reset );

   MEM:  dmemory
   GENERIC MAP(MemWidth => MemWidth, SIM => SIM) 
	PORT MAP (	read_data 		=> read_data_Mem, ---- 
				address 		=> ALU_result,--jump memory address by 4
				write_data 		=> read_data_2,
				MemRead 		=> MemRead, 
				Memwrite 		=> MemWrite,
				JAL_ISR         => JAL_ISR,
				DataBus			=> DataBus, 
                clock 			=> clock,  
				reset 			=> reset );
END structure;

