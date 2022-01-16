library ieee;
use ieee.std_logic_1164.all;

entity seg_7 is
port(
		c : in std_logic_vector(3 downto 0);
		display :out std_logic_vector(6 downto 0)
);
end entity seg_7;

architecture Behavioral of seg_7 is
begin
PROCESS(C)
   BEGIN
     CASE  C is
	    when "0000" => display <= "1000000"; --0
		 when "0001" => display <= "1111001"; --1
		 when "0010" => display <= "0100100"; --2
		 when "0011" => display <= "0110000"; --3
		 when "0100" => display <= "0011001"; --4
		 when "0101" => display <= "0010010"; --5
		 when "0110" => display <= "0000010"; --6
		 when "0111" => display <= "1111000"; --7
		 when "1000" => display <= "0000000"; --8
		 when "1001" => display <= "0010000"; --9
		 when "1010" => display <= "0111111"; -- -
		 when others => display <= "1111111"; 
	 END CASE;
 END PROCESS;
end architecture;