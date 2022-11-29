library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity tb_fsm is
end;

architecture bench of tb_fsm is

    component main_fsm
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
    end component;

    signal rst : STD_LOGIC := '0';
    signal clk : STD_LOGIC := '0';
    signal r_e_start : STD_LOGIC := '0';
    signal r_e_btn_p1 : STD_LOGIC := '0';
    signal r_e_btn_p2 : STD_LOGIC := '0';
    signal display_mode : std_logic_vector(1 downto 0);
    signal result_p1 : signed (10 downto 0);
    signal result_p2 : signed (10 downto 0);
    signal countdown : std_logic_vector(1 downto 0);
    signal overflow_p1 : std_logic;
    signal overflow_p2 : std_logic;

    signal spy_fsm_state : std_logic_vector(5 downto 0); 

begin
    init_signal_spy("/main_fsm/state_vector", "spy_fsm_state"); 

    clk <= not clk after 5 ns;

    fsm: main_fsm port map ( 
        rst => rst,
        clk => clk,
        r_e_start => r_e_start,
        r_e_btn_p1 => r_e_btn_p1,
        r_e_btn_p2 => r_e_btn_p2,
        display_mode => display_mode,
        result_p1 => result_p1,
        result_p2 => result_p2,
        countdown => countdown,
        overflow_p1 => overflow_p1,
        overflow_p2 => overflow_p2
    );


    scenario : process
        ---------------------------------------------------------------
        -- test des starts de la fsm
        ---------------------------------------------------------------
        -- reset <= 1
        rst <= '1';
        -- on check qu'on est bien dans l'état idle
        assert spy_fsm_state = s_IDLE report "state != IDLE" severity error;
        -- on met le start à 1
        start <= '1';
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = s_COUNTDOWN report "state != COUNTDOWN" severity error;
        -- on met le start à 1
        start <= '1';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on check qu'on est bien dans l'état s_WAIT
        assert spy_fsm_state = s_WAIT report "state != WAIT" severity error;
        -- on met le start à 1
        start <= '1';
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = s_COUNTDOWN report "state != COUNTDOWN" severity error;

        -- on met le start à 1
        start <= '1';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on attend 9s
        wait for 9 s;
        -- on fait un évènement joueur A
        btn_p1 <= '1';
        wait for 1 ms;
        btn_p1 <= '0';
        -- on vérifie qu'on rentre dans l'état S_P1_EVENT
        assert spy_fsm_state = s_P1_EVENT report "state != P1_EVENT" severity error;
        -- on met le start à 1
        start <= '1';
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = s_COUNTDOWN report "state != COUNTDOWN" severity error;

        -- on met le start à 1
        start <= '1';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on attend 9s
        wait for 9 s;
        -- on fait un évènement joueur B
        btn_p2 <= '1';
        -- on vérifie qu'on rentre dans l'état S_P2_EVENT
        assert spy_fsm_state = s_P2_EVENT report "state != P2_EVENT" severity error;
        -- on met le start à 1
        start <= '1';   
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = s_COUNTDOWN report "state != COUNTDOWN" severity error;

        -- on met le start à 1
        start <= '1';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on attend 9s
        wait for 9 s;
        -- on fait un évènement joueur A
        btn_p1 <= '1';
        -- on attend 2s
        wait for 2 s;
        -- on fait un évènement joueur B
        btn_p2 <= '1';
        -- on vérifie qu'on rentre dans l'état S_result
        assert spy_fsm_state = s_RESULT report "state != RESULT" severity error;
        -- on met le start à 1
        start <= '1';
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = s_COUNTDOWN report "state != COUNTDOWN" severity error;
    end process;

end bench;