library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity MEM_WB is port(
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
end;

architecture behav of MEM_WB is
begin
		process(clk, reset)
		begin
				if(clk'event and clk='1' and reset = '0') then
--						pc_next_IF_out <= pc_next_IF_in;
						pc_next_out <= pc_next_in;
						SE16_out <= SE16_in;
						ALU_out <= ALU_in;
						mem_data_out <= mem_data_in;
						C_flag_out <= C_flag_in;
						Z_flag_out <= Z_flag_in;
						control_wb_out  <= control_wb_in;
						inst_out <= inst_in;
						
				elsif(clk'event and clk='1' and reset = '1') then
						pc_next_out <= X"0000";
						SE16_out <= X"0000";
						ALU_out <= X"0000";
						mem_data_out <= X"0000";
						C_flag_out <= '0';
						Z_flag_out <= '0';
						control_wb_out  <= "0000000";
						inst_out <= X"F000";
						
				
				end if;
		end process;
end behav;