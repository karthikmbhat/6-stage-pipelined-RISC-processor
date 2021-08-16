library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity RR_EX is port(
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
	reset : in std_logic := '0'
	);
end;

architecture behav of RR_EX is
begin

		process(clk, reset)
		begin
					if(clk'event and clk='1' and reset = '0') then
						
					if(s='1') then
					
						SE16_out <= SE16_in;
						Rb_out  <= Rb_in;
						Rc_out  <= Rc_in;
						control_ex_out  <= control_ex_in;
						control_mem_out <= control_mem_in;
						control_wb_out  <= control_wb_in;
						pc_now_out <= pc_now_in;
						pc_next_out <= pc_next_in;
						inst_out  <= inst_in;
						
					else

						SE16_out <= X"0000";
						pc_now_out <= X"1111";
						pc_next_out <= X"1111";
						inst_out <= X"F000";
						Rb_out  <= Rb_in;
						Rc_out  <= Rc_in;
						control_ex_out  <= "0000";
						control_mem_out <= "0000000";
						control_wb_out  <= "0000000";
					
					end if;

					if(f='1') then

						SE16_out <= X"0000";
						pc_now_out <= X"1111";
						pc_next_out <= X"1111";
						inst_out <= X"F000";
						Rb_out  <= Rb_in;
						Rc_out  <= Rc_in;
						control_ex_out  <= "0000";
						control_mem_out <= "0000000";
						control_wb_out  <= "0000000";
						
					end if;
					
				elsif(clk'event and clk='1' and reset = '1') then
						SE16_out <= X"0000";
						pc_now_out <= X"1111";
						pc_next_out <= X"1111";
						inst_out <= X"F000";
						Rb_out  <= Rb_in;
						Rc_out  <= Rc_in;
						control_ex_out  <= "0000";
						control_mem_out <= "0000000";
						control_wb_out  <= "0000000";
					
				end if;
		end process;
end behav;