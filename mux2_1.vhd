library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity mux2_1 is
	port(in0 : in std_logic_vector(2 downto 0):=B"000";
		  in1	: in std_logic_vector(2 downto 0):=B"000";
		  sel : in std_logic;
		  op :  out std_logic_vector(2 downto 0)
		  );
end;

architecture behav of mux2_1 is
begin
process(in0,in1,sel)
begin
if (sel = '0') then
op <= in0;
else
op <= in1;
end if;

end process;

end behav;
