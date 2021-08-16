library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity iitb_risc is
	port(clk: in std_logic;
			reset : in std_logic  := '0');
end iitb_risc;

architecture behav of iitb_risc is

component alu is
	port (aluA: in std_logic_vector (15 downto 0);
			aluB: in std_logic_vector (15 downto 0);
			res: out std_logic_vector (15 downto 0):= X"0000";
			sel_oprn : in std_logic_vector (1 downto 0); -- select add or nand
			flush_jlr : in std_logic;
			Cout : out std_logic :='0';
			Zout : inout std_logic :='0';
			C_chk : in std_logic :='0';
			Z_chk : in std_logic :='0';
			instruction : in std_logic_vector (15 downto 0);
			control_wb_in : in std_logic_vector(6 downto 0) := "0000000";
			control_wb_out : out std_logic_vector(6 downto 0) := "0000000";
			flush_out: out std_logic := '0'
	 );
end component;

component sign_extension is 
port(
		se_9bit_in : in std_logic_vector(8 downto 0);
		se_sel : in std_logic_vector(1 downto 0); -- to select 9bit or 5 bit; 1 = 9 bit; 0 = 6 bit
		se_out : out std_logic_vector(15 downto 0));
end component;

component data_mem is
	port(addr : in std_logic_vector(15 downto 0);
		  wr_en : in std_logic_vector(1 downto 0);--1st bit read ; 0th bit write
		  din : in std_logic_vector(15 downto 0);
		  dout : out std_logic_vector(15 downto 0)
		 );
end component;

component pc_adder is
	port (
	inA: in std_logic_vector (15 downto 0):= X"0000";
	res: out std_logic_vector (15 downto 0):= X"0000"
			);
	 
end component;

component instr_mem is
	port (
			pc: in std_logic_vector(15 downto 0);
			instruction: out  std_logic_vector(15 downto 0)
		  );
end component;

component reg_file is
	port (
			clk : in std_logic;
			rA : out std_logic_vector (15 downto 0);
			rB : out std_logic_vector (15 downto 0);
			rW : in std_logic_vector  (15 downto 0 ):= X"0000";
			addrA : in std_logic_vector (2 downto 0):= B"000";
			addrB : in std_logic_vector (2 downto 0):= B"000";
			addrW : in std_logic_vector (2 downto 0):= B"000";
			rW_en : in std_logic :='0';
			r7_in : in std_logic_vector (15 downto 0);
			r7_out : out std_logic_vector (15 downto 0):=X"0000";
			r7_en : in std_logic := '0'
			);
end component;

component mux2_1 is
	port(in0 : in std_logic_vector(2 downto 0):=B"000";
		  in1	: in std_logic_vector(2 downto 0):=B"000";
		  sel : in std_logic;
		  op :  out std_logic_vector(2 downto 0)
		  );
end component;

component mux4_1x16 is
	port(in0 : in std_logic_vector(15 downto 0):=X"0000";
		  in1	: in std_logic_vector(15 downto 0):=X"0000";
		  in2 : in std_logic_vector(15 downto 0):=X"0000";
		  in3	: in std_logic_vector(15 downto 0):=X"0000";
		  sel : in std_logic_vector(1 downto 0);
		  op :  out std_logic_vector(15 downto 0)
		  );
end component;

component wb_logic is port(
	SE16 : in std_logic_vector ( 15 downto 0);
	ALU_out : in std_logic_vector ( 15 downto 0);
	mem_out : in std_logic_vector ( 15 downto 0);
	control_wb_in : in std_logic_vector ( 6 downto 0);
	C_flag_in : in std_logic;
	Z_flag_in : in std_logic;
	pc_next : in std_logic_vector ( 15 downto 0);
	
	wb_en : out std_logic;
	wb_data : out std_logic_vector (15 downto 0);
	wb_addr : out std_logic_vector (2 downto 0)
	);
end component;

