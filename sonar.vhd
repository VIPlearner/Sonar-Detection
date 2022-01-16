library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.NUMERIC_STD.ALL;
    
entity sonar is
	Port ( clk : in STD_LOGIC;
          trig : out STD_LOGIC;--trigger
          echo : in STD_LOGIC;
			 servo1 : out STD_LOGIC;
			 pulse : out STD_LOGIC_VECTOR(9 downto 0);
          HEX1 : out std_logic_vector(6 downto 0); --most significant bit of distance in binary form
          HEX0 : out std_logic_vector(6 downto 0));
   end sonar;
architecture behaviour of sonar is 
signal distance: integer;
signal pulselength: integer range 1000 to 1900;
signal microseconds, seconds, direction, servo_output: std_logic;
signal dist: std_logic_vector(6 downto 0);
signal pulse_next: std_logic_vector(9 downto 0);
signal cm1: std_logic_vector(3 downto 0);
signal cm0: std_logic_vector(3 downto 0);
signal angle: integer;
	component ultrasonic 
        Port ( Clk: in std_logic;
					TRIG: out std_logic;
					ECHO: in std_logic;
					distance: out integer);
    end component;
	 
	 component servo is
        Port ( clk1MHz : in STD_LOGIC;
          duty_cycle : in integer;--trigger
			 servo : out STD_LOGIC);
    end component;
	 
	 component seg_7 is
			port(	c : in std_logic_vector(3 downto 0);
					display :out std_logic_vector(6 downto 0));
		end component;
	begin	
			H0: ultrasonic PORT MAP (Clk, trig, echo, distance);
			H1: servo PORT MAP (microseconds, pulselength, servo_output);
			dist <= std_logic_vector(to_unsigned(distance, 7));
			cm1 <= 	x"9" when distance >=90 else
						x"8" when distance >=80 else
						x"7" when distance >=70 else
						x"6" when distance >=60 else		
						x"5" when distance >=50 else
						x"4" when distance >=40 else
						x"3" when distance >=30 else
						x"2" when distance >=20 else
						x"1" when distance >=10 else
						x"0";
			cm0 <= std_logic_vector(to_unsigned((distance - to_integer(unsigned(cm1))*10),4));
			
			MSD: seg_7 PORT MAP (cm1(3 downto 0), HEX1(6 downto 0));
			LSD: seg_7 PORT MAP (cm0(3 downto 0), HEX0(6 downto 0));
			angle <= 	0 when pulselength = 1000 else
							1 when pulselength = 1100 else
							2 when pulselength = 1200 else
							3 when pulselength = 1300 else
							4 when pulselength = 1400 else
							5 when pulselength = 1500 else
							6 when pulselength = 1600 else
							7 when pulselength = 1700 else
							8 when pulselength = 1800 else
							9 when pulselength = 1900;
			direction<= '1' when pulselength = 1000 else
							'0' when pulselength = 1900;
			pulse_next <= 	"0000000001" when angle = 0 else
								"0000000010" when angle = 1 else
								"0000000100" when angle = 2 else
								"0000001000" when angle = 3 else
								"0000010000" when angle = 4 else
								"0000100000" when angle = 5 else
								"0001000000" when angle = 6 else
								"0010000000" when angle = 7 else
								"0100000000" when angle = 8 else
								"1000000000" when angle = 9;
			
	process(Clk)
	variable count0: integer range 0 to 7;
	variable count1: integer;
	
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
		
		if rising_edge(Clk) then
			if count1 = 5000000 then
				count1 := 0;
			else
				count1 := count1 + 1;
			end if;
			if count1 = 0 then
				seconds <= not seconds;
			end if;
		end if;
		
	end process;
     
	process(microseconds)
	variable count1 : integer:= 0;
	begin
		if rising_edge(microseconds) then
			if distance  < 20 then
				if count1 = 0 then
					pulse <= pulse_next;
				elsif count1 = 20 - distance  then
					pulse <= "0000000000";
				end if;
			else
				pulse <= "0000000000";
			end if;
			
			if count1 = 20 then
				count1 := 0;
				
			else
				count1 := count1 + 1;
			end if;
		end if;
	end process;
	
	process(seconds)
	begin
		if (rising_edge(seconds)) then
			if direction = '1' then
				pulselength <= pulselength + 100;
			elsif direction >= '0' then
				pulselength <= pulselength - 100;
			end if;
		end if;
	end process;
	servo1 <= servo_output;
end behaviour;