library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

--------------------------------------------------------------
entity Datapath is
generic( BusSize: integer:=16;   -- Bus Size
         RegSize: integer:=4;    -- Register Size
         m:       integer:=16;  -- Program Memory In Data Size
         Awidth:  integer:=6;    -- Address Size
         OffsetSize  : integer := 8;
         ImmidSize   : integer := 8;         
         dept:    integer:=64);  -- Program Memory Size
port(   
        -- Op Status Signals --
        st, ld, mov, done, add, sub, jmp, jc, jnc, xor_s, or_s, and_s, Cflag, Zflag, Nflag : out std_logic;  
        -- Control Signals --
        IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in : in std_logic;
        OPC : in std_logic_vector(3 downto 0);
        PCsel, RFaddr : in std_logic_vector(1 downto 0);    
        -- Test Bench Signals --
        TBactive, clk, rst : in std_logic;
        TBWriteEnableProgMem, TBWriteEnableDataMem : in std_logic;
        TBdataInProgMem    : in std_logic_vector(m-1 downto 0);
        TBdataInDataMem    : in std_logic_vector(BusSize-1 downto 0);
        TBWriteAddressProgMem, TBWriteAddressDataMem, TBReadAddressDataMem : in std_logic_vector(Awidth-1 downto 0);
        TBdataOutDataMem   : out std_logic_vector(BusSize-1 downto 0)
);

end Datapath;

--------------------------------------------------------------
architecture behav of Datapath is
-- Program Memory --
signal dataOutProgMem : std_logic_vector(BusSize-1 downto 0);
signal ReadAddressProgMem : std_logic_vector(OffsetSize-1 downto 0) := "00000000";

-- Data Memory --
signal dataOutDataMem, dataInDataMem : std_logic_vector(BusSize-1 downto 0);
signal WriteAddressDataMem : std_logic_vector(Awidth-1 downto 0);
signal ReadAddressDataMem : std_logic_vector(BusSize-1 downto 0);
signal WriteAddressDataMemMuxOut, ReadAddressDataMemMuxOut : std_logic_vector(Awidth-1 downto 0);
signal WriteEnableDataMem : std_logic;

-- Reg File --
signal WriteDataRF, ReadDataRF : std_logic_vector(BusSize-1 downto 0);
signal ReadWriteAddressRF : std_logic_vector(RegSize-1 downto 0);

-- ALU --
signal A, B, C : std_logic_vector(BusSize-1 downto 0);
signal CregisterOut : std_logic_vector(BusSize-1 downto 0);

-- IR --
signal IR_OffsetAddress : std_logic_vector(OffsetSize-1 downto 0);
signal IR_Immid : std_logic_vector(ImmidSize-1 downto 0);
signal IROp : std_logic_vector(RegSize-1 downto 0);

-- General Purpose Signals
signal Immidiate : std_logic_vector(BusSize-1 downto 0);

-- Bus Signal 
signal DataBUS : std_logic_vector(BusSize-1 downto 0);

begin 
----------------------------------------- PORT MAPS --------------------------------------------
-- Program Memory - (clk, memEn, WmemData, WmemAddr, RmemAddr, RmemData)
ProgMemModule: progMem generic map(BusSize, Awidth, dept) port map (clk, TBWriteEnableProgMem, TBdataInProgMem, TBWriteAddressProgMem, ReadAddressProgMem(5 downto 0), dataOutProgMem);
-- Data Memory    - (clk, memEn, WmemData, WmemAddr, RmemAddr, RmemData)
DataMemModule: dataMem generic map(BusSize, Awidth, dept) port map (clk, WriteEnableDataMem, dataInDataMem, WriteAddressDataMemMuxOut, ReadAddressDataMemMuxOut, dataOutDataMem);
-- Register File  - (clk, rst, WregEn, WregData, WregAddr, RregAddr, RregData)
RegFileModule: RF generic map(BusSize, RegSize) port map (clk, rst, RFin, WriteDataRF, ReadWriteAddressRF, ReadWriteAddressRF, ReadDataRF);
-- ALU            - (A, B, OPC, CFlag, Zflag, Nflag, C)
ALUModule: ALU generic map(BusSize) port map (A, B, OPC, CFlag, ZFlag, NFlag, C);
-- OPC Decoder    - (IRreg, st, ld, mov, done, add, sub, jmp, jc, jnc,xor_s, or_s, and_s)
OPCdecModule: OPCdecoder port map(IROp, st, ld, mov, done, add, sub, jmp, jc, jnc=>jnc, xor_s=>xor_s, or_s=>or_s, and_s=>and_s);
-- PC             - (IR_offset, PCsel, PCin, clk, PCout)
PCLogicModule: PC port map(IR_OffsetAddress, PCsel, PCin, clk, ReadAddressProgMem);
-- IR             - (dataOutProgMem, IRin, RFaddr, ReadWriteAddressRF, OffsetAddr, Immid, IROp)
IRModule: IR port map(dataOutProgMem, IRin, RFaddr, ReadWriteAddressRF, IR_OffsetAddress, IR_Immid, IROp);
--------------------------------------------------------------------------------------------------

