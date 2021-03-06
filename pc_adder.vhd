library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pc_adder is
	port (
	inA: in std_logic_vector (15 downto 0):= X"0000";
	res: out std_logic_vector (15 downto 0):= X"0000"
			);
end;

architecture behav of pc_adder is
begin

res <= std_logic_vector(unsigned(inA)+1);

end behav;