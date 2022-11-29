----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2021 10:31:42
-- Design Name: 
-- Module Name: signed2unsigned - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity signed2unsigned is
    Port ( data_in : in signed(10 downto 0);
           data_out : out STD_LOGIC_VECTOR(9 downto 0);
           sign : out STD_LOGIC);
end signed2unsigned;

architecture Behavioral of signed2unsigned is

begin

sign <= data_in(10);

process(data_in)
begin
    if data_in(10)='0' then
        data_out <= STD_LOGIC_VECTOR(data_in(9 downto 0));
    else data_out <= STD_LOGIC_VECTOR(not(data_in(9 downto 0))) + '1';
    end if;
end process;
        
end Behavioral;
