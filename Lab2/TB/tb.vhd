library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity myTB is
	constant n : integer := 12;
    constant m : integer := 3;
    constant k : integer := 2;   
end myTB;

architecture TB of myTB is
	SIGNAL rst,ena,clk : std_logic;
	SIGNAL x : std_logic_vector(n-1 downto 0);
	SIGNAL DetectionCode : integer range 0 to 3;
	SIGNAL detector : std_logic;
begin
    mapping : top generic map (n,m,k) port map(rst,ena,clk,x,DetectionCode,detector);

    CLOCK : process
    begin
      clk <= '0';
      wait for 50 ns;
      clk <= not clk;
      wait for 50 ns;
    end process;
    
    Enable : process
    begin
      ena <='0','1' after 200 ns;
      wait for 2000 ns;
      ena <= '0';
      wait for 300 ns;
      ena <= '1';
      wait;
    end process;
    
    X_generator : process
			variable k : integer := 0;
        begin
		  x <= (others => '0');
		  DetectionCode <= k;
		  for i in 0 to 7 loop
			wait for 100 ns;
			x <= x+k+1;
		  end loop;
		  k := k+1;
        end process;  
        
    Reset : process
    begin
        rst <='1','0' after 100 ns;
        wait for 1500 ns;
        rst <='1';
        wait for 100 ns;
        rst <='0';
        wait;
    end process;   

    end architecture TB;