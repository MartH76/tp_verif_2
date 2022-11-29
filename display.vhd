
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity tb_display is
end;

architecture bench of tb_display is

component display
  port ( 
      rst : in STD_LOGIC;
      clk : in STD_LOGIC;
      result_p1 : in STD_LOGIC_VECTOR (10 downto 0);
      result_p2 : in STD_LOGIC_VECTOR (10 downto 0);
      overflow_p1 : in STD_LOGIC;
	  overflow_p2 : in STD_LOGIC;
	  countdown : in STD_LOGIC_VECTOR (1 downto 0);
	  display_mode : in STD_LOGIC_VECTOR (1 downto 0);
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
  signal result_p1: STD_LOGIC_VECTOR (10 downto 0);
  signal result_p2: STD_LOGIC_VECTOR (10 downto 0);
  signal overflow_p1: STD_LOGIC:='0';
  signal overflow_p2: STD_LOGIC:='0';
  signal countdown: STD_LOGIC_VECTOR (1 downto 0);
  signal display_mode: STD_LOGIC_VECTOR (1 downto 0);
  signal aff_0, aff_1, aff_2, aff_3, aff_4, aff_5, aff_6, aff_7 : STD_LOGIC_VECTOR(3 downto 0);
  signal dp : STD_LOGIC_VECTOR (7 downto 0);                  
  signal LED : STD_LOGIC_VECTOR(9 downto 0);

  
begin

  display_inst0: display port map ( 
    rst => rst,
    clk => clk,
    result_p1 => result_p1,
    result_p2 => result_p2,
	overflow_p1 => overflow_p1,
    overflow_p2 => overflow_p2,
    countdown => countdown,
	display_mode => display_mode,
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

	
  begin
  
	
    reset => '0';
	
	
	
	wait for 1 s;
	--TEST DU COUNTDOWN
	display_mode => '01';
	wait for 1 s;
    countdown => '11'; --3
	wait for 1 s;
	countdown => '10'; --2
	wait for 1 s;
	countdown => '01'; --1
	wait for 1 s;
	---------------------------
	--PHASE DE JEU EN ATTENTE D'UNE ACTION DES GAMERZ
	display_mode => '10';
	wait for 1 s;
	--AFFICHAGE DES RÉSULTATS
	display_mode => '11';
	wait for 1 s;
	--result_px : vecteur signé 1+10 bits. écart de temps en dizaine de ms par rapport à 10s.
	--av=avant, ap=après, g=gagnant, p=perdant, ovf=overflow, p1=joueur1, p2=joueur2
	
	overflow_p1 => '0';
	overflow_p2 => '0';
	
	
	--p1=avg, p2=avp, ovfp1=0, ovfp2=0
	result_p1 => '11110011100';--1sec
	result_p2 => '11100111000';--2sec
	wait for 1 s;
	
	
	--p1=avp, p2=avg, ovfp1=0, ovfp2=0
	result_p1 => '11100111000';--2sec
	result_p2 => '11110011100';--1sec
	wait for 1 s;
	
	
	--p1=avg, p2=app, ovfp1=0, ovfp2=0
	result_p1 => '11110011100';--1sec
	result_p2 => '00011001000';--2sec
	wait for 1 s;
	
	
	--p1=app, p2=avg, ovfp1=0, ovfp2=0
	result_p1 => '00011001000';--2sec
	result_p2 => '11110011100';--1sec
	wait for 1 s;
	
	
	--p1=avp, p2=apg, ovfp1=0, ovfp2=0
	result_p1 => '11100111000';--2sec
	result_p2 => '00001100100';--1sec
	wait for 1 s;
	
	
	--p1=apg, p2=avp, ovfp1=0, ovfp2=0
	result_p1 => '00001100100';--1sec
	result_p2 => '11100111000';--2sec
	wait for 1 s;
	
	
	--p1=app, p2=axg, ovfp1=1, ovfp2=0
	overflow_p1 => '1';
	overflow_p2 => '0';
	result_p1 => '10000000000';--x
	result_p2 => '11110011100';--1sec
	
	wait for 1 s;
	
	
	--p1=axg, p2=app, ovfp1=0, ovfp2=1
	overflow_p1 => '0';
	overflow_p2 => '1';
	result_p1 => '11110011100';--1sec
	result_p2 => '10000000000';--x
	
	wait for 1 s;
	
	
	--p1=ap, p2=ap, ovfp1=1, ovfp2=1
	overflow_p1 => '1';
	overflow_p2 => '1';
	result_p1 => '10000000000';--x
	result_p2 => '10000000000';--x
		
		
		
		
	reset => '1';
	
	
	
	wait for 1 s;
	--TEST DU COUNTDOWN
	display_mode => '01';
	wait for 1 s;
    countdown => '11'; --3
	wait for 1 s;
	countdown => '10'; --2
	wait for 1 s;
	countdown => '01'; --1
	wait for 1 s;
	---------------------------
	--PHASE DE JEU EN ATTENTE D'UNE ACTION DES GAMERZ
	display_mode => '10';
	wait for 1 s;
	--AFFICHAGE DES RÉSULTATS
	display_mode => '11';
	wait for 1 s;
	--result_px : vecteur signé 1+10 bits. écart de temps en dizaine de ms par rapport à 10s.
	--av=avant, ap=après, g=gagnant, p=perdant, ovf=overflow, p1=joueur1, p2=joueur2
	
	overflow_p1 => '0';
	overflow_p2 => '0';
	
	
	--p1=avg, p2=avp, ovfp1=0, ovfp2=0
	result_p1 => '11110011100';--1sec
	result_p2 => '11100111000';--2sec
	wait for 1 s;
	
	
	--p1=avp, p2=avg, ovfp1=0, ovfp2=0
	result_p1 => '11100111000';--2sec
	result_p2 => '11110011100';--1sec
	wait for 1 s;
	
	
	--p1=avg, p2=app, ovfp1=0, ovfp2=0
	result_p1 => '11110011100';--1sec
	result_p2 => '00011001000';--2sec
	wait for 1 s;
	
	
	--p1=app, p2=avg, ovfp1=0, ovfp2=0
	result_p1 => '00011001000';--2sec
	result_p2 => '11110011100';--1sec
	wait for 1 s;
	
	
	--p1=avp, p2=apg, ovfp1=0, ovfp2=0
	result_p1 => '11100111000';--2sec
	result_p2 => '00001100100';--1sec
	wait for 1 s;
	
	
	--p1=apg, p2=avp, ovfp1=0, ovfp2=0
	result_p1 => '00001100100';--1sec
	result_p2 => '11100111000';--2sec
	wait for 1 s;
	
	
	--p1=app, p2=axg, ovfp1=1, ovfp2=0
	overflow_p1 => '1';
	overflow_p2 => '0';
	result_p1 => '10000000000';--x
	result_p2 => '11110011100';--1sec
	
	wait for 1 s;
	
	
	--p1=axg, p2=app, ovfp1=0, ovfp2=1
	overflow_p1 => '0';
	overflow_p2 => '1';
	result_p1 => '11110011100';--1sec
	result_p2 => '10000000000';--x
	
	wait for 1 s;
	
	
	--p1=ap, p2=ap, ovfp1=1, ovfp2=1
	overflow_p1 => '1';
	overflow_p2 => '1';
	result_p1 => '10000000000';--x
	result_p2 => '10000000000';--x
	
	
	
	
	wait;
  end process;
  
end;
