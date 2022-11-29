
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity tb_top is
end;

architecture bench of tb_top is

component top
  port ( 
      rst : in STD_LOGIC;
      clk : in STD_LOGIC;
      BTN_Player1 : in STD_LOGIC;
      BTN_Player2 : in STD_LOGIC;
      BTN_Start : in STD_LOGIC;
      aff_0 : out STD_LOGIC_VECTOR (3 downto 0);
      aff_1 : out STD_LOGIC_VECTOR (3 downto 0);
      aff_2 : out STD_LOGIC_VECTOR (3 downto 0);
      aff_3 : out STD_LOGIC_VECTOR (3 downto 0);
      aff_4 : out STD_LOGIC_VECTOR (3 downto 0);
      aff_5 : out STD_LOGIC_VECTOR (3 downto 0);
      aff_6 : out STD_LOGIC_VECTOR (3 downto 0);
      aff_7 : out STD_LOGIC_VECTOR (3 downto 0);
      dp : out STD_LOGIC_VECTOR (7 downto 0);
      LED : out STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
end component;

  

  signal rst: STD_LOGIC := '0';
  signal clk: STD_LOGIC :='0';
  signal start: STD_LOGIC:='0';
  signal btn_p1: STD_LOGIC:='0';
  signal btn_p2: STD_LOGIC:='0';
  signal aff_0, aff_1, aff_2, aff_3, aff_4, aff_5, aff_6, aff_7 : STD_LOGIC_VECTOR(3 downto 0);
  signal dp : STD_LOGIC_VECTOR (7 downto 0);                  
  signal LED : STD_LOGIC_VECTOR(9 DOWNTO 0);

  --signal spy_test : std_logic/std_logic_vector( N downto 0 );
  
begin

  --init_signal_spy("/top_inst0/to/the/spy_signal", "spy_test");

  top_inst0: top port map ( 
    rst => rst,
    clk => clk,
    BTN_Player1 => btn_p1,
    BTN_Player2 => btn_p2,
    BTN_Start => start,
    aff_0 => aff_0,
    aff_1 => aff_1,
    aff_2 => aff_2,
    aff_3 => aff_3,
    aff_4 => aff_4,
    aff_5 => aff_5,
    aff_6 => aff_6,
    aff_7 => aff_7,
    dp => dp,                   
    LED => LED
);

clk <= not clk after 5 ns;

  stimulus: process

    procedure start_pressed(
    duration: time) is
    begin
        start <= '1';
        wait for duration;
        start <= '0';
   end;
   
    procedure p1_pressed(
    duration: time) is
    begin
        btn_p1 <= '1';
        wait for duration;
        btn_p1 <= '0';
   end;
   
    procedure p2_pressed(
    duration: time) is
    begin
        btn_p2 <= '1';
        wait for duration;
        btn_p2 <= '0';
   end;

  begin
    
    wait;
  
  end process;
  
end;
