library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
use ieee.numeric_std.all;

-- n-bit counter
entity Basic_Timer_tb is

end Basic_Timer_tb;

architecture Basic_Timer_tb_rtl of Basic_Timer_tb is
    constant n: INTEGER := 32;
    signal PWM_CNT_RST, CLK_to_BTCNT, RST_or_PWMRST_BTCNT : std_logic;
    signal BTCL0, BTCL1, counter_out: std_logic_vector(n-1 downto 0);
    signal q_clk_div: std_logic_vector(3 downto 0);


component Basic_Timer is
    GENERIC (n: INTEGER := 32);
    port (
        BTCCR0, BTCCR1: in std_logic_vector(n-1 downto 0);
        MCLK, Reset, BTOUTEN, BTOUTMD, BTHOLD, BTSSEL0, BTSSEL1, BTIP0, BTIP1, BTIP2, BTCL0_ENA, BTCL1_ENA: in std_logic;
        PWMout, Set_BTIFG                : out std_logic;
        BTCNT_out : out std_logic_vector(n-1 downto 0)); 
end component;

signal BTCCR0, BTCCR1 : std_logic_vector(n-1 downto 0);
signal MCLK, Reset, BTOUTEN, BTOUTMD, BTHOLD, BTSSEL0, BTSSEL1, BTIP0, BTIP1, BTIP2, BTCL0_ENA, BTCL1_ENA, PWMout, Set_BTIFG : std_logic; 

begin
    
L0: Basic_Timer generic map (n) port map(BTCCR0 =>BTCCR0, BTCCR1 =>BTCCR1, MCLK =>MCLK, Reset => Reset, BTOUTEN => BTOUTEN,
 BTOUTMD =>BTOUTMD, BTHOLD =>BTHOLD, BTSSEL0 =>BTSSEL0, BTSSEL1 =>BTSSEL1,
 BTIP0 =>BTIP0, BTIP1 =>BTIP1, BTIP2 =>BTIP2, BTCL0_ENA =>BTCL0_ENA, BTCL1_ENA =>BTCL1_ENA, PWMout =>PWMout, Set_BTIFG =>Set_BTIFG);



initialization_process: process
begin
    BTIP0 <= '1';
    BTIP1 <= '1';
    BTIP2 <= '1';
    BTCL0_ENA <= '0';
    BTCL1_ENA <= '0';
    Reset <= '0';
    BTHOLD <= '0';
    BTSSEL0 <= '0';
    BTSSEL1 <= '0';
    BTOUTEN <= '1';
    BTOUTMD <= '0';
    wait for 1 ns;
    Reset <= '1';
    wait for 0.5 ns;
    Reset <= '0';
    BTCL0_ENA <= '1';
    BTCL1_ENA <= '1';
    wait for 10 ns;
    BTOUTEN <= '0';
    wait for 10 ns;
    BTOUTEN <= '1';

    wait;
end process initialization_process;


CLK0: process
begin
    MCLK <= '0';
    for k in 0 to 10000 loop
        wait for 0.5 ns;
        MCLK <= not MCLK;
    end loop;
end process;




BTCCR: process
    variable BTCCR0_int : integer;
    variable BTCCR1_int : integer;
begin
    wait for 1 ns;
    for i in 1 to 20 loop        
         -- Convert BTCCR0 to integer
        BTCCR0_int := 2*i;
        BTCCR0 <= std_logic_vector(to_unsigned(BTCCR0_int, n));
        -- Perform division by 2
        BTCCR1_int := BTCCR0_int/2;
        -- Convert the result back to std_logic_vector
        BTCCR1 <= std_logic_vector(to_unsigned(BTCCR1_int, n));
        wait for (15 * i) * 1 ns;
    end loop;
    
   -- for i in 1 to 10 loop       
   --      -- Convert BTCCR0 to integer
   --     BTCCR0_int := 2*i;
   --      BTCCR0 <= std_logic_vector(to_unsigned(BTCCR0_int, n));
   --     -- Perform division by 2
   --     BTCCR1_int := BTCCR0_int/4;
   --     -- Convert the result back to std_logic_vector
   --     BTCCR1 <= std_logic_vector(to_unsigned(BTCCR1_int, n));
   --     wait for (20 * i + 3) * 1 ns;
   -- end loop;

   --     for i in 1 to 10 loop       
   --         -- Convert BTCCR0 to integer
   --        BTCCR0_int := 2*i;
   --         BTCCR0 <= std_logic_vector(to_unsigned(BTCCR0_int, n));
   --        -- Perform division by 2
   --        BTCCR1_int := BTCCR0_int*3/4;
   --        -- Convert the result back to std_logic_vector
   --        BTCCR1 <= std_logic_vector(to_unsigned(BTCCR1_int, n));
   --        wait for (20 * i + 3) * 1 ns;
   --    end loop;  

    wait;
end process;

end Basic_Timer_tb_rtl;

