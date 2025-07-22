library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
use ieee.numeric_std.all;

-- n-bit counter
entity Basic_Timer is
    GENERIC (n: INTEGER := 32);
    port (
        BTCCR0, BTCCR1: in std_logic_vector(n-1 downto 0);
        MCLK, Reset, BTOUTEN, BTOUTMD, BTHOLD, BTSSEL0, BTSSEL1, BTIP0, BTIP1, BTIP2, BTCL0_ENA, BTCL1_ENA: in std_logic;
        IRQ_2                            : in std_logic;
        PWMout, Set_BTIFG                : out std_logic;
        BTCNT_out : out std_logic_vector(n-1 downto 0)); 
        
end Basic_Timer;
architecture dataflow of Basic_Timer is
    signal BTCL0, BTCL1, counter: std_logic_vector(n-1 downto 0):= (others => '0');
    signal CLK_Select, PWM_s : std_logic := '0';
    signal MCLK_2, MCLK_4, MCLK_8 : std_logic := '0';
begin
    BTCL0 <= BTCCR0 when Reset = '0' else (others => '0');
    BTCL1 <= BTCCR1 when Reset = '0' else (others => '0');

        ------------------ Flag ------------------------------
    Set_BTIFG <= counter(n-1) when (BTIP2 = '0' and BTIP1 = '0' and BTIP0 = '0') else
                counter(n-5)  when (BTIP2 = '0' and BTIP1 = '0' and BTIP0 = '1') else
                counter(n-9)  when (BTIP2 = '0' and BTIP1 = '1' and BTIP0 = '0') else
                counter(n-13) when (BTIP2 = '0' and BTIP1 = '1' and BTIP0 = '1') else
                counter(n-17) when (BTIP2 = '1' and BTIP1 = '0' and BTIP0 = '0') else
                counter(n-21) when (BTIP2 = '1' and BTIP1 = '0' and BTIP0 = '1') else
                counter(n-25) when (BTIP2 = '1' and BTIP1 = '1' and BTIP0 = '0') else
                counter(n-27) when (BTIP2 = '1' and BTIP1 = '1' and BTIP0 = '1') else
                '0';
    ------- clock division -------
    MCLK_div2: process(MCLK, Reset)
    begin
        if (Reset = '1') then
            MCLK_2 <= '0';
        elsif (rising_edge(MCLK)) then
            MCLK_2 <= not MCLK_2;
        end if;
    end process;
        
    MCLK_div4: process(MCLK_2, Reset)
    begin
        if (Reset = '1') then
            MCLK_4 <= '0';
        elsif (rising_edge(MCLK_2)) then
            MCLK_4 <= not MCLK_4;
        end if;
    end process;

    MCLK_div8: process(MCLK_4, Reset)
    begin
        if (Reset = '1') then
            MCLK_8 <= '0';
        elsif (rising_edge(MCLK_4)) then
            MCLK_8 <= not MCLK_8;
        end if;
    end process;  
    ---------- clock source -------------
    CLK_Select <= MCLK when (BTSSEL1 = '0' and BTSSEL0 = '0') else
    MCLK_2 when (BTSSEL1 = '0' and BTSSEL0 = '1') else
    MCLK_4 when (BTSSEL1 = '1' and BTSSEL0 = '0') else
    MCLK_8 when (BTSSEL1 = '1' and BTSSEL0 = '1');

    ------------------ PWM & Counter------------------------------
PWM_unit_counter: process(CLK_Select, Reset)
begin
    if (Reset = '1') then
        PWM_s <= '0';
        counter <= (others => '0'); 
    elsif (rising_edge(CLK_Select)) then 
        if IRQ_2 = '1' then
            counter <= (others => '0'); 
        elsif (BTHOLD = '0') then
            counter <= counter + 1;
        end if;
        if(BTOUTEN = '1' and BTCL0 > BTCL1) then
            if (counter < BTCL0) then
                if (counter < BTCL1) then
                    PWM_s <= '0';
                else
                    PWM_s <= '1';
                end if;
            else
                PWM_s <= '0';
                counter <= (others => '0');
            end if;
        elsif (BTCL0 = counter) then
            counter <= (others => '0');
        end if;

    end if;
    
end process;

BTCNT_out <= counter; 
PWMout <= PWM_s when BTOUTMD = '0' else not PWM_s; -- Invert the PWM signal if BTOUTMD = '1'


end dataflow;