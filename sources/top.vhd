--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
--Date        : Mon Nov 15 16:04:34 2021
--Host        : DESKTOP-0BD5P7T running 64-bit major release  (build 9200)
--Command     : generate_target top.bd
--Design      : top
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity top is
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
end top;

architecture STRUCTURE of top is

  component rising_edge_detector is
  port (
    clk : in STD_LOGIC;
    btn : in STD_LOGIC;
    r_e : out STD_LOGIC
  );
  end component rising_edge_detector;
  
  component main_fsm is
  port (   rst : in STD_LOGIC;
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
  end component main_fsm;

component display is
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
end component display;

  signal r_e_start : STD_LOGIC;
  signal r_e_p1 : STD_LOGIC;
  signal r_e_p2 : STD_LOGIC;
  signal display_mode : STD_LOGIC_VECTOR(1 downto 0);
  signal result_p1 : signed(10 downto 0);
  signal result_p2 : signed(10 downto 0);
  signal countdown : STD_LOGIC_VECTOR(1 downto 0);
  signal overflow_p1 : STD_LOGIC;
  signal overflow_p2 : STD_LOGIC;
  signal rstb : STD_LOGIC;
  
begin

rstb <= not(rst);

main_fsm_inst0: component main_fsm
     port map (
         rst => rstb,
         clk => clk,
         r_e_start => r_e_start,
         r_e_btn_p1 => r_e_p1,
         r_e_btn_p2 => r_e_p2,
         display_mode => display_mode,
         result_p1(10 downto 0) => result_p1(10 downto 0),
         result_p2(10 downto 0) => result_p2(10 downto 0),
         countdown => countdown,
         overflow_p1 => overflow_p1,
         overflow_p2 => overflow_p2
         
    );
rising_edge_detector_inst0: component rising_edge_detector
     port map (
      btn => BTN_Start,
      clk => clk,
      r_e => r_e_start
    );
rising_edge_detector_inst1: component rising_edge_detector
     port map (
      btn => BTN_Player1,
      clk => clk,
      r_e => r_e_p1
    );
rising_edge_detector_inst2: component rising_edge_detector
     port map (
      btn => BTN_Player2,
      clk => clk,
      r_e => r_e_p2
    );
    
display_inst0 : display 
port map ( rst => rst,
           clk => clk,
           display_mode => display_mode,
           countdown => countdown,
           result_p1 => result_p1,
           result_p2 => result_p2,
           overflow_p1 => overflow_p1,
           overflow_p2 => overflow_p2,
           aff_0 => aff_0,
           aff_1 => aff_1,
           aff_2 => aff_2,
           aff_3 => aff_3,
           aff_4 => aff_4,
           aff_5 => aff_5,
           aff_6 => aff_6,
           aff_7 => aff_7,
	   dp => dp,
           LED => LED);

end STRUCTURE;
