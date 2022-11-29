----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2021 10:01:17
-- Design Name: 
-- Module Name: rising_edge_detector - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rising_edge_detector is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           r_e : out STD_LOGIC);
end rising_edge_detector;

architecture Behavioral of rising_edge_detector is

signal s_temp0, s_temp1, s_temp2 : std_logic := '0';

begin

process(clk)
begin
    if rising_edge(clk) then
        s_temp0 <= btn;
        s_temp1 <= s_temp0;
        s_temp2 <= not s_temp1 and s_temp0;
        r_e <= s_temp2;
    end if;
end process;

end Behavioral;
