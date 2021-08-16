library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity mux4_1x16 is
	port(in0 : in std_logic_vector(15 downto 0):=X"0000";
		  in1	: in std_logic_vector(15 downto 0):=X"0000";
		  in2 : in std_logic_vector(15 downto 0):=X"0000";
		  in3	: in std_logic_vector(15 downto 0):=X"0000";
		  sel : in std_logic_vector(1 downto 0);
		  op :  out std_logic_vector(15 downto 0)
		  );
end;

architecture behav of mux4_1x16 is
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