------------------------------------------ Debug -------------------------------------------

process(clk, ReadAddressProgMem)
begin
    if rising_edge(clk) then
        report "************************************************"
        & LF & "*********Datapath Debug Section*****************"
        & LF & "time =      " & to_string(now) 
        & LF & "Immidiate = " & to_string(Immidiate)
        & LF & "A =         " & to_string(A)
        & LF & "B =         " & to_string(B)
        & LF & "C =         " & to_string(C)
        & LF & "Cflag =     " & to_string(CFlag)
        & LF & "Nflag =     " & to_string(NFlag)
        & LF & "Zflag =     " & to_string(ZFlag)          
        & LF & "OPC =       " & to_string(OPC)
        & LF & "CregisterOut =   " & to_string(CregisterOut)
        & LF & "***********************************************"
        & LF & "IRop =              " & to_string(IRop)
        & LF & "Write Data to RF =  " & to_string(WriteDataRF) 
        & LF & "Read Data from RF = " & to_string(ReadDataRF) 
        & LF & "ReadWriteAddressRF =          " & to_string(ReadWriteAddressRF) 
        & LF & "dataBus =           " & to_string(DataBUS) 
        & LF & "WriteAddressDataMem =     " & to_string(WriteAddressDataMem)     
        & LF & "dataInDataMem =     " & to_string(dataInDataMem)
        & LF & "**************** Status ***********************"
        & LF & "Mem_wr =    " & to_string(Mem_wr)
        & LF & "Cout =      " & to_string(Cout)
        & LF & "Cin =       " & to_string(Cin)
        & LF & "OPC =       " & to_string(OPC)
        & LF & "Ain =       " & to_string(Ain)
        & LF & "RFin =      " & to_string(RFin)
        & LF & "RFout =     " & to_string(RFout)
        & LF & "RFaddr =    " & to_string(RFaddr)
        & LF & "IRin =      " & to_string(IRin) 
        & LF & "PCin =      " & to_string(PCin) 
        & LF & "PCsel =     " & to_string(PCsel) 
        & LF & "Imm1_in =   " & to_string(Imm1_in) 
        & LF & "Imm2_in =   " & to_string(Imm2_in)
        & LF & "Mem_in =    "  & to_string(Mem_in) 
        & LF & "Mem_out =   " & to_string(Mem_out);
    end if;
end process;

----------------------------------------- BiDir Bus ------------------------------------------
BusConnectionToRF: BidirPin generic map(BusSize) port map(ReadDataRF, RFout, WriteDataRF, DataBUS);
BusConnectionToALU: BidirPin generic map(BusSize) port map(CregisterOut, Cout, B, DataBUS); 
BusConnectionToDataMem: BidirPin generic map(BusSize) port map(dataOutDataMem, Mem_out, ReadAddressDataMem, DataBUS);
BusConnectionToImm1: BidirPin generic map(BusSize) port map(Immidiate, Imm1_in, WriteDataRF, DataBUS);
BusConnectionToImm2: BidirPin generic map(BusSize) port map(Immidiate, Imm2_in, WriteDataRF, DataBUS);

-- Immidiate Sign Extension 
Immidiate <= SXT(IR_Immid, BusSize) when Imm1_in ='1' else
			 SXT(IR_Immid(RegSize-1 downto 0), BusSize) when Imm2_in ='1' else
             unaffected;

--------------- ALU Connections Register -------------------------
ALU_Registers: process(clk) 
begin
    if (clk'event and clk='1') then
        if (Ain = '1') then
            A <= DataBUS; 
        end if;
        if(Cin = '1') then
            CregisterOut <= C;
        end if;
    end if;
end process;

--------------- Data Memory Write ----------------
DataMem_Write: process(clk) 
begin
    if (clk'event and clk='1') then
        if (Mem_in = '1') then
            WriteAddressDataMem <= DataBUS(Awidth-1 downto 0);
        end if;
    end if;
end process;
----------------------------------------------------------------------------------------------

----- Test Bench Connections --------
-- Data Memory TB
WriteEnableDataMem       <= TBWriteEnableDataMem     when TBactive = '1'  else Mem_wr;
dataInDataMem     <= TBdataInDataMem   when TBactive = '1'  else DataBUS;
WriteAddressDataMemMuxOut <= TBWriteAddressDataMem   when TBactive = '1'  else WriteAddressDataMem;
ReadAddressDataMemMuxOut <= TBReadAddressDataMem   when TBactive = '1'  else ReadAddressDataMem(Awidth-1 downto 0);
TBdataOutDataMem  <= dataOutDataMem;

end behav;
