----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2021 10:10:41
-- Design Name: 
-- Module Name: mux_mode - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           display_mode : in STD_LOGIC_VECTOR(1 downto 0);
           countdown : in STD_LOGIC_VECTOR(1 downto 0);
           result_p1 : in signed(10 downto 0);
           result_p2 : in signed(10 downto 0);
           overflow_p1 : in STD_LOGIC;
           overflow_p2 : in STD_LOGIC;
           aff_0 : out STD_LOGIC_VECTOR (3 downto 0);
           aff_1 : out STD_LOGIC_VECTOR (3 downto 0);
           aff_2 : out STD_LOGIC_VECTOR (3 downto 0);
           aff_3 : out STD_LOGIC_VECTOR (3 downto 0);
           aff_4 : out STD_LOGIC_VECTOR (3 downto 0);
           aff_5 : out STD_LOGIC_VECTOR (3 downto 0);
           aff_6 : out STD_LOGIC_VECTOR (3 downto 0);
           aff_7 : out STD_LOGIC_VECTOR (3 downto 0);
	   dp : out STD_LOGIC_VECTOR(7 downto 0);
           LED : out STD_LOGIC_VECTOR(9 downto 0));
end display;

architecture Behavioral of display is

component bin2bcd is
  port ( rst : in STD_LOGIC;
         clk : in STD_LOGIC;
         display_mode  : in std_logic_vector(1 downto 0);
         bin : in std_logic_vector(9 downto 0);
         bcd : out std_logic_vector(11 downto 0)
    );
end component;

component signed2unsigned
    Port ( data_in : in signed(10 downto 0);
           data_out : out STD_LOGIC_VECTOR(9 downto 0);
           sign : out STD_LOGIC);
end component;

component led_display
    Port ( display_mode : in STD_LOGIC_VECTOR(1 downto 0);
           unsigned_result_p1 : in STD_LOGIC_VECTOR (9 downto 0);
           unsigned_result_p2 : in STD_LOGIC_VECTOR (9 downto 0);
           LED : out STD_LOGIC_VECTOR (9 downto 0));
end component;

signal bcd_p1, bcd_p2 : std_logic_vector(11 downto 0);
signal start : std_logic;
signal unsigned_result_p1, unsigned_result_p2 : std_logic_vector(9 downto 0);
signal sign_p1, sign_p2 : std_logic := '0';

begin

signedtounsigned_inst0: signed2unsigned
port map ( data_in  => result_p1,
           data_out => unsigned_result_p1,
           sign => sign_p1);

signedtounsigned_inst1: signed2unsigned
port map ( data_in  => result_p2,
           data_out => unsigned_result_p2,
           sign => sign_p2);

bin2bcd_inst0 : bin2bcd
port map ( rst => rst,
           clk => clk,
           display_mode => display_mode,
           bin  => unsigned_result_p1,
           bcd => bcd_p1);
           
bin2bcd_inst1 : bin2bcd
port map ( rst => rst,
           clk => clk,
           display_mode => display_mode,
           bin  => unsigned_result_p2,
           bcd => bcd_p2);

led_display_inst0 : led_display
port map ( display_mode => display_mode,
           unsigned_result_p1 => unsigned_result_p1,
           unsigned_result_p2 => unsigned_result_p2,
           LED => LED);

process(display_mode,bcd_p1,bcd_p2,countdown)
begin
case display_mode is
    when "00" => -- reset
	dp <= (others =>'1');
        aff_0 <= "1111";
        aff_1 <= "1111";
        aff_2 <= "1111";
        aff_3 <= "1111";
        aff_4 <= "1111";
        aff_5 <= "1111";
        aff_6 <= "1111";
        aff_7 <= "1111";
    when "01" => -- countdown
	dp <= (others =>'1');
        aff_0 <= "00" & countdown;
        aff_1 <= "1111";
        aff_2 <= "1111";
        aff_3 <= "1111";
        aff_4 <= "1111";
        aff_5 <= "1111";
        aff_6 <= "1111";
        aff_7 <= "1111";
    when "10" => -- wait
	dp <= (others =>'1');
        aff_0 <= "1110";
        aff_1 <= "1110";
        aff_2 <= "1110";
        aff_3 <= "1110";
        aff_4 <= "1110";
        aff_5 <= "1110";
        aff_6 <= "1110";
        aff_7 <= "1110";
    when "11" => -- result
	dp <= "10111011";
        if overflow_p1 = '1' then -- display Out
            aff_4 <= "1101";
            aff_5 <= "1100";
            aff_6 <= "0000";
            aff_7 <= "1111";
        else
            aff_4 <= bcd_p1(3 downto 0);
            aff_5 <= bcd_p1(7 downto 4);
            aff_6 <= bcd_p1(11 downto 8);
            if sign_p1='1' then
                aff_7 <= "1110";
            else 
                aff_7 <= "1111";
            end if;
        end if;
        if overflow_p2 = '1' then -- display Out
            aff_0 <= "1101";
            aff_1 <= "1100";
            aff_2 <= "0000";
            aff_3 <= "1111";
        else
            aff_0 <= bcd_p2(3 downto 0);
            aff_1 <= bcd_p2(7 downto 4);
            aff_2 <= bcd_p2(11 downto 8);
            if sign_p2='1' then
                aff_3 <= "1110";
            else 
                aff_3 <= "1111";
            end if;
        end if;
    when others =>
	dp <= (others =>'1');
        aff_0 <= "1111";
        aff_1 <= "1111";
        aff_2 <= "1111";
        aff_3 <= "1111";
        aff_4 <= "1111";
        aff_5 <= "1111";
        aff_6 <= "1111";
        aff_7 <= "1111";
    end case;
end process;
end Behavioral;