component IF_ID is port(
	instruction_in : in std_logic_vector ( 15 downto 0);
	pc_now_in : in std_logic_vector ( 15 downto 0);
	pc_next_in : in std_logic_vector ( 15 downto 0);
	
	instruction_out : out  std_logic_vector ( 15 downto 0);
	pc_now_out : out std_logic_vector ( 15 downto 0);
	pc_next_out : out std_logic_vector ( 15 downto 0);
	
	f: in std_logic := '0'; -- flush
	s: in std_logic := '1'; -- stall
	clk: in std_logic;
	reset : in std_logic  := '0'
	);
end component;

component ID_RR is port(
	SE16_in : in std_logic_vector ( 15 downto 0);
	pc_now_in : in std_logic_vector ( 15 downto 0);
	pc_next_in : in std_logic_vector ( 15 downto 0);
	instruction_in : in std_logic_vector ( 15 downto 0);
	Ra_in : in std_logic_vector(2 downto 0);
	Rb_in : in std_logic_vector ( 2 downto 0);
	Rc_in : in std_logic_vector ( 2 downto 0);
	control_rr_in : in std_logic_vector ( 3 downto 0);
	control_ex_in : in std_logic_vector ( 3 downto 0);
	control_mem_in : in std_logic_vector ( 6 downto 0);
	control_wb_in : in std_logic_vector ( 6 downto 0);
	
	SE16_out : out std_logic_vector ( 15 downto 0);
	pc_now_out : out std_logic_vector ( 15 downto 0);
	pc_next_out : out std_logic_vector ( 15 downto 0);
	instruction_out : out std_logic_vector ( 15 downto 0);
	Ra_out : out std_logic_vector(2 downto 0);
	Rb_out : out std_logic_vector ( 2 downto 0);
	Rc_out : out std_logic_vector ( 2 downto 0);
	control_rr_out : out std_logic_vector ( 3 downto 0);
	control_ex_out : out std_logic_vector ( 3 downto 0);
	control_mem_out : out std_logic_vector ( 6 downto 0);
	control_wb_out : out std_logic_vector ( 6 downto 0);
	
	f: in std_logic := '0'; -- flush
	s: in std_logic := '1'; -- stall
	clk: in std_logic;
	reset : in std_logic  := '0'
	);
end component;


component RR_EX is port(
	SE16_in : in std_logic_vector ( 15 downto 0);
	Rb_in : in std_logic_vector ( 15 downto 0);
	Rc_in : in std_logic_vector ( 15 downto 0);
	control_ex_in : in std_logic_vector ( 3 downto 0);
	control_mem_in : in std_logic_vector ( 6 downto 0);
	control_wb_in : in std_logic_vector ( 6 downto 0);
	pc_now_in : in std_logic_vector ( 15 downto 0);
	pc_next_in : in std_logic_vector ( 15 downto 0);
	inst_in : in std_logic_vector ( 15 downto 0);
	
	SE16_out : out std_logic_vector ( 15 downto 0);
	Rb_out : out std_logic_vector ( 15 downto 0);
	Rc_out : out std_logic_vector ( 15 downto 0);
	control_ex_out : out std_logic_vector ( 3 downto 0);
	control_mem_out : out std_logic_vector ( 6 downto 0);
	control_wb_out : out std_logic_vector ( 6 downto 0);
	pc_now_out : out std_logic_vector ( 15 downto 0);
	pc_next_out : out std_logic_vector ( 15 downto 0);
	inst_out : out std_logic_vector ( 15 downto 0);
	
	f: in std_logic := '0'; -- flush
	s: in std_logic := '1'; -- stall
	clk: in std_logic;
	reset : in std_logic  := '0'
	);
end component;

