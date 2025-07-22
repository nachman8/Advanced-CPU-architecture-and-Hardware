library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.aux_package.all;
-------------------------------------
entity stb is
constant n : integer := 8;
constant k : integer := 3;
end stb;

architecture testing of stb is
component Shifter is
    generic (
        n : integer := 8;
		k : integer := 3);
    port (
        X,Y  : in  std_logic_vector(n-1 downto 0);
        dir  : in  std_logic_vector(2 downto 0);
        cout : out  std_logic;  
        res  : out std_logic_vector(n-1 downto 0));
end component;
type mem is array (0 to 4) of std_logic_vector(7 downto 0);
signal dir : std_logic_vector(2 downto 0);
signal x,y : std_logic_vector (n-1 downto 0);
signal result : std_logic_vector(n-1 downto 0);
signal cout: std_logic;
SIGNAL Xcache : mem := ("00000000","00101101","11111111","01101001","11110000");
signal Ycache :mem  := ("10101101","10000001","01001111","00100111","10000001");
begin
		tester: Shifter GENERIC MAP(n,k)port map(x=>x,y=>y,dir=>dir,res=>result,cout=>cout); 
		testbench: process
begin
		dir<= "000";
		for iter in 0 to 4 loop
		x<= Xcache(iter) ;
		y<= Ycache(iter);
		if iter mod 4 = 1 then dir(0)<='1';
		end if;
		wait for 50ns;
		end loop;
		dir <= "010";
		wait;
		end process;
		
	end architecture testing;
		
		

