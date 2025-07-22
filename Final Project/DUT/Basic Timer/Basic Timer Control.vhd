library ieee;
use ieee.std_logic_1164.all;


entity Basic_Timer_Control is
    GENERIC (Addr_Bus_Size: INTEGER := 12;
            Data_Bus_Size: INTEGER := 32);
    port (
        Clock, Reset: in std_logic;
        Data                    : inout std_logic_vector(Data_Bus_Size-1 downto 0);
        AddrBus					: IN STD_LOGIC_VECTOR(Addr_Bus_Size-1 DOWNTO 0);
        MemRead, MemWrite, BT_CS   : in std_logic;
        PWMout, Set_BTIFG       : out std_logic;
        IRQ_2                   : in std_logic                    
    ); 
end Basic_Timer_Control;

architecture Basic_Timer_CTL of Basic_Timer_Control is

    signal BTCCR0 : std_logic_vector(Data_Bus_Size-1 downto 0);
    signal BTCCR1 : std_logic_vector(Data_Bus_Size-1 downto 0);
    signal BTCTL : std_logic_vector(7 downto 0);
    signal BTCNT : std_logic_vector(Data_Bus_Size-1 downto 0);
    signal data_type :STD_LOGIC_VECTOR(2 downto 0);
   
    
    component Basic_Timer is
        GENERIC (n: INTEGER := 32);
        port (
            BTCCR0, BTCCR1: in std_logic_vector(n-1 downto 0);
            MCLK, Reset, BTOUTEN, BTOUTMD, BTHOLD, BTSSEL0, BTSSEL1, BTIP0, BTIP1, BTIP2, BTCL0_ENA, BTCL1_ENA: in std_logic;
            IRQ_2                            : in std_logic;
            PWMout, Set_BTIFG                : out std_logic;
            BTCNT_out : out std_logic_vector(n-1 downto 0)); 
    end component;
    begin
        data_type <= "000" when AddrBus = X"81C" else -- BTCTL
                     "001" when AddrBus = X"820" else -- BCTCNT
                     "010" when AddrBus = X"824" else -- BTCCR0
                     "011" when AddrBus = X"828" else -- BTCCR1
                     "ZZZ";
                    

    process(Clock, Reset)
    begin
        if Reset = '1' then
            BTCTL <= ("00100000");
            BTCNT <= (others => 'Z');
            BTCCR0 <= (others => '0');
            BTCCR1 <= (others => '0');
            Data <= (others => 'Z');
        elsif falling_edge(Clock) then
            if (BT_CS = '1') then
                    case data_type is
                        when "000" => BTCTL  <= Data(7 downto 0);
                        when "001" => BTCNT  <= Data;
                        when "010" => BTCCR0 <= Data;
                        when "011" => BTCCR1 <= Data;
                        when others =>
                            null;
                    end case;
            else
                Data <= (others => 'Z');
            end if;
        end if;
    end process;
        
        BT0: Basic_Timer Generic map (n => Data_Bus_Size) Port map (BTCCR0 => BTCCR0, BTCCR1 => BTCCR1, MCLK => Clock, Reset => Reset,
                                                                     BTOUTEN => BTCTL(6), BTOUTMD => BTCTL(7), BTHOLD => BTCTL(5), BTSSEL0 => BTCTL(3),
                                                                      BTSSEL1 => BTCTL(4), BTIP0 => BTCTL(0), BTIP1 => BTCTL(1), BTIP2 => BTCTL(2),
                                                                       BTCL0_ENA => '1', BTCL1_ENA => '1', PWMout => PWMout, IRQ_2 =>IRQ_2, Set_BTIFG => Set_BTIFG);

    end Basic_Timer_CTL;        