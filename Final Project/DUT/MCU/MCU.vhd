				-- Top Level Structural Model for the project
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

ENTITY MCU IS
	GENERIC (MemWidth	: INTEGER:= 8;
			 SIM		: BOOLEAN:= TRUE;
			 CtrlBusSize	: integer := 8;
			 AddrBusSize	: integer := 12;
			 DataBusSize	: integer := 32;
			 IrqSize		: integer := 7;
			 RegSize		: integer := 8);

			  
	PORT(clock_OG				    :IN 	STD_LOGIC;
		KEY0,KEY1, KEY2, KEY3		:IN STD_LOGIC;
		CtrlBus						:INOUT STD_LOGIC_VECTOR ( 1 DOWNTO 0 );	
     	AddrBus						:INOUT STD_LOGIC_VECTOR( 11 DOWNTO 0 );
		DataBus						:INOUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ) ;
        HEX0_out, HEX1_out,
		HEX2_out, HEX3_out,
		HEX4_out, HEX5_out			:OUT  std_logic_vector(6 downto 0);
		SW_in                    	:in  std_logic_vector(7 downto 0);
		LEDR_out                    :OUT  std_logic_vector(7 downto 0));
		
END 	MCU;
-----------------------------------------------------------------------------------------

ARCHITECTURE structure OF MCU IS

	COMPONENT MIPS IS
		GENERIC (MemWidth	: INTEGER;
				SIM		: BOOLEAN);
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
	END 	COMPONENT;

------------------------------------------------------------------------------
COMPONENT INTERRUPT IS
	GENERIC(DataBusSize	: integer := 32;
			AddrBusSize	: integer := 12;
			IrqSize	    : integer := 7;
			RegSize		: integer := 8);
	PORT( 
			reset		: IN	STD_LOGIC;
			clock		: IN	STD_LOGIC;
			MemReadBus	: IN	STD_LOGIC;
			MemWriteBus	: IN	STD_LOGIC;
			AddressBus	: IN	STD_LOGIC_VECTOR(AddrBusSize-1 DOWNTO 0);
			DataBus		: INOUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
			IntrSrc		: IN	STD_LOGIC_VECTOR(IrqSize-1 DOWNTO 0); -- IRQ
			ChipSelect	: IN	STD_LOGIC;
			INTR		: OUT	STD_LOGIC;
			INTA		: IN	STD_LOGIC;
			IRQ_OUT		: OUT   STD_LOGIC_VECTOR(IrqSize-1 DOWNTO 0);
			INTR_Active	: OUT	STD_LOGIC;
			GIE			: IN	STD_LOGIC);
