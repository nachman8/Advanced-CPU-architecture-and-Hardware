library ieee;
use ieee.std_logic_1164.all;
use work.aux_package.all;

ENTITY top IS
	generic( BusSize: integer:=16;	-- Data Memory In Data Size
    	RegSize: integer:=4;  	-- Address Size
		m: 	     integer:=16;  -- Program Memory In Data Size
		Awidth:  integer:=6);
	PORT(
        done_FSM : out std_logic;
        clk, rst, ena  : in STD_LOGIC;	
		
		-- Test Bench
        TBWriteEnableProgMem, TBWriteEnableDataMem : in std_logic;
		TBWriteAddressProgMem, TBWriteAddressDataMem, TBReadAddressDataMem :	in std_logic_vector(Awidth-1 downto 0);
        TBdataInProgMem  : in std_logic_vector(m-1 downto 0);
		TBdataInDataMem  : in std_logic_vector(BusSize-1 downto 0);
		TBdataOutDataMem : out std_logic_vector(BusSize-1 downto 0);
		TBactive	   : in std_logic
	);
END top;
----------------------------------------------------------
ARCHITECTURE behav OF top IS
signal		st, ld, mov, done, add, and_s, or_s, xor_s, sub, jmp, jc, jnc, Cflag, Zflag, Nflag:  std_logic;
signal		IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in :  std_logic;
signal		OPC :  std_logic_vector(3 downto 0);
signal 		PCsel, RFaddr :  std_logic_vector(1 downto 0);
begin
ControlUnit: Control 	port map(st=>st, ld=>ld, mov=>mov, done=>done, add=>add, and_s=>and_s, or_s=>or_s, xor_s=>xor_s, sub=>sub, jmp=>jmp, jc=>jc, jnc=>jnc, Cflag=>Cflag, Zflag=>Zflag, Nflag=>Nflag,
						IRin=>IRin, Imm1_in=>Imm1_in, Imm2_in=>Imm2_in, RFin=>RFin, RFout=>RFout, PCin=>PCin, Ain=>Ain, Cin=>Cin, Cout=>Cout, Mem_wr=>Mem_wr, Mem_out=>Mem_out, Mem_in=>Mem_in,
						OPC=>OPC, PCsel=>PCsel, RFaddr=>RFaddr,
						clk=>clk, rst=>rst, ena=>ena, done_FSM=>done_FSM);

DataPathUnit: Datapath generic map(BusSize)  port map(st=>st, ld=>ld, mov=>mov, done=>done, add=>add, and_s=>and_s, or_s=>or_s, xor_s=>xor_s, sub=>sub, jmp=>jmp, jc=>jc, jnc=>jnc,
                            Cflag=>Cflag, Zflag=>Zflag, Nflag=>Nflag, IRin=>IRin, Imm1_in=>Imm1_in, Imm2_in=>Imm2_in, RFin=>RFin, RFout=>RFout, PCin=>PCin, Ain=>Ain, Cin=>Cin, Cout=>Cout
							, Mem_wr=>Mem_wr, Mem_out=>Mem_out, Mem_in=>Mem_in, OPC=>OPC, PCsel=>PCsel, RFaddr=>RFaddr,
							TBactive=>TBactive, clk=>clk, rst=>rst, 
							TBWriteEnableProgMem=>TBWriteEnableProgMem, TBWriteEnableDataMem=>TBWriteEnableDataMem,
							TBdataInProgMem=>TBdataInProgMem, TBdataInDataMem=>TBdataInDataMem, TBWriteAddressProgMem=>TBWriteAddressProgMem, TBWriteAddressDataMem=>TBWriteAddressDataMem, TBReadAddressDataMem=>TBReadAddressDataMem,
							TBdataOutDataMem=>TBdataOutDataMem);
								

end behav;                                