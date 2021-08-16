library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity hcl is
	port (
	
		inst_decoder: in std_logic_vector (15 downto 0);
		inst_pass0  : in std_logic_vector (15 downto 0);
		inst_pass1  : in std_logic_vector (15 downto 0);
		inst_pass2  : in std_logic_vector (15 downto 0);
		inst_pass3  : in std_logic_vector (15 downto 0);

		--mux select lines		
		sel0 : out std_logic_vector (2 downto 0):="000"; -- for Rc  (5 downto 3)
		sel1 : out std_logic_vector (2 downto 0):="000"  -- for Rb  (8 downto 6)
		
  		  );
end;

architecture behav of hcl is

------ inst_pass1 is always source == (8 downto 6)=(sel_1)  or  (5 downto 3)=(sel_0)
------ inst_pass2 and inst_pass3 are the destinations == (11 downto 9)

begin

		process(inst_pass1,inst_pass2,inst_pass3)
		begin
				-- AND/NAND instn = AND/NAND instn
				if  ((inst_pass2(15 downto 12) = "0000" or inst_pass2(15 downto 12) = "0010")  and
					  (inst_pass1(15 downto 12) = "0000" or inst_pass1(15 downto 12) = "0010")) then
						
						if ((inst_pass2(11 downto 9) = inst_pass1(8 downto 6)) and 
						    (inst_pass2(11 downto 9) = inst_pass1(5 downto 3))) then 
								sel0(0) <= '1';
								sel1(0) <= '1';
						elsif (inst_pass2(11 downto 9) = inst_pass1(8 downto 6)) then 
								sel0(0) <= '0';--"000";
								sel1(0) <= '1';
								--if(inst_pass2(11 downto 9) = inst_pass1(5 downto 3)) then--if(out_prev=in_now)
								--		sel0 <= "010";
								--end if;
						elsif (inst_pass2(11 downto 9) = inst_pass1(5 downto 3)) then 
								sel0(0) <= '1';
								sel1(0) <= '0';--"000";
								--if(inst_pass2(11 downto 9) = inst_pass1(8 downto 6)) then
								--		sel1 <= "010";
								--end if;
						else
								sel0(0) <= '0';--"000";
								sel1(0) <= '0';--"000";
						end if;

				-- ADD/NAND(destn)@exn = ADI instn (source)@reg_read---
				elsif((inst_pass1(15 downto 12) = "0001") and 
					  ((inst_pass2(15 downto 12) = "0000") or (inst_pass2(15 downto 12) = "0010"))) then
						if (inst_pass2(11 downto 9) = (inst_pass1(8 downto 6))) then 
								sel0(0) <= '0';--"000";
								sel1(0) <= '1';
						else
								sel0(0) <= '0';--"000";
								sel1(0) <= '0';--"000";
						end if;
						
				elsif(((inst_pass1(15 downto 12) = "0000") or (inst_pass1(15 downto 12) = "0010")) and
			          (inst_pass2(15 downto 12) = "0001")) then
						
						-- ADI instn (destn)@exn = ADD/NAND(source)@reg_read
						
						if    (inst_pass2(11 downto 9) = (inst_pass1(8 downto 6))) then 
								sel0(0) <= '0';--"000";
								sel1(0) <= '1';
						elsif (inst_pass2(11 downto 9) = (inst_pass1(5 downto 3))) then 
								sel0(0) <= '1';
								sel1(0) <= '0';--"000";
						else
								sel0(0) <= '0';--"000";
								sel1(0) <= '0';--"000";
						end if;
						
				else
						sel0(0) <= '0';
						sel1(0) <= '0';
						
				end if;
				
				
				
				
				
				
				
				-- THis is for the second layer of mux (froom WRITE_BACK stage)
				-- AND/NAND instn = AND/NAND instn
				if  ((inst_pass3(15 downto 12) = "0000" or inst_pass3(15 downto 12) = "0010")  and
					  (inst_pass1(15 downto 12) = "0000" or inst_pass1(15 downto 12) = "0010")) then
						
						if ((inst_pass3(11 downto 9) = inst_pass1(8 downto 6)) and 
						    (inst_pass3(11 downto 9) = inst_pass1(5 downto 3))) then 
								sel0(2 downto 1) <= "01";
								sel1(2 downto 1) <= "01";
						elsif (inst_pass3(11 downto 9) = inst_pass1(8 downto 6)) then 
								sel0(2 downto 1) <= "00";--"000";
								sel1(2 downto 1) <= "01";
								--if(inst_pass2(11 downto 9) = inst_pass1(5 downto 3)) then--if(out_prev=in_now)
								--		sel0 <= "010";
								--end if;
						elsif (inst_pass3(11 downto 9) = inst_pass1(5 downto 3)) then 
								sel0(2 downto 1) <= "01";
								sel1(2 downto 1) <= "00";--"000";
								--if(inst_pass2(11 downto 9) = inst_pass1(8 downto 6)) then
								--		sel1 <= "010";
								--end if;
						else
								sel0(2 downto 1) <= "00";--"000";
								sel1(2 downto 1) <= "00";--"000";
						end if;

				-- ADD/NAND(destn)@exn = ADI instn (source)@reg_read---
				elsif((inst_pass1(15 downto 12) = "0001") and 
					  ((inst_pass3(15 downto 12) = "0000") or (inst_pass3(15 downto 12) = "0010"))) then
						if (inst_pass3(11 downto 9) = (inst_pass1(8 downto 6))) then 
								sel0(2 downto 1) <= "00";--"000";
								sel1(2 downto 1) <= "01";
						else
								sel0(2 downto 1) <= "00";--"000";
								sel1(2 downto 1) <= "00";--"000";
						end if;
						
				-- ADI instn (destn)@exn = ADD/NAND(source)@reg_read
				elsif(((inst_pass1(15 downto 12) = "0000") or (inst_pass1(15 downto 12) = "0010")) and
			          (inst_pass3(15 downto 12) = "0001")) then
						
						
						if    (inst_pass3(11 downto 9) = (inst_pass1(8 downto 6))) then 
								sel0(2 downto 1) <= "00";--"000";
								sel1(2 downto 1) <= "01";
						elsif (inst_pass3(11 downto 9) = (inst_pass1(5 downto 3))) then 
								sel0(2 downto 1) <= "01";
								sel1(2 downto 1) <= "00";--"000";
						else
								sel0(2 downto 1) <= "00";--"000";
								sel1(2 downto 1) <= "00";--"000";
						end if;
						
				-- ADD instn (destn)@exn = LOAD(source)@WB
				elsif(((inst_pass1(15 downto 12) = "0000") or (inst_pass1(15 downto 12) = "0010")) and
			          (inst_pass3(15 downto 12) = "0100")) then
						
						
						if    (inst_pass3(11 downto 9) = (inst_pass1(8 downto 6))) and
								(inst_pass3(11 downto 9) = (inst_pass1(5 downto 3))) then 
								sel0(2 downto 1) <= "10";
								sel1(2 downto 1) <= "10";
						elsif (inst_pass3(11 downto 9) = (inst_pass1(8 downto 6))) then 
								sel0(2 downto 1) <= "00";
								sel1(2 downto 1) <= "10";
						elsif (inst_pass3(11 downto 9) = (inst_pass1(5 downto 3))) then 
								sel0(2 downto 1) <= "10";
								sel1(2 downto 1) <= "00";
						else
								sel0(2 downto 1) <= "00";
								sel1(2 downto 1) <= "00";
						end if;
						
				else				
						sel0(2 downto 1) <= "00";
						sel1(2 downto 1) <= "00";
				end if;
		end process;
end behav;
