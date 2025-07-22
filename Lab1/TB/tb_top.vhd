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
	SIGNAL cache : mem := (
							"01000","01001","01010","01000","01001","01010","01000","01001","10000","10001",
							"10010","10000","10001","10010","11001","11010","11101","11111","11011","00100");
	
begin
	L0 : top generic map (n,k,m) port map(Y,X,ALUFN,ALUout,Nflag,Cflag,Zflag,Vflag);
   
--------- start of stimulus section ----------------------------------------
        tb_top : process
        begin
------------------ Edge case 1: All ones-----------------------------
			ALUFN <= (others => '0');
			x <= (others => '1');
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
			
			     wait; -- Wait indefinitely after all edge cases are tested
    end process tb_top;

end architecture rtb_top;