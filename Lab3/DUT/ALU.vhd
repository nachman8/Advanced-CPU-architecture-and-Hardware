LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
---------------ALU MODULE----------------
ENTITY ALU IS
  GENERIC (BusSize : INTEGER := 16);
  PORT ( A,B	  				  : IN STD_LOGIC_VECTOR (BusSize-1 DOWNTO 0);
		 OPC 					  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         Cflag, Zflag, Nflag	  :	OUT STD_LOGIC;
         S		  				  :	OUT STD_LOGIC_VECTOR(BusSize-1 downto 0));
END ALU;
-------------ALU Architecture----------------------------
ARCHITECTURE dataflow OF ALU IS
	SIGNAL A_sig, B_sig: std_logic_vector(BusSize-1 DOWNTO 0);
	SIGNAL cin : std_logic;
    SIGNAL cout : std_logic;
	SIGNAL S_sig : std_logic_vector(BusSize-1 DOWNTO 0) := (others => '0');
    SIGNAL XOR_sig : std_logic_vector(BusSize-1 DOWNTO 0) := (others => '0');
    SIGNAL OR_sig : std_logic_vector(BusSize-1 DOWNTO 0) := (others => '0');
    SIGNAL AND_sig : std_logic_vector(BusSize-1 DOWNTO 0) := (others => '0');
	constant zero : std_logic_vector(BusSize-1 downto 0) := (others => '0');
BEGIN
    cin <= '1' WHEN (OPC = "0001") ELSE '0'; -- cin for 2's compliment
    A_sig <= A;

    B_calculation : for i in 0 to BusSize-1 generate
        B_sig(i) <= (B(i) xor '1') when (OPC = "0001") ELSE B(i); -- prepare B to 2's compliment if needed
        end generate;
    Signal_Adder: Adder generic map(n => BusSize) port map(
        a => A_sig,
        b => B_sig,
        cin => cin,
        s => S_sig,
        cout => cout
    );
    Xor_calculation: for i in 0 to BusSize-1 generate
        XOR_sig(i) <= A_sig(i) xor B_sig(i);     
        end generate;

    Or_calcualtion: for i in 0 to BusSize-1 generate
        OR_sig(i) <= A_sig(i) or B_sig(i); 
        end generate;
    AND_calcualtion: for i in 0 to BusSize-1 generate
        AND_sig(i) <= A_sig(i) AND B_sig(i); 
        end generate;

    Zflag <= unaffected when (OPC = "1111") ELSE '1' WHEN (S_sig = zero) ELSE '0';
    Nflag <= unaffected when (OPC = "1111") ELSE S_sig(BusSize-1);
    CFlag <= cout when (OPC = "0000" or OPC = "0001") else unaffected;

    S <=XOR_sig WHEN (OPC = "0100") ELSE
        OR_sig  WHEN (OPC = "0011") ELSE
        AND_sig WHEN (OPC = "0010") ELSE
        S_sig;
END dataflow;

        
