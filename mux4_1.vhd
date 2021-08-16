library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity mux4_1 is
	port(in0 : in std_logic:='0';
		  in1	: in std_logic:='1';
		  in2 : in std_logic;
		  in3	: in std_logic;
		  sel : in std_logic_vector(1 downto 0);
		  op :  out std_logic
		  );
end;

architecture behav of mux4_1 is
begin
process(in0,in1,in2,in3,sel)
begin
if (sel = B"00") then
op <= in0;
elsif (sel = B"01") then
op <= in1;
elsif (sel = B"10") then
op <= in2;
elsif (sel = B"11") then
op <= in3;

end if;

end process;

end behav;