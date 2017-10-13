library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity EQEP is
	port(clk:in std_logic;
		 reset:in std_logic;  
		 EQEPA:out std_logic;
		 EQEPB:out std_logic;
		 EQEPI:out std_logic
		 );
end;
architecture EQEP of EQEP is
signal EQEPA_temp:std_logic:= '0';
signal EQEPB_temp:std_logic:= '0';
signal clk_1us:   std_logic:= '1';
signal EQEPI_temp :std_logic:= '0';
begin
process(clk,reset)--
variable counter:integer range 0 to 50;
begin
	if(reset = '0') then 
	clk_1us <= '0';
	elsif(clk'event and clk = '1') then
		if(counter = 12) then
			counter :=0;
			clk_1us <= not clk_1us;
		else
			counter :=counter+1;
		
		end if;
	end if;
end process; 

process (clk_1us,reset) 
variable counter:integer range 0 to 300;
variable puse_cnt:integer range 0 to 2000;
begin
	if(reset = '0') then 
		EQEPA_temp <= '0';
		EQEPB_temp <= '0';
		EQEPI_temp <= '0';
	elsif(clk_1us'event and clk_1us = '1') then
		--EQEPA <= not PWMa_temp;
		if(counter = 50) then
			EQEPA_temp <= not EQEPA_temp;
			if(EQEPI_temp = '1') then
					EQEPI_temp <= '0';
				end if;
			counter:=counter+1;
		elsif(counter = 100) then
			EQEPB_temp <= not EQEPB_temp;
			counter :=1;
			puse_cnt:=puse_cnt+1;
			if(puse_cnt = 20) then
				if(EQEPI_temp = '0') then
					EQEPI_temp <= '1';
				end if;
				puse_cnt :=1;
			end if;
			
		else
			counter := counter+1;
		end if;
	end if;
end process;

process (clk)  
begin
	 if(clk'event and clk = '1') then
		EQEPA <=   EQEPA_temp;
		EQEPB <=   EQEPB_temp;
		EQEPI <=   EQEPI_temp;
	end if;
end process;

end EQEP;