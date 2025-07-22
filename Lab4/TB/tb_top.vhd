library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_top is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
end tb_top;
-------------------------------------------------------------------------------
architecture rtb_top of tb_top is
	type mem is array (0 to 19) of std_logic_vector(4 downto 0);
	SIGNAL Y,X:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALUFN :  STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL ALUout:  STD_LOGIC_VECTOR(n-1 downto 0); -- ALUout[n-1:0]&Cflag
	SIGNAL Nflag,Cflag,Zflag,Vflag: STD_LOGIC; -- Zflag,Cflag,Nflag,Vflag
    SIGNAL PWM_out: STD_LOGIC;
    SIGNAL tb_clk, tb_rst, tb_ena: STD_LOGIC;
	SIGNAL cache : mem := (
							"01000","01001","01010","01011","01001","01010","01000","01001","10000","10001",
							"10010","10000","10001","10010","11001","11010","11101","11111","11011","00100");
	
begin
	L0 : top generic map (n) port map(tb_clk, tb_rst, tb_ena, Y, X, ALUFN, ALUout, Nflag, Cflag, Zflag, Vflag, PWM_out);
   
    -- Clock generation process
   gen_clk : process
   begin
       tb_clk <= '1';
       wait for 50 ns;
       tb_clk <= '0';
       wait for 50 ns;
   end process;

   -- Reset process
   gen_rst : process
   begin
       tb_rst <= '1', '0' after 100 ns;
       wait;
   end process;
   tb_ena <= '1';
--------- start of stimulus section ----------------------------------------
        tb_top : process
        begin
------------------ Edge case 1: All ones-----------------------------
			ALUFN <= (others => '0');
			x <= (others => '1');
            X(0) <= '0';
            X(2) <= '0';
            X(4) <= '0';
            X(6) <= '0';
            x(7) <= '0';
			y <= (others => '1');
			wait for 25 ns;
			for j in 0 to 19 loop
				ALUFN <= cache(j);
				wait for 25 ns;
			end loop;		  					  
			
----------------- Edge case 2: single bit is set-------------------
			ALUFN <= (others => '0');
			y <= (others => '0');	
			x <= (others => '0');
		    y(n-1) <= '1'; 
			x(0) <= '1';
			wait for 25 ns;
			for j in 0 to 19 loop
				ALUFN <= cache(j);
				wait for 25 ns;
			end loop;
			
----------------- Edge case 2: X is 0-------------------------------
			ALUFN <= (others => '0');
			x <= (others => '0');
			y <= (others => '1');
			y(0) <= '0';
			y(2) <= '0';
			y(4) <= '0';
			y(6) <= '0';
			
			wait for 25 ns;
			for j in 0 to 19 loop
				ALUFN <= cache(j);
				wait for 25 ns;
			end loop;
			
----------------- Edge case PMW: mode 0---------------------------------
            ---ALUFN
            ALUFN <= (others => '0');
            -----X
            X(7 downto 0) <= (others => '1');
            X(0) <= '0';
            X(2) <= '0';
            X(4) <= '0';
            X(6) <= '0';
            x(7) <= '0';
            y(7 downto 6)  <= "00";

            ----- Y
            Y(5 downto 0) <= (others => '1');
            wait for 26000 ns;


            -- Edge case PMW: mode 1
            -- ALUFN
            ALUFN(4 downto 0) <= (others => '0');
            ALUFN(0) <= '1';

            -- X
            X(7 downto 0) <= (others => '1');
            X(0) <= '0';
            X(2) <= '0';
            X(4) <= '0';
            X(6) <= '0';
            x(7) <= '0';
            -- Y
            y(7 downto 6)  <= "00";
            Y(5 downto 0) <= (others => '1');
            wait for 26000 ns;

            -- Edge case PMW: wrong mode "010"/"111"
            -- ALUFN
            ALUFN(4 downto 0) <= (others => '0');
            ALUFN(2 downto 0) <= "010";

            -- X
            X(7 downto 0) <= (others => '1');
            X(0) <= '0';
            X(2) <= '0';
            X(4) <= '0';
            X(6) <= '0';
            x(7) <= '0';
            -- Y
            y(7 downto 6)  <= "00";
            Y(5 downto 0) <= (others => '1');
            wait for 26000 ns;

            ALUFN(4 downto 0) <= (others => '0');
            ALUFN(2 downto 0) <= "111";

            -- X
            X(7 downto 0) <= (others => '1');
            X(0) <= '0';
            X(2) <= '0';
            X(4) <= '0';
            X(6) <= '0';
            x(7) <= '0';
            -- Y
            y(7 downto 6)  <= "00";
            Y(5 downto 0) <= (others => '1');
            wait for 26000 ns;

                wait; -- Wait indefinitely after all edge cases are tested
    end process tb_top;    


end architecture rtb_top;