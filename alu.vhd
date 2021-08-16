
--sel
--00 = add
--01 = nand
--10 = compare: out will be 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
	port (aluA: in std_logic_vector (15 downto 0);
			aluB: in std_logic_vector (15 downto 0);
			res: out std_logic_vector (15 downto 0):= X"0000";
			sel_oprn : in std_logic_vector (1 downto 0); -- select add or nand
			flush_jlr : in std_logic; -- 
			Cout : out std_logic :='0';
			Zout : inout std_logic :='0';
			C_chk : in std_logic :='0';
			Z_chk : in std_logic :='0';
			instruction : in std_logic_vector (15 downto 0);
			control_wb_in : in std_logic_vector(6 downto 0) := "0000000";
			control_wb_out : out std_logic_vector(6 downto 0) := "0000000";
			flush_out: out std_logic := '0'
	 );
	 
end;

architecture behav of alu is
--signal temp_out : std_logic_vector (16 downto 0);


begin

control_wb_out(6 downto 2) <= control_wb_in(6 downto 2); 

 flush_out <= '1' when flush_jlr='1' else
				  '1' when (sel_oprn = "10" and Zout = '1') else
				  '0';

process(sel_oprn, aluA, aluB, C_chk, Z_chk, instruction, control_wb_in)
variable temp_out : std_logic_vector (16 downto 0);
begin
	
	
	
		 
		if (sel_oprn = "00") then-- for addition

							if (instruction(15 downto 12) = "0000" and instruction(1 downto 0) = "10") then --for ADC
										if (C_chk = '1') then
											temp_out := ('0' & aluA) + ('0' & aluB);
											res <= temp_out(15 downto 0);
											Cout <= temp_out(16);
											if (temp_out(15 downto 0) = X"0000") then
												Zout <= '1';
											else
												Zout <= '0';
											end if;
											control_wb_out(1 downto 0) <= "01"; --write back
											
										else
											control_wb_out(1 downto 0) <= "00";	--no write back

											
										end if;
							
							elsif (instruction(15 downto 12) = "0000" and instruction(1 downto 0) = "01") then  --for ADZ
												if (Z_chk = '1') then
													temp_out := ('0' & aluA) + ('0' & aluB);
													res <= temp_out(15 downto 0);
													Cout <= temp_out(16);
													if (temp_out(15 downto 0) = X"0000") then
														Zout <= '1';
													else
														Zout <= '0';
													end if;
													control_wb_out(1 downto 0) <= "01"; --write back
													
												else
													control_wb_out(1 downto 0) <= "00";	--no write back
											
												end if;
							elsif (instruction(15 downto 12) = "0100" or instruction(15 downto 12) = "0101") then  --for LW SW
												
											temp_out := ('0' & aluA) + ('0' & aluB);
											res <= temp_out(15 downto 0);
											control_wb_out(1 downto 0) <= control_wb_in(1 downto 0);
										
											--Cout <= C_chk;
											--Zout <= Z_chk;
											
							elsif (instruction(15 downto 12) = "1111") then  --for NOP
												
											control_wb_out(1 downto 0) <= control_wb_in(1 downto 0);
							
							else 
											temp_out := ('0' & aluA) + ('0' & aluB);
											res <= temp_out(15 downto 0);
											Cout <= temp_out(16);
											if (temp_out(15 downto 0) = X"0000") then
												Zout <= '1';
											else
												Zout <= '0';
											end if;
											control_wb_out(1 downto 0) <= control_wb_in(1 downto 0);
							end if;


		elsif (sel_oprn = "01") then-- for nand
								
						
						if (instruction(15 downto 12) = "0010" and instruction(1 downto 0) = "10") then -- for NDC
							if (C_chk= '1') then
									temp_out := ('0' & aluA) nand ('0' & aluB);
									res <= temp_out(15 downto 0);
									Cout <= temp_out(16);
									if (temp_out(15 downto 0) = X"0000") then
										Zout <= '1';
									else
										Zout <= '0';
									end if;
									control_wb_out(1 downto 0) <= "01"; --write back
									
							else
								control_wb_out(1 downto 0) <= "00";	--no write back

							end if;
						
						elsif (instruction(15 downto 12) = "0010" and instruction(1 downto 0) = "01") then -- for NDZ
								if (Z_chk= '1') then
									temp_out := ('0' & aluA) nand ('0' & aluB);
									res <= temp_out(15 downto 0);
									Cout <= temp_out(16);
									if (temp_out(15 downto 0) = X"0000") then
										Zout <= '1';
									else
										Zout <= '0';
									end if;
									control_wb_out(1 downto 0) <= "01"; --write back
									
								else
									control_wb_out(1 downto 0) <= "00";	--no write back

								end if;

						 else  -- for NDU
								temp_out := ('0' & aluA) nand ('0' & aluB);
								res <= temp_out(15 downto 0);
								Cout <= temp_out(16);
								if (temp_out(15 downto 0) = X"0000") then
									Zout <= '1';
								else
									Zout <= '0';
								end if;
							control_wb_out(1 downto 0) <= control_wb_in(1 downto 0);
							end if;
		

				
		elsif (sel_oprn = "10") then-- for comparison
				temp_out := ('0' & aluA) xor ('0' & aluB);
				res <= temp_out(15 downto 0);
				--Cout <= temp_out(16);
				if (temp_out(15 downto 0) = X"0000") then
					Zout <= '1';
				else
					Zout <= '0';
				end if;
			control_wb_out(1 downto 0) <= control_wb_in(1 downto 0);
		
		
		else
			control_wb_out(1 downto 0) <= "00";


				
		end if;
end process;

end behav;	