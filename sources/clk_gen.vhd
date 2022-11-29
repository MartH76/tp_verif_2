----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2021 10:13:26
-- Design Name: 
-- Module Name: clk_1s - Behavioral
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

entity clk_gen is
    Generic (nb_period_mclk : integer := 100000000);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           clr : in STD_LOGIC;
           clk_gen: out STD_LOGIC);
end clk_gen;

architecture Behavioral of clk_gen is

signal cpt : integer range 0 to nb_period_mclk;

begin

process(clk)
begin
    if rising_edge(clk) then
        if clr = '1' then
            clk_gen <= '0';
            cpt <= 0;
        elsif en='1' then
            if cpt >= nb_period_mclk-1 then
                clk_gen <= '1';
                cpt <= 0;
            else clk_gen <= '0';
                 cpt <= cpt+1;
            end if;
        end if;
    end if;
end process;

end Behavioral;
