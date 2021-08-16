--In Inst_mem, make initial value of PC to 1 and 
--0th inst as 1111 0000 0000 0000 
--1st as the required one



--List of control pins for pipeline_id
-- std_logic_vector size = 4
-- bit 1,0 = sign extension; 00-6_bit; 01-9_bit; 10-9_bit to MSB (for LHI)

--List of control pins for pipeline_rr
-- std_logic_vector size = 4
-- bit 0 Mux_sel => reg_in RC if 0
--									RA if 1 for STORE
									
--List of control pins for pipeline_Ex
-- std_logic_vector size = 4 
-- bit 1,0 = adder select 00-add, 01-nand, 10-compare for BEQ, 11-NOP
-- bit 2 = adder in mux select: 0-Rb, 1-SE
-- bit 3= flush for JAL,JLR, 1-Flush, 0-normal

--List of control pins for pipeline_Mem
-- std_logic_vector size = 7
-- bit 2,1,0 = jum_logic 000-PC+1(normal);001-((immd)SE+Rb_value);010-Rb_value;
--							011-jump if(Z_flag==1)
-- bit 3 = data_mem read enable; 1-read data (for LOAD); 0-don't read
-- bit 4 = data_mem write enable; 1-write data (for STORE); 0-don't write

--List of control pins for pipeline_wb
-- std_logic_vector size = 7
-- bit 1,0 = control_wb(1 downto 0) write back control; 00-don't write(for STORE);01-write;11 if(Z);10-if(C==1)=write else no write;
-- bit 2,3 = control for MUX to select write back input; 00-alu, 01-SE, 10-data mem out; 11- PC+1
-- bit 4-6 = destination address Ra 

--NOTES: add 2nd bit of control_ex_in, and control_wb

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity decoder is
port(
		inst : in std_logic_vector(15 downto 0);
		Rc : out std_logic_vector(2 downto 0) := "000";
		Rb : out std_logic_vector(2 downto 0) := "000";
		Ra : out std_logic_vector(2 downto 0) := "000";
--		wb_ct(1 downto 0) : out std_logic_vector(1 downto 0) := "00"; --00-no write;01-write;10-if(C==1)=write else no write;11 if(Z)
		imm_9bit : out std_logic_vector(8 downto 0) := "000000000";
		control_id : out std_logic_vector(3 downto 0) := "0000"; 
		control_rr : out std_logic_vector(3 downto 0) := "0000";
		control_ex : out std_logic_vector(3 downto 0) := "0000"; 
		control_mem : out std_logic_vector(6 downto 0) := "0000000"; 
		control_wb : out std_logic_vector(6 downto 0) := "0000000" 
		);
end;

architecture behav of decoder is


