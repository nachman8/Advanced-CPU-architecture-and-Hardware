library IEEE;
use ieee.std_logic_1164.all;

package aux_package is



	---------------MCU--------------------------------
	COMPONENT MCU IS
	GENERIC (MemWidth	: INTEGER:= 8;
			  SIM		: BOOLEAN:= TRUE);

			  
	PORT(clock_OG				    :IN 	STD_LOGIC;
		KEY_0						    :IN STD_LOGIC;	
		CtrlBus					:INOUT STD_LOGIC_VECTOR ( 1 DOWNTO 0 );	
     	AddrBus					:INOUT STD_LOGIC_VECTOR( 11 DOWNTO 0 );
		DataBus					:INOUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ) ;
        HEX0_out, HEX1_out, HEX2_out, HEX3_out, HEX4_out, HEX5_out
									:OUT  std_logic_vector(6 downto 0);
		SW_in                    :in  std_logic_vector(7 downto 0);
		LEDR_out                    :OUT  std_logic_vector(7 downto 0));
		
	END COMPONENT;

-------------- MIPS ---------------------------
	COMPONENT MIPS IS
	GENERIC  (MemWidth    : INTEGER:= 8;
			 SIM          : BOOLEAN:= TRUE);
	PORT( reset, clock					: IN 	STD_LOGIC; 
		-- Output important signals to pins for easy display in Simulator
		PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,	
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out, Zero_out,MemRead_out, MemWrite_out,
		Regwrite_out					: OUT 	STD_LOGIC ;

		------ GPIO Connection -------------------------
		CtrlBus						: INOUT		STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		AddrBus						: OUT		STD_LOGIC_VECTOR( 11 DOWNTO 0 );
		DataBus						: INOUT		STD_LOGIC_VECTOR( 31 DOWNTO 0 ));


	END COMPONENT;


--------------------------- GPIO ---------------------------
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
		A_vec                       : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
		CS                          : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
		--CS_LEDR, CS_SW              : OUT   STD_LOGIC;
		--CS_HEX01, CS_HEX23, CS_HEX45: OUT   STD_LOGIC
	);
	END COMPONENT;

	COMPONENT Seven_Segment IS
	GENERIC (SegmentSize	: integer := 7);
	PORT (data		: in STD_LOGIC_VECTOR (3 DOWNTO 0);
		  seg   		: out STD_LOGIC_VECTOR (SegmentSize-1 downto 0));
	END COMPONENT;

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



	------------MCU Tester ------------------
	COMPONENT MCU_tester IS
	GENERIC(IOSize : INTEGER := 8);
	PORT( 
		HEX0, HEX1			: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2, HEX3			: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4, HEX5			: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
		Switches			: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		clock       		: OUT   STD_LOGIC;
		ena					: OUT   STD_LOGIC;
		reset       : OUT   STD_LOGIC
   );
	END COMPONENT;
------------  PLL ------------------
	COMPONENT PLL is
		port (
			refclk   : in  std_logic := '0'; --  refclk.clk
			rst      : in  std_logic := '0'; --   reset.reset
			outclk_0 : out std_logic;        -- outclk0.clk
			locked   : out std_logic         --  locked.export
		);
	end COMPONENT;




end aux_package;

