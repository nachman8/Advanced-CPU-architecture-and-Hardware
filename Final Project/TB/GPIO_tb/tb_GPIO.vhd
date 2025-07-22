library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;

LIBRARY work;


entity tb_GPIO is
end tb_GPIO;

architecture struct of tb_GPIO is

    -- Signals to connect to the DUT
    signal Data_inout     : std_logic_vector(31 downto 0) := (others => '0');
    signal Address        : std_logic_vector(11 downto 0) := (others => '0');
    signal MemRead        : std_logic := '0';
    signal MemWrite       : std_logic := '0';
    signal SW_in          : std_logic_vector(7 downto 0) := (others => '0');
    signal HEX0_out       : std_logic_vector(6 downto 0);
    signal HEX1_out       : std_logic_vector(6 downto 0);
    signal HEX2_out       : std_logic_vector(6 downto 0);
    signal HEX3_out       : std_logic_vector(6 downto 0);
    signal HEX4_out       : std_logic_vector(6 downto 0);
    signal HEX5_out       : std_logic_vector(6 downto 0);
    signal LEDR_out       : std_logic_vector(7 downto 0);
    signal RST            : std_logic := '0';
    signal CLK            : std_logic := '0';

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
		AddrBus					: IN	STD_LOGIC_VECTOR(AddrBusSize-1 DOWNTO 0);
		DataBus						: INOUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
		HEX0, HEX1					: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2, HEX3					: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4, HEX5					: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDR						: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		Switches					: IN	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;


    FOR ALL : GPIO USE ENTITY work.GPIO;

begin

    CLK_GEN: process
        begin
            CLK <= '1';
            while true loop
                wait for 5 ns;
                CLK <= not CLK;
            end loop;
            wait;
        end process;
    -- Instantiate the DUT
    DUT: GPIO
        generic map (
            CtrlBusSize => 8,
            AddrBusSize => 12,
            DataBusSize => 32
        )
        port map (
            MemReadBus => MemRead,
            clock => CLK,
            reset => RST,
            MemWriteBus => MemWrite,
            AddrBus => Address,
            DataBus => Data_inout,
            HEX0 => HEX0_out,
            HEX1 => HEX1_out,
            HEX2 => HEX2_out,
            HEX3 => HEX3_out,
            HEX4 => HEX4_out,
            HEX5 => HEX5_out,
            LEDR => LEDR_out,
            Switches => SW_in
        );

    

    -- Stimulus process
    stim_proc: process
    begin
        RST <= '1';
        wait for 10 ns;
        RST <= '0';
        -- Test case 1
        Address <= X"800"; 
        Data_inout <= X"000000AB"; -- Data to write
        MemWrite <= '1';
        wait for 10 ns;
        MemWrite <= '0';
        wait for 10 ns;
        Data_inout <= X"00000038";
        wait for 10 ns;
        -- Test case 2
        Data_inout <= (others => 'Z');
        MemRead <= '1';
        wait for 10 ns;
        MemRead <= '0';
        -- Test case 3
        Address <= X"804"; --
        Data_inout <= X"00000564"; -- Data to write
        MemWrite <= '1';
        wait for 10 ns;
        
        MemWrite <= '0';
        wait for 10 ns;
        Data_inout <= X"00000111"; -- Data to write

        -- Test case 4
        Data_inout <= (others => 'Z');
        MemRead <= '1';
        wait for 10 ns;
        MemRead <= '0';

     -- Test case 
     Address <= X"805"; -- 
     Data_inout <= X"BCD45545"; -- Data to write
     MemWrite <= '1';
     wait for 10 ns;
     Data_inout <= X"00000665"; -- Data to write
     MemWrite <= '0';
     wait for 10 ns;

     -- Test case 4: Read from HEX1
     Data_inout <= (others => 'Z');
     MemRead <= '1';
     wait for 10 ns;
     MemRead <= '0';



        -- Test case 5
        
        
        wait for 10 ns;

        

        -- Test case 6
        Address <= X"810"; -- Address for SW
        SW_in <= X"AD"; -- Data to write
        Data_inout <= (others => 'Z');
        MemRead <= '1';
        wait for 10 ns;
        MemRead <= '0';
        Data_inout <= X"FFFFFFFF";
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end struct;