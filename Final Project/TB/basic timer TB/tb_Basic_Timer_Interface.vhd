library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Basic_Timer_Interface is
end tb_Basic_Timer_Interface;

architecture behavior of tb_Basic_Timer_Interface is

    -- Component Declaration for the Unit Under Test (UUT)
    component Basic_Timer_Control is
    GENERIC (Addr_Bus_Size: INTEGER := 12;
            Data_Bus_Size: INTEGER := 32);
    port (
        Clock, Reset: in std_logic;
        Data                    : inout std_logic_vector(Data_Bus_Size-1 downto 0);
        AddrBus					: IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        MemRead, MemWrite, CS   : in std_logic;
        PWMout, Set_BTIFG       : out std_logic
    ); 
    end component;

    -- Inputs
    signal Clock: std_logic := '0';
    signal Reset: std_logic := '0';
    signal Data: std_logic_vector(31 downto 0) := (others => 'Z');
    signal AddrBus: std_logic_vector(11 downto 0);
    signal MemRead: std_logic := '0';
    signal MemWrite: std_logic := '0';
    signal CS: std_logic := '0';

    -- Outputs
    signal PWMout: std_logic;
    signal Set_BTIFG: std_logic;

    -- Clock period definition
    constant clk_period: time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Basic_Timer_Control
    generic map (
        Addr_Bus_Size => 12,
        Data_Bus_Size => 32)
    port map (
        Clock => Clock,
        Reset => Reset,
        Data => Data,
        AddrBus => AddrBus,
        MemRead => MemRead,
        MemWrite => MemWrite,
        CS => CS,
        PWMout => PWMout,
        Set_BTIFG => Set_BTIFG);

    -- Clock process definitions
    clk_process: process
    begin
        while true loop
            Clock <= '1';
            wait for clk_period/2;
            Clock <= '0';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        Data <= (others => '0');
        wait for clk_period;
        -- Reset the system
        Reset <= '1';
        wait for clk_period;
        Reset <= '0';
        wait for clk_period;

        -- Write to BTCCR0
        AddrBus <= X"824";
        Data <= x"00000008";
        CS <= '1';
        MemWrite <= '1';
        wait for clk_period;

        -- Write to BTCCR1
        AddrBus <= X"828";
        Data <= x"00000002";  -- Duty cycle = 25%
        wait for clk_period;

        -- Write to BTCTL
        
        AddrBus <= X"81c";
        Data(31 downto 8) <= (others => '0');
        Data(7 downto 0) <= "01000000";  -- Enable PWM, PWM mode 1, PWM output enable
        wait for clk_period;
        



        -- Check if BTCCR0 > BTCCR1
        --assert (to_integer(unsigned(Data)) > to_integer(unsigned(x"00005555"))) report "BTCCR0 is not greater than BTCCR1" severity error;

        -- End simulation
        wait;
    end process;

end behavior;