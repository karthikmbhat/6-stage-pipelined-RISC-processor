library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity IF_ID is port(
	instruction_in : in std_logic_vector ( 15 downto 0);
	pc_now_in : in std_logic_vector ( 15 downto 0);
	pc_next_in : in std_logic_vector ( 15 downto 0);
	
	instruction_out : out  std_logic_vector ( 15 downto 0);
	pc_now_out : out std_logic_vector ( 15 downto 0);
	pc_next_out : out std_logic_vector ( 15 downto 0);
	
	f: in std_logic := '0'; -- flush
	s: in std_logic := '1'; -- stall
	clk: in std_logic;
	reset : in std_logic := '0'
	);
end;

architecture behav of IF_ID is

begin
		process(clk, reset)
		begin	
			if(clk'event and clk='1' and reset = '0') then
					
				if(s='1') then
						instruction_out <= instruction_in;
						pc_now_out <= pc_now_in;
						pc_next_out <= pc_next_in;			
				end if;
			
				if(f = '1') then -- flush not needed.
				
			--			pc_now_out <= X"1111";
				--		pc_next_out <= X"1111";
					--	instruction_out <= X"F000";
				
				end if;
			elsif(clk'event and clk='1' and reset = '1') then
				pc_now_out <= X"1111";
				pc_next_out <= X"1111";
				instruction_out <= X"F000";
			end if;
		end process;
end behav;