component EX_MEM is port(
	SE16_in : in std_logic_vector ( 15 downto 0);
	ALU_in : in std_logic_vector ( 15 downto 0);
	C_flag_in : in std_logic;
	Z_flag_in : in std_logic;
	control_mem_in : in std_logic_vector ( 6 downto 0);
	control_wb_in : in std_logic_vector ( 6 downto 0);
	SE_PC_in : in std_logic_vector ( 15 downto 0);
	RB_data_in : in std_logic_vector ( 15 downto 0);
	RA_data_in : in std_logic_vector ( 15 downto 0);
	pc_next_in : in std_logic_vector ( 15 downto 0);
	instr_in : in std_logic_vector ( 15 downto 0);
	
	SE16_out : out std_logic_vector ( 15 downto 0);
	ALU_out : out std_logic_vector ( 15 downto 0);
	C_flag_out : out std_logic;
	Z_flag_out : out std_logic;
	control_mem_out : out std_logic_vector ( 6 downto 0);
	control_wb_out : out std_logic_vector ( 6 downto 0);
	SE_PC_out : out std_logic_vector ( 15 downto 0);
	RB_data_out : out std_logic_vector ( 15 downto 0);
	RA_data_out : out std_logic_vector ( 15 downto 0);
	pc_next_out : out std_logic_vector ( 15 downto 0);
	instr_out : out std_logic_vector ( 15 downto 0);
	
	clk: in std_logic;
	reset : in std_logic := '0'
	);
end component;

component MEM_WB is port(
--	pc_next_IF_in : in std_logic_vector ( 15 downto 0);--not pipeline; directly from IF
	pc_next_in : in std_logic_vector ( 15 downto 0);-- pipeline one; for the flowing instn
	SE16_in : in std_logic_vector ( 15 downto 0);
	ALU_in : in std_logic_vector ( 15 downto 0);
	mem_data_in : in std_logic_vector ( 15 downto 0);
	control_wb_in : in std_logic_vector ( 6 downto 0);
	C_flag_in : in std_logic;
	Z_flag_in : in std_logic;
	inst_in : in std_logic_vector ( 15 downto 0);
	
--	pc_next_IF_out : out std_logic_vector ( 15 downto 0);--not pipeline; directly from IF
	pc_next_out : out std_logic_vector ( 15 downto 0);-- pipeline one; for the flowing instn
	SE16_out : out std_logic_vector ( 15 downto 0);
	ALU_out : out std_logic_vector ( 15 downto 0);
	mem_data_out : out std_logic_vector ( 15 downto 0);
	control_wb_out : out std_logic_vector ( 6 downto 0);
	C_flag_out : out std_logic;
	Z_flag_out : out std_logic;
	inst_out : out std_logic_vector ( 15 downto 0);
	
	clk: in std_logic;
	reset : in std_logic := '0'
	);
end component;

component decoder is
port(
		inst : in std_logic_vector(15 downto 0);
		Rc : out std_logic_vector(2 downto 0) := "000";
		Rb : out std_logic_vector(2 downto 0) := "000";
		Ra : out std_logic_vector(2 downto 0) := "000";
		imm_9bit : out std_logic_vector(8 downto 0) := "000000000";
		control_id : out std_logic_vector(3 downto 0) := "0000"; --only last bit used
		control_rr : out std_logic_vector(3 downto 0) := "0000";
		control_ex : out std_logic_vector(3 downto 0) := "0000"; 
		control_mem : out std_logic_vector(6 downto 0) := "0000000"; 
		control_wb : out std_logic_vector(6 downto 0) := "0000000" 
		);
end component;

component mux2_1x16 is
	port(in0 : in std_logic_vector(15 downto 0):=X"0000";
		  in1	: in std_logic_vector(15 downto 0):=X"0000";
		  sel : in std_logic;
		  op :  out std_logic_vector(15 downto 0)
		  );
end component;

component adder is
	port (inA: in std_logic_vector (15 downto 0);
			inB: in std_logic_vector (15 downto 0);
			res: out std_logic_vector (15 downto 0):= X"0000"
			);
	 
end component;

