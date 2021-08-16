library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity wb_logic is port(
	SE16 : in std_logic_vector ( 15 downto 0);
	ALU_out : in std_logic_vector ( 15 downto 0);
	mem_out : in std_logic_vector ( 15 downto 0);
	control_wb_in : in std_logic_vector ( 6 downto 0);
	C_flag_in : in std_logic;
	Z_flag_in : in std_logic;
	pc_next : in std_logic_vector ( 15 downto 0);
	
	wb_en : out std_logic;
	wb_data : out std_logic_vector (15 downto 0);
	wb_addr : out std_logic_vector (2 downto 0)
	);
end;

architecture behav of wb_logic is
begin

-- this is if else model na? i mean else part won't work if IF=1, right?
wb_en <= '0' when control_wb_in(1 downto 0) = "00" else 
			'1' when control_wb_in(1 downto 0) = "01" else 
			C_flag_in when control_wb_in(1 downto 0) = "10" else
			Z_flag_in when control_wb_in(1 downto 0) = "11";

-- bit 2,3 = control for MUX to select write back input; 00-alu, 01-SE, 10-data mem out; 11- PC+1
wb_data <= ALU_out when control_wb_in(3 downto 2) = "00" else 
			  SE16    when control_wb_in(3 downto 2) = "01" else 
			  mem_out when control_wb_in(3 downto 2) = "10" else
			  pc_next when control_wb_in(3 downto 2) = "11";

wb_addr <= control_wb_in(6 downto 4);

end behav;