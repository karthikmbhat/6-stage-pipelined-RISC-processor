library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity jump_logic is
	port (
			SE_PC_in : in std_logic_vector(15 downto 0);
			pc_nxt : in std_logic_vector(15 downto 0);
			RB_data : in std_logic_vector(15 downto 0);
			sel : in std_logic_vector(2 downto 0):="000";
			Z_flag : in std_logic;
			pc_in : out std_logic_vector(15 downto 0)
			);
end;

architecture behav of jump_logic is
begin

--with sel select
	pc_in <= pc_nxt when sel = "000" else
				SE_PC_in when sel = "001" else
				RB_data when sel = "010" else
				SE_PC_in when (sel="011" and Z_flag='1') else
				pc_nxt when (sel="011" and Z_flag='0') else
				X"0000";

end behav;