component jump_logic is
	port (
			SE_PC_in : in std_logic_vector(15 downto 0);
			pc_nxt : in std_logic_vector(15 downto 0);
			RB_data : in std_logic_vector(15 downto 0);
			sel : in std_logic_vector(2 downto 0):="000";
			Z_flag : in std_logic;
			pc_in : out std_logic_vector(15 downto 0)
			);
end component;

component hcl is
	port (
	
		inst_decoder: in std_logic_vector (15 downto 0);
		inst_pass0  : in std_logic_vector (15 downto 0);
		inst_pass1  : in std_logic_vector (15 downto 0);
		inst_pass2  : in std_logic_vector (15 downto 0);
		inst_pass3  : in std_logic_vector (15 downto 0);

		--mux select lines		
		sel0 : out std_logic_vector (2 downto 0):="000"; -- for Rc  (5 downto 3)
		sel1 : out std_logic_vector (2 downto 0):="000"  -- for Rb  (8 downto 6)
		
  		  );
end component;

component staller is
	port (
	
		inst_decoder: in std_logic_vector (15 downto 0);
		inst_pass0  : in std_logic_vector (15 downto 0);
		inst_pass1  : in std_logic_vector (15 downto 0);
		inst_pass2  : in std_logic_vector (15 downto 0);
		inst_pass3  : in std_logic_vector (15 downto 0);

		--stall outputs
		s_if_id, s_id_rr, s_rr_mem : out std_logic :='1' -- stall = '0'
		
  		);
end component;

--signals for instruction passing
signal inst_pass1: std_logic_vector (15 downto 0);
signal inst_pass2: std_logic_vector (15 downto 0);
signal inst_pass3: std_logic_vector (15 downto 0);


--signals for pipeline_ID
signal inst_decoder: std_logic_vector (15 downto 0);
signal Ra0 : std_logic_vector(2 downto 0);
signal Rc0 : std_logic_vector(2 downto 0);
signal Rb0 : std_logic_vector(2 downto 0);
signal SE_in : std_logic_vector(8 downto 0);
signal control_id0 : std_logic_vector(3 downto 0);
signal control_rr0 : std_logic_vector(3 downto 0);
signal control_ex0 : std_logic_vector(3 downto 0); 
signal control_mem0 : std_logic_vector(6 downto 0); 
signal control_wb0 : std_logic_vector(6 downto 0); 
signal SE_out : std_logic_vector(15 downto 0);
signal instruction_in0 : std_logic_vector ( 15 downto 0);
--signal pc_now_in0 : std_logic_vector ( 15 downto 0);
signal pc_next_in0 : std_logic_vector ( 15 downto 0);
signal pc_now_out_0 :  std_logic_vector ( 15 downto 0);
signal pc_next_out0 :  std_logic_vector ( 15 downto 0);

signal SE16_out1 : std_logic_vector ( 15 downto 0);
signal pc_now_out1 :  std_logic_vector ( 15 downto 0);
signal pc_next_out1 :  std_logic_vector ( 15 downto 0);
signal inst_pass0 :  std_logic_vector ( 15 downto 0);
signal Ra_out1 :  std_logic_vector ( 2 downto 0);
signal Rb_out1 :  std_logic_vector ( 2 downto 0);
signal Rc_out1 :  std_logic_vector ( 2 downto 0);
signal control_rr_out1 :  std_logic_vector ( 3 downto 0);
signal control_ex_out1 :  std_logic_vector ( 3 downto 0);
signal control_mem_out1 :  std_logic_vector ( 6 downto 0);
signal control_wb_out1 :  std_logic_vector ( 6 downto 0);

--signals for pipeline_RR

signal mux1_out : std_logic_vector ( 2 downto 0);
signal r1_data_in : std_logic_vector ( 15 downto 0);
signal r2_data_in : std_logic_vector ( 15 downto 0);
signal r1_data_out : std_logic_vector ( 15 downto 0);
signal ALU_IN2 : std_logic_vector ( 15 downto 0);

