library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	COMPONENT top is
	GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC 
	); -- Zflag,Cflag,Nflag,Vflag
	end COMPONENT;
------------Full-Adder Component------------------------  
	COMPONENT FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end COMPONENT;
------------Adder-Subtractor Component-------------------------	
	COMPONENT AdderSub IS
		GENERIC (n : INTEGER := 8);
		PORT (
			X,Y			: IN  std_logic_vector(n-1 DOWNTO 0);
			sub_cont    : IN  std_logic_vector(2 DOWNTO 0);
			cout        : OUT  std_logic; 
			s           : OUT std_logic_vector(n-1 DOWNTO 0)
		);
	end COMPONENT;

------------Shifter Component-------------------------	
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
------------Logic Component-------------------------	
	COMPONENT Logic IS
		GENERIC (n : INTEGER := 8);
		PORT (
			X,Y         : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			FN : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Operation selector
			res    : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
		);
	end COMPONENT;
	
	
	
	
end aux_package;

