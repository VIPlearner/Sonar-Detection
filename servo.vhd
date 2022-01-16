library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.NUMERIC_STD.ALL;
    
entity servo is
	Port ( clk1MHz : in STD_LOGIC;
          duty_cycle : in integer;--trigger
			 servo : out STD_LOGIC);
   end servo;
architecture behaviour of servo is
signal servo_control : std_logic;
begin
	process(Clk1MHz)
	variable counter : integer := 0;
	begin
		if (rising_edge(clk1MHz)) then
			if counter = 1 then
				servo_control <= '1';
			elsif counter = duty_cycle then
				servo_control <= '0';
			elsif counter = 2000 then
				counter := 0;
			end if;
			counter := counter + 1;
		end if;
	end process;
	servo <= servo_control;
end behaviour; 