signal wr_data : std_logic_vector ( 15 downto 0);
signal wr_addr : std_logic_vector ( 2 downto 0);
signal wr_en : std_logic;
signal SE16_out2 : std_logic_vector ( 15 downto 0); 
signal control_ex_out2 :  std_logic_vector ( 3 downto 0);
signal control_mem_out2 :  std_logic_vector ( 6 downto 0);
signal control_wb_out2 :  std_logic_vector ( 6 downto 0);
signal pc_now_out2 : std_logic_vector ( 15 downto 0);

--signals for pipeline_EX
signal ALU_IN1 : std_logic_vector ( 15 downto 0);
signal alu1_out : std_logic_vector ( 15 downto 0);
signal adder_out : std_logic_vector ( 15 downto 0);
signal c_out_in : std_logic;
signal z_out_in : std_logic;
signal c_out_out : std_logic;
signal z_out_out : std_logic;
signal adder_out_in : std_logic_vector (15 downto 0);
signal adder_out_out : std_logic_vector (15 downto 0);
signal ALU_OUT : std_logic_vector (15 downto 0);
signal alu1_out_out : std_logic_vector (15 downto 0);
signal control_mem_out3 :  std_logic_vector ( 6 downto 0);
signal control_wb_out3 :  std_logic_vector ( 6 downto 0);
signal SE16_out3 : std_logic_vector ( 15 downto 0);
signal r2_data_out0 : std_logic_vector ( 15 downto 0);

--signals for pipeline_Mem
signal pc_in : std_logic_vector(15 downto 0);
signal mem_out_in : std_logic_vector(15 downto 0);
signal pc_next_out2 : std_logic_vector(15 downto 0); 
signal SE16_out4 : std_logic_vector(15 downto 0);
signal alu1_out_out1 : std_logic_vector(15 downto 0); 
signal mem_out_in1 : std_logic_vector(15 downto 0); 
signal control_wb_out4 :  std_logic_vector ( 6 downto 0);
signal c_out_out1 : std_logic;
signal z_out_out1 : std_logic;
signal data_mem_in : std_logic_vector(15 downto 0); 
signal control_wb_out5 :   std_logic_vector ( 6 downto 0);


-- for recently added PC_now's

signal pc_next_2 :  std_logic_vector ( 15 downto 0);
signal pc_next_3 :  std_logic_vector ( 15 downto 0);
signal pc_next_4 :  std_logic_vector ( 15 downto 0);

-- for forward unit lines

signal Ra_alu,Rb_alu:  std_logic_vector ( 15 downto 0);
signal forw_mux_1,forw_mux_0:  std_logic_vector ( 2 downto 0) :="000";
signal hz_mux1,hz_mux0,no_use0,no_use1:  std_logic_vector ( 15 downto 0);
signal level0_mux_sel1,level0_mux_sel0:  std_logic :='0';

signal do_flesh : std_logic := '0';
signal stall : std_logic := '1';


begin

level0_mux_sel1 <= forw_mux_1(2) or forw_mux_1(1) or forw_mux_1(0);
level0_mux_sel0 <= forw_mux_0(2) or forw_mux_0(1) or forw_mux_0(0);

if1: pc_adder port map(pc_in,pc_next_in0);
if2: instr_mem port map(pc_in,instruction_in0);


id_start: IF_ID port map(instruction_in0,pc_in,pc_next_in0,
								inst_decoder,pc_now_out_0,pc_next_out0,do_flesh,stall,clk);
id1	  : decoder port map(inst_decoder,Rc0,Rb0,Ra0,SE_in,control_id0,control_rr0,control_ex0,control_mem0,control_wb0);
id2	  : sign_extension port map(SE_in,control_id0(1 downto 0),SE_out);
id_end  : ID_RR port map(SE_out,pc_now_out_0,pc_next_out0,inst_decoder,Ra0,Rb0,Rc0,
				control_rr0,control_ex0,control_mem0,control_wb0,
				SE16_out1,pc_now_out1,pc_next_out1,inst_pass0,Ra_out1,Rb_out1,Rc_out1,
				control_rr_out1,control_ex_out1,control_mem_out1,control_wb_out1,do_flesh,stall,clk);



