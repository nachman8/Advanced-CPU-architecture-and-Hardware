LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
-------------------------------------
ENTITY AdderSub IS
	GENERIC (n : INTEGER := 8);
    PORT (
        X,Y			: IN  std_logic_vector(n-1 DOWNTO 0);
        sub_cont    : IN  std_logic_vector(2 DOWNTO 0);
        cout        : OUT  std_logic; 
        s           : OUT std_logic_vector(n-1 DOWNTO 0)
    );
end AdderSub;

architecture dataflow of AdderSub is
    signal reg : std_logic_vector(n-1 DOWNTO 0);
	signal x_temp, y_temp : std_logic_vector(n-1 DOWNTO 0);
	signal cin : std_logic; 
BEGIN
--------- carry is the LSB of subcont---------------------------------
    cin <= sub_cont(0) WHEN (sub_cont = "000" OR sub_cont = "001") ELSE
							'1' WHEN (sub_cont = "010") ELSE							
							'0';
------ Generate x_temp and y_temp using loops---------
    x_gen : FOR i IN 0 TO n-1 GENERATE
        x_temp(i) <= (X(i) XOR sub_cont(0)) WHEN (sub_cont = "000" OR sub_cont = "001") ELSE
					 (X(i) XOR '1') WHEN (sub_cont = "010") ELSE
					 'Z' WHEN (sub_cont = "ZZZ") ELSE
					 '0';
    END GENERATE;


	y_temp <= 	Y WHEN (sub_cont = "000" OR sub_cont = "001") ELSE
				(OTHERS => 'Z') WHEN (sub_cont = "ZZZ") ELSE
				(OTHERS => '0');

	
	first : FA port map(
		xi => x_temp(0),
		yi => y_temp(0),
		cin => cin,
		s => s(0),
		cout => reg(0)
	);
	
	rest : for i in 1 to n-1 generate
		chain : FA port map(
			xi => x_temp(i),
			yi => y_temp(i),
			cin => reg(i-1),
			s => s(i),
			cout => reg(i)
		);
	end generate;
	
	cout <= reg(n-1);

END dataflow;


	
