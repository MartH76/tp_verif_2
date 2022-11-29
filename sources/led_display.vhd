----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2021 10:49:29
-- Design Name: 
-- Module Name: winner_display - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity led_display is
    Port ( display_mode : in STD_LOGIC_VECTOR(1 downto 0);
           unsigned_result_p1 : in STD_LOGIC_VECTOR (9 downto 0);
           unsigned_result_p2 : in STD_LOGIC_VECTOR (9 downto 0);
           LED : out STD_LOGIC_VECTOR (9 downto 0));
end led_display;

architecture Behavioral of led_display is

begin

process(display_mode,unsigned_result_p1,unsigned_result_p2)
begin
    if display_mode = "11" then
        if unsigned_result_p1 < unsigned_result_p2 then
            LED <= "1111100000";
        elsif unsigned_result_p2 < unsigned_result_p1 then
            LED <= "0000011111";
        else LED <= "1111111111";
        end if;
    else 
        LED <= (others => '0');
    end if;
end process;

end Behavioral;
