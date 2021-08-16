library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity EX_MEM is port(
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
end;

architecture behav of EX_MEM is
begin
		process(clk, reset)
		begin
				if(clk'event and clk='1' and reset = '0') then
											
						SE16_out <= SE16_in;
						ALU_out <= ALU_in;
						C_flag_out <= C_flag_in;
						Z_flag_out <= Z_flag_in;
						control_mem_out <= control_mem_in;
						control_wb_out  <= control_wb_in;
						pc_next_out <= pc_next_in;
						RA_data_out <= RA_data_in;
						RB_data_out <= RB_data_in;
						instr_out <= instr_in;
						SE_PC_out <= SE_PC_in;
						
				elsif(clk'event and clk='1' and reset = '1') then
						SE16_out <= X"0000";
						ALU_out <= X"0000";
						C_flag_out <= '0';
						Z_flag_out <= '0';
						control_mem_out <= "0000000";
						control_wb_out  <= "0000000";
						pc_next_out <= X"1111";
						RA_data_out <= RA_data_in;
						RB_data_out <= RB_data_in;
						instr_out <= X"F000";
						SE_PC_out <= X"0000";
					
									
				end if;
		end process;
end behav;