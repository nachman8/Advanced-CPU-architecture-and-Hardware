library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tb_logic is
    constant n : integer := 8;
end tb_logic;

architecture rtl of tb_logic is

    signal x, y, Res : STD_LOGIC_VECTOR (n-1 downto 0);
    signal ALUFN : STD_LOGIC_VECTOR (2 downto 0);

begin

    L0 : Logic generic map (n) port map (x, y, ALUFN, Res);
    
    --------- start of stimulus section ------------------    
    tb_logic : process
    begin
        -- Test case 1: Alternating bits (01010101 for x and 10101010 for y)
        ALUFN <= "000";
        x <= "01010101";
        y <= "10101010";
        for k in 0 to 7 loop
            wait for 50 ns;
            ALUFN <= ALUFN + 1;
        end loop;

        -- Test case 2: All ones
        ALUFN <= "000";
        x <= (others => '1');
        y <= (others => '1');
        for k in 0 to 7 loop
            wait for 50 ns;
            ALUFN <= ALUFN + 1;
        end loop;

        -- Test case 3: Random pattern (11001100 for x and 00110011 for y)
        ALUFN <= "000";
        x <= "11001100";
        y <= "00110011";
        for k in 0 to 7 loop
            wait for 50 ns;
            ALUFN <= ALUFN + 1;
        end loop;

        -- Test case 4: First half zeros, second half ones
        ALUFN <= "000";
        x <= (others => '0');
        y <= (others => '0');
        for i in (n/2) to n-1 loop
            x(i) <= '1';
            y(i) <= '1';
        end loop;
        for k in 0 to 7 loop
            wait for 50 ns;
            ALUFN <= ALUFN + 1;
        end loop;

        -- Test case 5: All zeros
        ALUFN <= "000";
        x <= (others => '0');
        y <= (others => '0');
        for k in 0 to 7 loop
            wait for 50 ns;
            ALUFN <= ALUFN + 1;
        end loop;

        -- Test case 6: Inverted alternating bits (10101010 for x and 01010101 for y)
        ALUFN <= "000";
        x <= "10101010";
        y <= "01010101";
        for k in 0 to 7 loop
            wait for 50 ns;
            ALUFN <= ALUFN + 1;
        end loop;

        -- Test case 7: First half ones, second half zeros
        ALUFN <= "000";
        x <= (others => '0');
        y <= (others => '0');
        for i in 0 to (n/2)-1 loop
            x(i) <= '1';
            y(i) <= '1';
        end loop;
        for k in 0 to 7 loop
            wait for 50 ns;
            ALUFN <= ALUFN + 1;
        end loop;

        -- Test case 8: One bit set (x = 00000001, y = 10000000)
        ALUFN <= "000";
        x <= (others => '0');
        y <= (others => '0');
        x(0) <= '1';
        y(n-1) <= '1'; 
        for k in 0 to 7 loop
            wait for 50 ns;
            ALUFN <= ALUFN + 1;
        end loop;

        wait; -- Wait indefinitely after all edge cases are tested
    end process tb_logic;

end architecture rtl;
