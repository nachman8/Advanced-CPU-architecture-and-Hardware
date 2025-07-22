--------------- Input Peripheral Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY GPIO IS
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
END GPIO;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF GPIO IS



COMPONENT InputPeripheral IS
GENERIC(DataBusSize	: integer := 32);
PORT( 
	MemRead		: IN	STD_LOGIC;
	ChipSelect	: IN 	STD_LOGIC;
	Data		: OUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
	GPInput		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;


COMPONENT OutputPeripheral_LEDR IS
GENERIC (IOSize		: INTEGER := 8); -- 7 WHEN HEX, 8 WHEN LEDs
PORT( 
	MemRead		: IN	STD_LOGIC;
	clock		: IN 	STD_LOGIC;
	reset		: IN 	STD_LOGIC;
	MemWrite	: IN	STD_LOGIC;
	ChipSelect	: IN 	STD_LOGIC;
	Data		: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
	GPOutput	: OUT	STD_LOGIC_VECTOR(IOSize-1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT OutputPeripheral_HEX IS
GENERIC (IOSize		: INTEGER := 7); -- 7 WHEN HEX, 8 WHEN LEDs
PORT(
	A_0			: IN	STD_LOGIC;
	MemRead		: IN	STD_LOGIC;
	clock		: IN 	STD_LOGIC;
	reset		: IN 	STD_LOGIC;
	MemWrite	: IN	STD_LOGIC;
	ChipSelect	: IN 	STD_LOGIC;
	Data		: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
	GPOutput	: OUT	STD_LOGIC_VECTOR(IOSize-1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT OptAddrDecoder IS
PORT( 
	reset                       : IN    STD_LOGIC;
	AddrBus                     : IN  STD_LOGIC_VECTOR(11 DOWNTO 0);
	CS                          : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
	--CS_LEDR, CS_SW              : OUT   STD_LOGIC;
	--CS_HEX01, CS_HEX23, CS_HEX45: OUT   STD_LOGIC
);
END COMPONENT;








	---- CONTROL SIGNALS ----
	-- SIGNAL MemRead		: STD_LOGIC;
	-- SIGNAL MemWrite		: STD_LOGIC;
	--SIGNAL OADAddr		: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	---- GPIO SIGNALS ----
	--SIGNAL LEDR			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL CS : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL A_0 : std_logic;
	signal A_0_inverted : std_logic;
	
BEGIN
	A_0 <= AddrBus(0);
	A_0_inverted <= not(AddrBus(0));
	
	OAD : 	OptAddrDecoder
	PORT MAP(	reset		=> reset,
				AddrBus		=> AddrBus,
				CS => CS
				);
		
	--OADAddr <= AddrBus(11) & AddrBus(4 DOWNTO 2);
	
	--OAD : 	OptAddrDecoder
	--PORT MAP(	Address		=> OADAddr,
	--			ChipSelect 	=> ChipSelect);
		
	LED:	OutputPeripheral_LEDR
	GENERIC MAP(IOSize	 => 8)
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS(1),
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> LEDR
			);
	
	-- HEX0_CS	<=	ChipSelect(1) AND (NOT AddrBus(0));
	-- HEX1_CS	<=	ChipSelect(1) AND AddrBus(0);
	-- HEX2_CS	<=	ChipSelect(2) AND (NOT AddrBus(0));
	-- HEX3_CS	<=	ChipSelect(2) AND AddrBus(0);
	-- HEX4_CS	<=	ChipSelect(3) AND (NOT AddrBus(0));
	-- HEX5_CS	<=	ChipSelect(3) AND AddrBus(0);
	
	HEX0_7SEG:	OutputPeripheral_HEX
	GENERIC MAP(IOSize	 => 7)
	PORT MAP(	A_0			=> A_0_inverted,
				MemRead		=> MemReadBus,
				clock 		=> clock,	
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS(6),
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX0
			);
			
	HEX1_7SEG:	OutputPeripheral_HEX
	GENERIC MAP(IOSize	 => 7)
	PORT MAP(	A_0			=> A_0,
				MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS(6),
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX1
			);
	
	HEX2_7SEG:	OutputPeripheral_HEX
	GENERIC MAP(IOSize	 => 7)
	PORT MAP(	A_0			=> A_0_inverted,
				MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS(5),
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX2
			);
	
	HEX3_7SEG:	OutputPeripheral_HEX
	GENERIC MAP(IOSize	 => 7)
	PORT MAP(	A_0			=> A_0,
				MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS(5),
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX3
			);
			
	HEX4_7SEG:	OutputPeripheral_HEX
	GENERIC MAP(IOSize	 => 7)
	PORT MAP(	A_0			=> A_0_inverted,
				MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS(4),
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX4
			);
			
	HEX5_7SEG:	OutputPeripheral_HEX
	GENERIC MAP(IOSize	 => 7)
	PORT MAP(	A_0			=> A_0,
				MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS(4),
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX5
			);
	
	SW:			InputPeripheral
	PORT MAP(	MemRead		=> MemReadBus,
				ChipSelect	=> CS(7),
				Data		=> DataBus,
				GPInput		=> Switches
			);
		
	
END structure;