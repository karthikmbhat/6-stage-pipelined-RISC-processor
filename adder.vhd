library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder is
	port (inA: in std_logic_vector (15 downto 0);
			inB: in std_logic_vector (15 downto 0);
			res: out std_logic_vector (15 downto 0):= X"0000"
			);
	 
end;

architecture behav of adder is
begin

res <= inA + inB;

end behav;