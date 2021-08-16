library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
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
end;

architecture behav of reg_file is
type r_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal r_data: r_array:=(        x"FFFF",
								 x"0004",
								 x"0005",
								 x"000A",
								 x"F005",
								 x"0003",
								 x"0002",
								 x"0000"
								 );

begin
rA <= r_data (to_integer(unsigned(addrA)));
rB <= r_data (to_integer(unsigned(addrB)));
r7_out <= r_data(7);

process (clk) is
begin
if (clk'event and clk = '1') then
if rW_en = '1' then
	r_data(to_integer(unsigned(addrW))) <= rW;	
end if;
if r7_en = '1' then
	r_data(7) <= r7_in;	
end if;
end if;


end process;


end behav;