begin




		imm_9bit <= inst(8 downto 0);
		Ra <= inst(11 downto 9);
		Rb <= inst(8 downto 6);
		Rc <= inst(5 downto 3);
		control_mem(6 downto 5) <= "00";
		control_wb(6 downto 4) <= inst(11 downto 9); -- destn address

		process(inst)
		begin
		
				case inst(15 downto 12) is
						when "0000" => --ADD -3 cases
											
											control_ex(1 downto 0) <= "00"; -- ALU_oprn = add
											control_ex(2) <= '0'; -- input = Rb (not take from SE)
											control_ex(3) <= '0'; -- flush bit
											
											control_wb(3 downto 2) <= "00"; -- write back ALU_out
											
											control_rr(0) <= '0'; -- take Rb data from reg_file, not Rc data
											control_mem(4 downto 0) <= "00000"; -- write back ALU_out
											
											control_wb(3 downto 2) <= "00" ;
											if(inst(1 downto 0) = "00") then -- simply write back
												control_wb(1 downto 0) <= "01" ; -- wb_en control
											elsif(inst(1 downto 0) = "10") then -- wb if Carry flag=1
												control_wb(1 downto 0) <= "10" ;
											elsif(inst(1 downto 0) = "01") then -- wb if zero flag=1
												control_wb(1 downto 0) <= "11" ;
											end if;
											
						when "0001" => --ADI
						
											control_id(1 downto 0) <="00"; --to choose 6_bit

											control_ex(1 downto 0) <= "00"; -- ALU_oprn = add
											control_ex(2) <= '1'; -- input take from SE
											control_ex(3) <= '0';
											
											control_wb(3 downto 2) <= "00"; -- write back ALU_out
											
											control_rr(0) <= '0'; -- take Rb data from reg_file, not Rc data
											control_mem(4 downto 0) <= "00000"; --
											
											control_wb(1 downto 0) <= "01" ; -- wb_en control
											
											
						when "0010" => --NAND -3 cases
											
											control_ex(1 downto 0) <= "01"; -- ALU_oprn = nand
											control_ex(2) <= '0'; -- input = Rb (not take from SE)
											control_ex(3) <= '0';
											
											control_wb(3 downto 2) <= "00"; -- write back ALU_out
											
											control_rr(0) <= '0'; -- take Rb data from reg_file, not Rc data
											control_mem(4 downto 0) <= "00000"; --
											
											control_wb(3 downto 2) <= "00" ;
											if(inst(1 downto 0) = "00") then -- simply write back
												control_wb(1 downto 0) <= "01" ; -- wb_en control
											elsif(inst(1 downto 0) = "10") then -- wb if Carry flag=1
												control_wb(1 downto 0) <= "10" ;
											elsif(inst(1 downto 0) = "01") then -- wb if zero flag=1
												control_wb(1 downto 0) <= "11" ;
											end if;		
											
						when "0011" => --LHI
											control_id(1 downto 0) <="10"; --to choose 9_bit to MSB

											control_rr(0) <= '0'; -- take Rb data from reg_file, not Rc data
											control_ex(3) <= '0';
										
											control_mem(2 downto 0) <= "000"; -- 
											control_mem(3) <= '1';
											control_mem(4) <= '0';
											
											control_wb(3 downto 0) <= "0101"; 
											
						when "0100" => --LW
											control_id(1 downto 0) <="00"; --to choose 6_bit
											
											control_rr(0) <= '0'; -- take Rb data from reg_file, not Rc data

											control_ex(1 downto 0) <= "00"; -- ALU_oprn = add
											control_ex(2) <= '1'; -- input take from SE
											control_ex(3) <= '0';
											
											control_mem(2 downto 0) <= "000"; -- 
											control_mem(3) <= '1';
											control_mem(4) <= '0';
											
											control_wb(3 downto 0) <= "1001"; 
											
						when "0101" => --SW
											control_id(1 downto 0) <="00"; --to choose 6_bit
											
											control_rr(0) <= '1'; --

											control_ex(1 downto 0) <= "00"; -- ALU_oprn = add
											control_ex(2) <= '1'; -- input take from SE
											control_ex(3) <= '0';
											
											control_mem(2 downto 0) <= "000"; -- 
											control_mem(4) <= '1';
											control_mem(3) <= '0';
											
											control_wb(3 downto 0) <= "0000"; --DON'T WRITE_BACK
											
											
						when "1001" => --JLR
											control_id(1 downto 0) <="00"; --to choose 6_bit
											
											control_rr(0) <= '0'; --

											control_ex(1 downto 0) <= "00"; -- ALU_oprn = add
											control_ex(2) <= '1'; -- input take from SE
											control_ex(3) <= '1'; -- flush bit
											
											control_mem(2 downto 0) <= "010";
											control_mem(4 downto 3) <= "00";
											
											control_wb(3 downto 0) <= "1101"; -- WRITE_BACK PC+1
											
						when "1000" => --JAL
											control_id(1 downto 0) <="01"; --to choose 9_bit
											
											control_rr(0) <= '0'; --

											control_ex(1 downto 0) <= "00"; -- ALU_oprn = add
											control_ex(2) <= '1'; -- input take from SE
											control_ex(3) <= '1';
											
											control_mem(2 downto 0) <= "001";
											control_mem(4 downto 3) <= "00";
											
											control_wb(3 downto 0) <= "1101"; -- WRITE_BACK PC+1
											
											
						when "1100" => --BEQ
											control_id(1 downto 0) <="00"; --to choose 6_bit
											
											control_rr(0) <= '1'; --Ra value to ALU

											control_ex(1 downto 0) <= "10"; -- ALU_oprn = ---------------------COMPARE--------------------------
											control_ex(2) <= '0'; -- input take from SE
											control_ex(3) <= '0';
											
											control_mem(2 downto 0) <= "011";
											control_mem(4 downto 3) <= "00";
											
											control_wb(3 downto 0) <= "0000"; -- no need of WRITE_BACK stage itself		===
											
											
						when others =>  -- what to do here??????????
				end case;
					
		end process;
end behav;		

