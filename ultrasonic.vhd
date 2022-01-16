library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ultrasonic is
	port(
	Clk: in std_logic;
	TRIG: out std_logic;
	ECHO: in std_logic;
	distance: out integer
	);
end ultrasonic;

architecture rtl of ultrasonic is

signal microseconds: std_logic;
signal counter, counter1: integer;
signal trigger: std_logic;

begin
	
	process(Clk)
	variable count0: integer range 0 to 7;
	begin
		if rising_edge(Clk) then
			if count0 = 5 then
				count0 := 0;
			else
				count0 := count0 + 1;
			end if;
			if count0 = 0 then
				microseconds <= not microseconds;
			end if;
		end if;
	end process;
	
	process(microseconds)
	variable count1: integer range 0 to 262143;
	begin
		if rising_edge(microseconds) then
			if count1 = 0 then
				counter <= 0;
				trig <= '1';
			elsif count1 = 10 then
				trig <= '0';
			end if;
			
			if count1 = 5800 then
				count1 := 0;
				counter1 <= counter;
			else
				count1 := count1 + 1;
				if ECHO = '1' then
					counter <= counter + 1;
				end if;
			end if;
		end if;
	end process;
	
	process(ECHO)
	begin
		if falling_edge(ECHO) then
			distance <= counter1 / 58;
		end if;
	end process;
	
--	TRIG <= trigger;
	
end rtl;