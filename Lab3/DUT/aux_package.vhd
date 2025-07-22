LIBRARY ieee;
USE ieee.std_logic_1164.all;
----------------Package-------------------------------------
package aux_package is
---------------- ALU ----------------------------	  
Component ALU IS
  GENERIC (BusSize : INTEGER := 16);
  PORT( A,B	  				  : IN STD_LOGIC_VECTOR (BusSize-1 DOWNTO 0);
		    OPC 					  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Cflag, Zflag, Nflag	  :	OUT STD_LOGIC;
        S		  				  :	OUT STD_LOGIC_VECTOR(BusSize-1 downto 0));
END Component;
-----------------Adder-----------------------
Component Adder IS
  GENERIC (n : INTEGER := 8);
  PORT( a, b: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
        cin: IN STD_LOGIC;
        s: OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0);
        cout: OUT STD_LOGIC);
  END Component;

Component Control IS
	PORT(
		st, ld, mov, done, add, and_s, or_s, xor_s, sub, jmp, jc, jnc, Cflag, Zflag, Nflag : in std_logic;
		IRin, Imm1_in, Imm2_in, RFin, RFout, PCin, Ain, Cin, Cout, Mem_wr, Mem_out, Mem_in : out std_logic;
		OPC : out std_logic_vector(3 downto 0);
		PCsel, RFaddr : out std_logic_vector(1 downto 0);
		clk, rst, ena : in STD_LOGIC;
		done_FSM : out std_logic
	);
  END Component;

Component Datapath is
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
  end Component;

Component BidirPin is
    generic( width: integer:=16 );
    port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
        en:		in 		std_logic;
        Din:	out		std_logic_vector(width-1 downto 0);
        IOpin: 	inout 	std_logic_vector(width-1 downto 0)
    );
  end Component;

Component dataMem is
    generic( Dwidth: integer:=16;
         Awidth: integer:=6;
         dept:   integer:=64);
    port(	clk,memEn: in std_logic;	
        WmemData:	in std_logic_vector(Dwidth-1 downto 0);
        WmemAddr,RmemAddr:	
              in std_logic_vector(Awidth-1 downto 0);
        RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
    );
    end Component;  

Component ProgMem is
  generic( Dwidth: integer:=16;
      Awidth: integer:=6;
      dept:   integer:=64);
  port(	clk,memEn: in std_logic;	
      WmemData:	in std_logic_vector(Dwidth-1 downto 0);
      WmemAddr,RmemAddr:	
            in std_logic_vector(Awidth-1 downto 0);
      RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
  );
  end Component;

  Component RF is
  generic( Dwidth: integer:=16;
          Awidth: integer:=4);
  port(	clk,rst,WregEn: in std_logic;	
      WregData:	in std_logic_vector(Dwidth-1 downto 0);
      WregAddr,RregAddr:	
            in std_logic_vector(Awidth-1 downto 0);
      RregData: 	out std_logic_vector(Dwidth-1 downto 0)
  );
  end Component;

Component PC IS
 GENERIC(AddrSize		:INTEGER := 8;
        OffsetSize		:INTEGER := 8);
	PORT(	IRoffset 		:IN STD_LOGIC_VECTOR(OffsetSize -1 DOWNTO 0);
			PCsel			:IN STD_LOGIC_VECTOR(1 downto 0);
			PCin, clk		:IN STD_LOGIC;
			PCout			:OUT std_logic_vector(AddrSize -1 downto 0) := "000000"
			);
  end Component;

Component OPCdecoder is
  generic( RegSize: integer:=4);
	port(	IROp : in std_logic_vector(RegSize -1 downto 0);
			st, ld, mov, done, add, sub, jmp, jc, jnc, xor_s,or_s,and_s: out std_logic);
  end Component; 

Component IR is 
	generic(BusSize		: integer := 16;
			RegSize		: integer := 4;
			OffsetSize 	: integer := 8;
			ImmidSize	: integer := 8);

    port(dataout        : in  std_logic_vector(BusSize-1 downto 0);
         IRin	        : in  std_logic;
         RFaddr         : in  std_logic_vector(1 downto 0);
         OutAddrRF      : out std_logic_vector(RegSize-1 downto 0);
         OffsetAddr		: out std_logic_vector(OffsetSize-1 downto 0);
		 Immid			: out std_logic_vector(ImmidSize-1 downto 0);
		 IROp			: out std_logic_vector(RegSize-1 downto 0));
		 
    end Component;
  
Component top IS
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
  END Component;  
end aux_package;