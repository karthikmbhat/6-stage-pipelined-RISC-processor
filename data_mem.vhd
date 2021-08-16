library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity data_mem is
	port(addr : in std_logic_vector(15 downto 0);
		  wr_en : in std_logic_vector(1 downto 0);--1st bit read ; 0th bit write
		  din : in std_logic_vector(15 downto 0);
		  dout : out std_logic_vector(15 downto 0)
		 );
end;

architecture behav of data_mem is
type d_mem is array (0 to 13) of std_logic_vector(15 downto 0);
signal mem: d_mem := (X"0005",
							 X"0007",
							 X"0009",
							 X"8888",
							 X"0055",
							 X"0001",
							 X"FFFF",
							 X"1AB2",
							 X"1022",
							 X"8888",
							 X"0055",
							 X"5555",
							 X"0001",
							 X"FFFF");

begin
		process(addr,wr_en)
		begin
				if wr_en(0) = '1' then
						dout <= mem(to_integer(unsigned(addr(3 downto 0))));
				elsif wr_en(1) = '1' then
						mem(to_integer(unsigned(addr))) <= din;
				end if;
		end process;
end behav;