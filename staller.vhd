library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity staller is
	port (
	
		inst_decoder: in std_logic_vector (15 downto 0);
		inst_pass0  : in std_logic_vector (15 downto 0);
		inst_pass1  : in std_logic_vector (15 downto 0);
		inst_pass2  : in std_logic_vector (15 downto 0);
		inst_pass3  : in std_logic_vector (15 downto 0);

		--stall outputs
		s_if_id, s_id_rr, s_rr_mem : out std_logic :='1' -- stall = '0'
		
  		);
end;

architecture behav of staller is

begin

		process(inst_pass1,inst_pass2,inst_pass3)
		begin
				-- THis is for the second layer (STALL WILL BE FOR ONLY SECOND LAYER, froom WRITE_BACK stage)
				if(((inst_pass0(15 downto 12) = "0000") or (inst_pass0(15 downto 12) = "0010")) and -- (ADD or AND) && LOAD
			       (inst_pass1(15 downto 12) = "0100")) then
						s_if_id <='0';
						s_id_rr <='0';
						s_rr_mem <='0';
				else
						s_if_id <='1';
						s_id_rr <='1';
						s_rr_mem <='1';
				end if;
		end process;
end behav;
