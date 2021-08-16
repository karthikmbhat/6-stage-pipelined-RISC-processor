library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY sign_extension is 
port(
		se_9bit_in : in std_logic_vector(8 downto 0);
		se_sel : in std_logic_vector(1 downto 0); -- to select 9bit or 5 bit; 1 = 9 bit; 0 = 6 bit
		se_out : out std_logic_vector(15 downto 0):=x"FFFF");
end;
		
architecture behav of sign_extension is 
--signal s: std_logic;

begin

									  
		se_out(15 downto 0) <= ("0000000000" & se_9bit_in(5 downto 0)) when se_sel = "00" else -- 6 bit
									  ("0000000" & se_9bit_in(8 downto 0)) when se_sel = "01" else  -- 9 bit
									  (se_9bit_in(8 downto 0) & "0000000") when se_sel = "10"; -- LHI 9 bit to msb
									
end behav;