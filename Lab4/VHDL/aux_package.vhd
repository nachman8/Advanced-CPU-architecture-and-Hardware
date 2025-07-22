library IEEE;
use ieee.std_logic_1164.all;
package aux_package is
---------------------analysis-------------------------
	COMPONENT analysis IS
	GENERIC (
                n : INTEGER := 8	
                ); 
	PORT 
	(   clk : in std_logic;
        Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC );
	end COMPONENT;

---------------------analysis2-------------------------
	COMPONENT TimeAnalysis2 IS
	GENERIC (
				n : INTEGER := 8	
				); 
	PORT 
	(   Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN : IN std_logic;
		clk, rst, ena : in std_logic;
		state: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		PWM_out: OUT STD_LOGIC
		);
	end COMPONENT;

---------------------ALU-------------------------

	COMPONENT ALU is
	GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC 
	);
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
COMPONENT Shifter is
    generic (
        n : integer := 8;
		k : integer := 3);
    port (
        X,Y  : in  std_logic_vector(n-1 downto 0);
        dir  : in  std_logic_vector(2 downto 0);
        cout : out  std_logic;  
        res  : out std_logic_vector(n-1 downto 0));
end COMPONENT;
------------Logic Component-------------------------	
	COMPONENT Logic IS
		GENERIC (n : INTEGER := 8);
		PORT (
			X,Y         : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			FN : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Operation selector
			res    : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
		);
	end COMPONENT;

------------Seven_Segment Component-------------------------	
COMPONENT Seven_Segment IS
  GENERIC (	n			: INTEGER := 4;
			SegmentSize	: integer := 7);
  PORT (data		: in STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		seg   		: out STD_LOGIC_VECTOR (SegmentSize-1 downto 0));
END COMPONENT;	

------------counter Component-------------------------	

COMPONENT counter is port (
	clk, enable : in std_logic;	
	q   : out std_logic); 
end COMPONENT;
	
------------IO_interface Component-------------------------	

COMPONENT IO_interface IS
  GENERIC (	HEX_num : integer := 7;
			n : INTEGER := 8
			); 
  PORT (
		  clk  : in std_logic; 
		  -- Switch Port
		  SW_i : in std_logic_vector(n-1 downto 0);
		  -- Keys Ports
		  KEY0, KEY1, KEY2, KEY3 : in std_logic;
		  -- 7 segment Ports
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(HEX_num-1 downto 0);
		  -- Leds Port
		  LEDs : out std_logic_vector(9 downto 0);
          -- PMW Port
          PWM_out : out std_logic
  );
END COMPONENT;

------------PMW Component-------------------------	


COMPONENT PWM IS
GENERIC (n : INTEGER := 8); 
PORT (
	Y_i, X_i: IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
	ALUFN, ena, rst, clk: IN STD_LOGIC;
	state: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
  PWM_out: OUT STD_LOGIC
);
END COMPONENT;

----------TOP-------------------
COMPONENT Top IS
  GENERIC (	
			n : INTEGER := 8
			); 
  PORT (
		  clk, rst, ena  : in std_logic; 
		  
		  Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
          ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
          ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
          Nflag_o, Cflag_o, Zflag_o, Vflag_o: OUT STD_LOGIC;
          PWM_out : out std_logic);
END COMPONENT;


-------PLL-----------------
COMPONENT PLL is
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		locked   : out std_logic         --  locked.export
	);
end COMPONENT;
	
	
	
end aux_package;

