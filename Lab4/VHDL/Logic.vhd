LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------
ENTITY Logic IS
	GENERIC (n : INTEGER := 8);
    PORT (
        X,Y         : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        FN : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Operation selector
        res    : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
end Logic;

ARCHITECTURE dataflow OF Logic IS
BEGIN
    PROCESS(X, Y, FN)
    BEGIN
        CASE FN is
            WHEN "000" => res <= NOT Y;    -- NOT X
            WHEN "001" => res <= X OR Y;   -- OR
            WHEN "010" => res <= X AND Y;  -- AND
            WHEN "011" => res <= X XOR Y;  -- XOR
            WHEN "100" => res <= X NOR Y;  -- NOR
            WHEN "101" => res <= X NAND Y; -- NAND
            WHEN "111" => res <= X XNOR Y; -- XNOR
            WHEN OTHERS => res <= (OTHERS => '0'); -- Undefined operations
        END CASE;
    END PROCESS;
END dataflow;
