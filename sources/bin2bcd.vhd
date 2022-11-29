library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
 
entity bin2bcd is
  Port ( rst : in STD_LOGIC;
         clk : in STD_LOGIC;
         display_mode  : in std_logic_vector(1 downto 0);
         bin : in std_logic_vector(9 downto 0);
         bcd : out std_logic_vector(11 downto 0)
    );
end entity bin2bcd;
 
architecture Behavioral of bin2bcd is

type state is (s_IDLE, s_SHIFT, s_CHECK_SHIFT_INDEX, s_ADD, s_BCD_DONE);
signal current_state, next_state : state := s_IDLE;

signal previous_bin : STD_LOGIC_VECTOR(9 downto 0):= (others => '0');

signal temp_bcd : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
signal temp_bin : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
signal count_shift : integer range 0 to 9:=0;

signal state_vector : STD_LOGIC_VECTOR(4 downto 0):="00001";

begin

process(rst, clk)
begin
     if rst='1' then
          current_state <= s_IDLE;
     elsif rising_edge(clk) then
          current_state <= next_state;
     end if;
 end process;

process (current_state, display_mode, bin,previous_bin)

begin
        case current_state is
            when s_IDLE =>
		state_vector <= "00001";
                if display_mode = "11" then
                    if previous_bin /= bin then
                        previous_bin <= bin;
                        next_state <= s_SHIFT;
                        temp_bcd <= (others => '0');
                        temp_bin <=bin;
                        bcd <= (others => '1');
                        count_shift <= 0;
                    end if;
                else
                    bcd <= (others => '1');
                end if;

            when s_SHIFT =>
		state_vector <= "00010";
                temp_bcd <= temp_bcd(10 downto 0) & temp_bin(9);  
                temp_bin <= temp_bin(8 downto 0) & '0';
                next_state <= s_CHECK_SHIFT_INDEX;
 
            when s_CHECK_SHIFT_INDEX => 
		  state_vector <= "00100";
                  if count_shift > 9 then
                    count_shift <= 0;
                    next_state    <= s_BCD_DONE;
                  else
                    next_state    <= s_ADD;
                  end if;
 
            when s_ADD =>   
		state_vector <= "01000";                 
                count_shift <= count_shift + 1;
                if temp_bcd(11 downto 8)>4 then
                    temp_bcd(11 downto 8) <= temp_bcd(11 downto 8)+"0011";
                end if;
                if temp_bcd(7 downto 4)>4 then
                    temp_bcd(7 downto 4) <= temp_bcd(7 downto 4)+"0011";
                end if;
                if temp_bcd(3 downto 0)>4 then
                    temp_bcd(3 downto 0) <= temp_bcd(3 downto 0)+"0011";
                end if;
                next_state <= s_SHIFT;
 
            when s_BCD_DONE =>
		state_vector <= "10000";
                bcd <= temp_bcd;
                next_state <= s_IDLE;
        
            when others =>
                next_state <= s_IDLE;
		state_vector <= "00001";
           
      end case;
  end process;
 

   
end Behavioral;