rr1 : mux2_1 port map(Rc_out1, Ra_out1, control_rr_out1(0), mux1_out);	--add proper control bit
rr2 : reg_file port map(clk, r1_data_in, r2_data_in, wr_data, mux1_out,Rb_out1, wr_addr, wr_en, pc_next_in0);
rr3 : RR_EX port map(SE16_out1, r1_data_in, r2_data_in,
				control_ex_out1,control_mem_out1,control_wb_out1,pc_now_out1,pc_next_out1,inst_pass0,
				SE16_out2, r1_data_out,Rb_alu ,
				control_ex_out2,control_mem_out2,control_wb_out2,pc_now_out2,pc_next_2,inst_pass1,do_flesh,stall,clk);

				
Ex1 : mux2_1x16 port map(r1_data_out,SE16_out2,control_ex_out2(2), Ra_alu);









Ex2 : alu port map(ALU_IN1, ALU_IN2, ALU_OUT,control_ex_out2(1 downto 0),control_ex_out2(3),
				 c_out_in, z_out_in, c_out_out, z_out_out, inst_pass1, control_wb_out2, control_wb_out3,do_flesh);
Ex3 : adder port map(SE16_out2,pc_now_out2, adder_out_in );
Ex4 : EX_MEM port map(SE16_out2, ALU_OUT, c_out_in, z_out_in,
  				control_mem_out2,control_wb_out3, adder_out_in, ALU_IN2,r1_data_out, pc_next_2,inst_pass1,
				SE16_out3, alu1_out_out, c_out_out, z_out_out,
				control_mem_out3,control_wb_out4, adder_out_out,r2_data_out0,data_mem_in, pc_next_3,inst_pass2,clk);

Mem1 : jump_logic port map(adder_out_in,pc_next_out0,ALU_IN2,
				control_mem_out2(2 downto 0),z_out_in,pc_in);
				
				
				
Mem2 : data_mem port map(alu1_out_out,control_mem_out3(4 downto 3),data_mem_in,mem_out_in);
Mem3 : MEM_WB port map(pc_next_3,SE16_out3, alu1_out_out,
				mem_out_in,control_wb_out4,c_out_out, z_out_out,inst_pass2,
				pc_next_4, SE16_out4, alu1_out_out1,
				mem_out_in1, control_wb_out5, c_out_out1, z_out_out1,inst_pass3,clk);
									  
wb1  : wb_logic port map (SE16_out4, alu1_out_out1,mem_out_in1,control_wb_out5,
					  c_out_out1, z_out_out1, pc_next_4,wr_en, wr_data, wr_addr);
 
 hazard2_2: mux4_1x16 port map(alu1_out_out,alu1_out_out1,mem_out_in1,no_use1,forw_mux_1(2 downto 1),hz_mux1);
 hazard2_1: mux4_1x16 port map(alu1_out_out,alu1_out_out1,mem_out_in1,no_use0,forw_mux_0(2 downto 1),hz_mux0);
 
--hazard1_2:   mux2_1x16 port map(Rb_alu,hz_mux1,forw_mux_1(0),ALU_IN2);
--hazard1_1:   mux2_1x16 port map(Ra_alu,hz_mux0,forw_mux_0(0),ALU_IN1);
 hazard1_2:   mux2_1x16 port map(Rb_alu,hz_mux1,level0_mux_sel1,ALU_IN2);
 hazard1_1:   mux2_1x16 port map(Ra_alu,hz_mux0,level0_mux_sel0,ALU_IN1);

 hazard4:   hcl port map(inst_decoder,inst_pass0,inst_pass1,inst_pass2,inst_pass3,forw_mux_0,forw_mux_1);
 hazard5:   staller port map(inst_decoder,inst_pass0,inst_pass1,inst_pass2,inst_pass3,stall);

end behav;