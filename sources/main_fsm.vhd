----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2021 12:17:59
-- Design Name: 
-- Module Name: main_fsm - Behavioral
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
use IEEE.numeric_std.ALL;

entity main_fsm is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           r_e_start : in STD_LOGIC;
           r_e_btn_p1 : in STD_LOGIC;
           r_e_btn_p2 : in STD_LOGIC;
           display_mode : out std_logic_vector(1 downto 0);
           result_p1 : out signed (10 downto 0);
           result_p2 : out signed (10 downto 0);
           countdown : out std_logic_vector(1 downto 0);
           overflow_p1 : out std_logic;
           overflow_p2 : out std_logic);        
end main_fsm;

architecture Behavioral of main_fsm is

component clk_gen
    Generic (nb_period_mclk : integer := 100000000);
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           en : in STD_LOGIC;
           clk_gen: out STD_LOGIC);
end component;


type state is (s_IDLE, s_COUNTDOWN, s_WAIT, s_P1_EVENT, s_P2_EVENT,s_RESULT);
signal current_state, next_state : state ;

signal clr_clk_1s,en_clk_1s,clk_1s : std_logic := '0';
signal clr_clk_10ms,en_clk_10ms,clk_10ms : std_logic := '0';
 
signal cpt_1s : integer range 0 to 10 :=0;
signal cpt_10ms : integer range 0 to 2048 :=0;
signal abs_res_p1 : integer range 0 to 2048 := 0;
signal abs_res_p2 : integer range 0 to 2048 := 0;

signal state_vector : STD_LOGIC_VECTOR(5 downto 0) := "000001";

begin

clk_gen_inst0: clk_gen
--generic map( nb_period_mclk => 100000000)
generic map( nb_period_mclk => 1000)
port map ( clk => clk,
           clr => clr_clk_1s,
           en => en_clk_1s,
           clk_gen => clk_1s);
           
clk_gen_inst1: clk_gen
--generic map( nb_period_mclk => 1000000)
generic map( nb_period_mclk => 10)
port map ( clk => clk,
           clr => clr_clk_10ms,
           en => en_clk_10ms,
           clk_gen => clk_10ms);
           
process(rst, clk)
begin
     if rst='1' then
          current_state <= s_IDLE;
     elsif rising_edge(clk) then
          current_state <= next_state;
     end if;
 end process;
 
process(current_state, r_e_start, r_e_btn_P1, r_e_btn_P2, clk_1s, clk_10ms)
begin
        case current_state is
            when s_IDLE => 
		state_vector <= "000001";
                display_mode <= "00";
                result_P1 <= (others =>'0');
                result_P2 <= (others =>'0');
                abs_res_p1 <=0;
                abs_res_p2 <= 0;
                cpt_1s <= 0;
                cpt_10ms <= 0;
                clr_clk_1s<='1';
                en_clk_1s <='0';
                clr_clk_10ms<='1';
                en_clk_10ms <='0';
                countdown <= "00";
                overflow_p1 <= '0';
                overflow_p2 <= '0';
                if r_e_start='1' then
                    next_state <= s_COUNTDOWN;
                end if;
            when s_COUNTDOWN => 
		state_vector <= "000010";
                display_mode <= "01";
                result_P1 <= (others =>'0');
                result_P2 <= (others =>'0');              
                abs_res_p1 <=0;
                abs_res_p2 <= 0;
                cpt_10ms <= 0;
                clr_clk_10ms<='1';
                en_clk_10ms <='0';
                overflow_p1 <= '0';
                overflow_p2 <= '0';                            
                en_clk_1s <='1';
                countdown <= "11"-std_logic_vector(to_unsigned(cpt_1s,2));
                if r_e_start = '1' then 
                    cpt_1s <=0;
                    clr_clk_1s<='1';
                else 
                    clr_clk_1s<='0';
                    if clk_1s = '1' then
                        if cpt_1s>=2 then
                            en_clk_1s <= '0';
                            cpt_1s <= 0;
                            next_state <= s_WAIT;                                                        
                        else 
                            cpt_1s <= cpt_1s + 1;                          
                        end if;
                    end if;
                end if;               
            when s_WAIT => 
		state_vector <= "000100";
                display_mode <= "10";
                clr_clk_10ms <= '0';
                en_clk_10ms <='1';
                if r_e_start = '1' then 
                    cpt_1s <=0;
                    clr_clk_1s<='1';
                    next_state <= s_COUNTDOWN;
                elsif r_e_btn_P1='1' then
                        next_state <= s_P1_EVENT;
                        abs_res_p1 <= cpt_10ms;
                elsif clk_10ms ='1' then 
                    if cpt_10ms >= 2000 then
                        next_state<= s_RESULT;
                        overflow_p1 <= '1';
                        overflow_p2 <= '1';
                        abs_res_p1 <= 0;
                        abs_res_p2 <= 0;
                    else
                        cpt_10ms <= cpt_10ms +1;
                    end if;
                end if;
            when s_P1_EVENT => 
		state_vector <= "001000";
                display_mode <= "10";
                if r_e_start = '1' then 
                    cpt_1s <=0;
                    clr_clk_1s<='1';
                    next_state <= s_COUNTDOWN;
                else
                    if cpt_10ms >= 2000 then
                        next_state<= s_RESULT;
                        overflow_p2 <= '1';
                        abs_res_p2 <= 0;
                    else
                        if clk_10ms ='1' then
                            cpt_10ms <= cpt_10ms +1;
                        end if;
                        if r_e_btn_P2='1' then
                            abs_res_p2 <= cpt_10ms;
                            next_state <= s_RESULT;
                        end if;
                    end if;
                end if;
          when s_P2_EVENT => 
		state_vector <= "010000";
                display_mode <= "10";
                if r_e_start = '1' then 
                    cpt_1s <=0;
                    clr_clk_1s<='1';
                    next_state <= s_COUNTDOWN;
                else
                    if cpt_10ms >= 2000 then
                        next_state<= s_RESULT;
                        overflow_p1 <= '1';
                        abs_res_p1 <= 0;
                    else
                        if clk_10ms ='1' then
                            cpt_10ms <= cpt_10ms +1;
                        end if;
                        if r_e_btn_P1='1' then
                            next_state <= s_RESULT;
                             abs_res_p1 <= cpt_10ms;
                        end if;
                    end if;
                end if;
          when s_RESULT => 
		   state_vector <= "100000";
                    display_mode <= "11";
                    result_P1 <= to_signed((1000 - abs_res_p1),11);
                    result_P2 <= to_signed((1000 - abs_res_p2),11);
                    if r_e_start = '1' then 
                        cpt_1s <=0;
                        clr_clk_1s<='1';
                        next_state <= s_COUNTDOWN;
                    end if;
          when others => 
              next_state <= s_IDLE;
	      state_vector <= "000001";
     end case;
end process;

end Behavioral;
