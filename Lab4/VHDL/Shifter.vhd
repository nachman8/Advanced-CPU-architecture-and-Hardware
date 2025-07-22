library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.aux_package.all;
-------------------------------------
entity Shifter is
    generic (
        n : integer := 8;
		k : integer := 3);
    port (
        X,Y  : in  std_logic_vector(n-1 downto 0);
        dir  : in  std_logic_vector(2 downto 0);
        cout : out  std_logic;  
        res  : out std_logic_vector(n-1 downto 0));
end Shifter;
----------Shifter Architecture-------------------------
architecture dataflow of Shifter is
subtype vector IS std_logic_vector (n-1 DOWNTO 0);
TYPE matrix IS ARRAY (k DOWNTO 0) OF vector;
SIGNAL MAT		: matrix; -- Store each shift step vector
SIGNAL cout_vector: std_logic_vector(k-1 downto 0);

begin
 --- insert given Y vector into MAT's first row, if we need to shift right inverse it.
 start: for j in 0 to n-1 generate
 MAT(0)(j) <= Y(n-j-1) WHEN dir = "001" else
			  Y(j)     WHEN dir = "000";
		end generate;
	--- for each row in MAT we insert the previous row with shifting accordingly to the row position and X bits		
	shifting: for iter in 1 to k generate
		--- insert zeros in shifted vector if X related bit is 1, else insert the vector values
		MAT(iter)(2**(iter -1) -1 downto 0) <= (others => '0') 		 		     WHEN X(iter -1) = '1' else
									MAT(iter -1) (2**(iter -1) - 1 downto 0)   WHEN X(iter -1) = '0';
		--- move the relevant values from the previous vector							
		MAT(iter)(n-1 downto 2**(iter -1)) <= MAT(iter -1)(n-1 - 2**(iter -1) downto 0) WHEN X(iter -1) = '1' else
											MAT(iter -1)(n-1 downto 2**(iter-1))      WHEN X(iter -1) = '0';
	end generate;
	cout_vector(0) <= mat(0)(n-1) when x(0) = '1' else
					'0';
	carry:for j in 1 to k-1 generate
	cout_vector(j)  <= mat(j)(n-2**(j)) when x(j) = '1' else
					   cout_vector(j-1);
			end generate;
	
	cout <= cout_vector(k-1)WHEN (dir = "000" or dir = "001") else
	'0';		
	
---result vector,inverse back the shifted vector if needed
result: for j in 0 to n-1 generate
res(j) <= MAT(k)(j)       WHEN dir = "000" else
		  MAT(k)(n-1-j)   WHEN dir = "001" else
		  '0';
   	    end generate;




end dataflow;
