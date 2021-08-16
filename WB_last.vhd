library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity WB_last is port(
	wr_en : in std_logic;
	wr_data : in std_logic_vector ( 15 downto 0);
	wr_addr : in std_logic_vector ( 2 downto 0);
	wr_en_last : out std_logic;
	wr_data_last : out std_logic_vector ( 15 downto 0);
	wr_addr_last : out std_logic_vector ( 2 downto 0);
	clk: in std_logic
	);
end;

architecture behav of WB_last is
begin
		process(clk)
		begin
				if(clk'event and clk='1') then
						wr_en_last   <= wr_en;
						wr_data_last <= wr_data;
						wr_addr_last <= wr_addr;
				end if;
		end process;
end behav;