END COMPONENT;
------------------------------------------------------------------------------

	COMPONENT GPIO IS
	GENERIC(CtrlBusSize	: integer := 8;
			AddrBusSize	: integer := 12;
			DataBusSize	: integer := 32
			);
	PORT( 
		-- ControlBus	: IN	STD_LOGIC_VECTOR(CtrlBusSize-1 DOWNTO 0);
		MemReadBus					: IN 	STD_LOGIC;
		clock						: IN 	STD_LOGIC;
		reset						: IN 	STD_LOGIC;
		MemWriteBus					: IN 	STD_LOGIC;
		AddrBus						: IN	STD_LOGIC_VECTOR(AddrBusSize-1 DOWNTO 0);
		DataBus						: INOUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
		HEX0, HEX1					: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2, HEX3					: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4, HEX5					: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDR						: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		Switches					: IN	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
------------------------------------------------------------------------------	
	COMPONENT Basic_Timer_Control is
    GENERIC (Addr_Bus_Size: INTEGER := 12;
            Data_Bus_Size: INTEGER := 32);
	port (
		Clock, Reset: in std_logic;
		Data                    : inout std_logic_vector(Data_Bus_Size-1 downto 0);
		AddrBus					: IN STD_LOGIC_VECTOR(Addr_Bus_Size-1 DOWNTO 0);
		MemRead, MemWrite, BT_CS   : in std_logic;
		PWMout, Set_BTIFG       : out std_logic;
		IRQ_2                   : in std_logic); 
	END COMPONENT;
------------------------------------------------------------------------------
	COMPONENT Divide_Connection is
    port ( DIVCLK, Reset                : in STD_LOGIC;
        MemRead, MemWrite, Divider_CS   : in STD_LOGIC;
        DIVIFG                          : out STD_LOGIC; 
        AddrBus						    : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		DataBus						    : INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;


------------  PLL --------------------------------------------------------------------
COMPONENT PLL is
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		locked   : out std_logic         --  locked.export
	);
end COMPONENT;

------------------------------------------------------------------------------------------------------

	SIGNAL clock_OUT, clock_DIV			: STD_LOGIC;
	SIGNAL reset			: STD_LOGIC;
	SIGNAL PC                               : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL ALU_result_out, read_data_1_out, read_data_2_out, write_data_out, Instruction_out : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Branch_out, Zero_out, Memwrite_out, MemRead_out, Regwrite_out,IRQ_2 : STD_LOGIC;


	-- INTERRUPT MODULE --
	SIGNAL IntrEn		:	STD_LOGIC_VECTOR(RegSize-1 DOWNTO 0);
	SIGNAL IFG			:	STD_LOGIC_VECTOR(RegSize-1 DOWNTO 0);
	SIGNAL TypeReg		:	STD_LOGIC_VECTOR(RegSize-1 DOWNTO 0);
	SIGNAL IntrSrc		:	STD_LOGIC_VECTOR(IrqSize-1 DOWNTO 0);
	SIGNAL IRQ_OUT		:	STD_LOGIC_VECTOR(IrqSize-1 DOWNTO 0);
	--SIGNAL IntrTx		:	STD_LOGIC;
	--SIGNAL IntrRx		:	STD_LOGIC;
	SIGNAL INTR			:	STD_LOGIC;
	SIGNAL INTA			:	STD_LOGIC;  
	SIGNAL GIE			:	STD_LOGIC;
	SIGNAL INTR_Active	:	STD_LOGIC;
	SIGNAL CLR_IRQ		:	STD_LOGIC_VECTOR(5 DOWNTO 0);
	

	---- DIVIDER MODULE ----
	SIGNAL DIVIFG				:  	STD_LOGIC;
	SIGNAL Divider_CS			:  	STD_LOGIC;


	-- BASIC TIMER --
	SIGNAL BTIFG		:	STD_LOGIC;
	SIGNAL BT_CS			:  	STD_LOGIC;

	BEGIN
	reset <= not KEY0;
	------- CS-----
	Divider_CS <= '1' WHEN (AddrBus = X"82C") OR  (AddrBus = X"830") or (AddrBus = X"834") OR  (AddrBus = X"838") else '0';
	BT_CS <= '1' WHEN (AddrBus = X"81C") OR  (AddrBus = X"820") or (AddrBus = X"824") OR  (AddrBus = X"828") else '0';
	
						---  MIPS ----  
	MIPS_Int : MIPS
		GENERIC MAP(MemWidth => MemWidth, SIM => SIM)
		PORT MAP (	
					reset 			=> reset,
					clock 			=> clock_OUT,
					PC				=> PC,
					ALU_result_out => ALU_result_out,
					read_data_1_out => read_data_1_out,
					read_data_2_out => read_data_2_out,
					write_data_out => write_data_out,
					Instruction_out => Instruction_out,
					Branch_out => Branch_out,
					Zero_out => Zero_out,
					MemRead_out => MemRead_out,
					Memwrite_out => Memwrite_out,
					Regwrite_out => Regwrite_out,
					CtrlBus 	=> CtrlBus,
					GIE			=> GIE,
					INTR        => INTR,
					INTA		=> INTA, 
					DataBus	=> DataBus,
					AddrBus => AddrBus );


	---------------GPIO interface---------------------------


	GPIO_Int : GPIO
		PORT MAP (	DataBus  => DataBus,
					MemWriteBus => CtrlBus(1),
					MemReadBus 	=> CtrlBus(0), 
					AddrBus     =>AddrBus,
					HEX0   		 =>HEX0_out,
					HEX1   		 =>HEX1_out,
					HEX2   		 =>HEX2_out,
					HEX3   		 =>HEX3_out,
					HEX4   		 =>HEX4_out,
					HEX5   		 =>HEX5_out,
					LEDR		 => LEDR_out,
					clock 		 => clock_OUT,  
					Switches     => SW_in,
					reset 		 => reset );
					

	
	    clock_OUT<=clock_OG;   --- for sim
		--clk_div : PLL
        --PORT MAP (    outclk_0     => clock_OUT,
        --            refclk      => clock_OG);				

	---- DIVIDER MODULE ----


	DIV_Int :Divide_Connection
		PORT MAP(	
			DIVCLK => clock_OG,  --- לטפל בקלוק של ה פי-אל-אל
			Reset => reset,
			DataBus  	=> DataBus,
			MemRead 	=> CtrlBus(0),
			MemWrite 	=> CtrlBus(1), 
			AddrBus     => AddrBus,
			DIVIFG 		=> DIVIFG,
			Divider_CS  => Divider_CS);
		


	------ INTERRUPT MODULE ------

	IntrSrc	<=    DIVIFG & (NOT KEY3) & (NOT KEY2) & (NOT KEY1) & BTIFG & '0' & '0';
	Intr_Controller: INTERRUPT
		GENERIC MAP(
						DataBusSize	=> DataBusSize,
						AddrBusSize	=> AddrBusSize,
						IrqSize		=> IrqSize,
						RegSize 	=> RegSize
					)
					PORT MAP(
						reset		=> reset,
						clock		=> clock_OUT,
						MemReadBus	=> MemRead_out,
						MemWriteBus	=> Memwrite_out,
						AddressBus	=> AddrBus,
						DataBus		=> DataBus,
						IntrSrc		=> IntrSrc,
						ChipSelect	=> '0',
						INTR		=> INTR,
						INTA		=> INTA,
						IRQ_OUT		=> IRQ_OUT,
						INTR_Active	=> INTR_Active,
						GIE			=> GIE
						);


						
	---------- BT MODULE ---------

	Basic_Timer: Basic_Timer_Control
		GENERIC MAP (Addr_Bus_Size => AddrBusSize,	
				Data_Bus_Size => DataBusSize)
		port MAP(
				Clock => clock_OUT,
				Reset => reset,
				Data => DataBus,
				AddrBus => AddrBus,
				MemRead => CtrlBus(0),
				MemWrite => CtrlBus(1),
				BT_CS => BT_CS,
				PWMout => open,
				Set_BTIFG => BTIFG,
				IRQ_2 => IRQ_OUT(2)
			); 




END structure;	