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

    signal s_rst : STD_LOGIC := '0';
    signal s_clk : STD_LOGIC := '0';
    signal s_r_e_start : STD_LOGIC := '0';
    signal s_r_e_btn_p1 : STD_LOGIC := '0';
    signal s_r_e_btn_p2 : STD_LOGIC := '0';
    signal s_display_mode : std_logic_vector(1 downto 0);
    signal s_result_p1 : signed (10 downto 0);
    signal s_result_p2 : signed (10 downto 0);
    signal s_countdown : std_logic_vector(1 downto 0);
    signal s_overflow_p1 : std_logic;
    signal s_overflow_p2 : std_logic;

    signal spy_fsm_state : std_logic_vector(5 downto 0); 

begin
    init_signal_spy("/main_fsm/state_vector", "spy_fsm_state"); 

    s_clk <= not s_clk after 5 ns;

    fsm: main_fsm port map ( 
        rst => s_rst,
        clk => s_clk,
        r_e_start => s_r_e_start,
        r_e_btn_p1 => s_r_e_btn_p1,
        r_e_btn_p2 => s_r_e_btn_p2,
        display_mode => s_display_mode,
        result_p1 => s_result_p1,
        result_p2 => s_result_p2,
        countdown => s_countdown,
        overflow_p1 => s_overflow_p1,
        overflow_p2 => s_overflow_p2
    );
    

    scenario : process
    begin
        ---------------------------------------------------------------
        -- test des starts de la fsm
        ---------------------------------------------------------------
        -- reset <= 1
        s_rst <= '0';
        -- on check qu'on est bien dans l'état idle
        assert spy_fsm_state = "000001" report "state != IDLE" severity error;
        -- on met le start à 1
        s_r_e_start <= '1';
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = "000010" report "state != COUNTDOWN" severity error;
        -- on met le start à 1
        s_r_e_start <= '0';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on check qu'on est bien dans l'état s_WAIT
        assert spy_fsm_state = "000100" report "state != WAIT" severity error;
        -- on met le start à 1
        s_r_e_start <= '1';
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = "000010" report "state != COUNTDOWN" severity error;

        -- on met le start à 1
        s_r_e_start <= '0';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on attend 9s
        wait for 9 s;
        -- on fait un évènement joueur A
        s_r_e_btn_p1 <= '1';
        wait for 1 ms;
        s_r_e_btn_p1 <= '0';
        -- on vérifie qu'on rentre dans l'état S_P1_EVENT
        assert spy_fsm_state = "001000" report "state != P1_EVENT" severity error;
        -- on met le start à 1
        s_r_e_start <= '1';
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = "000010" report "state != COUNTDOWN" severity error;

        -- on met le start à 1
        s_r_e_start <= '0';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on attend 9s
        wait for 9 s;
        -- on fait un évènement joueur B
        s_r_e_btn_p2 <= '1';
        -- on vérifie qu'on rentre dans l'état S_P2_EVENT
        assert spy_fsm_state = "010000" report "state != P2_EVENT" severity error;
        -- on met le start à 1
        s_r_e_start <= '1';
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = "000010" report "state != COUNTDOWN" severity error;

        -- on met le start à 1
        s_r_e_start <= '0';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on attend 9s
        wait for 9 s;
        -- on fait un évènement joueur A
        s_r_e_btn_p1 <= '1';
        -- on attend 2s
        wait for 2 s;
        -- on fait un évènement joueur B
        s_r_e_btn_p2 <= '1';
        -- on vérifie qu'on rentre dans l'état S_result
        assert spy_fsm_state = "100000" report "state != RESULT" severity error;
        -- on met le start à 1
        s_r_e_start <= '1';
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = "000010" report "state != COUNTDOWN" severity error;



        ---------------------------------------------------------------
        -- test des resets de la fsm
        ---------------------------------------------------------------

        -- reset <= 0
        s_rst <= '0';
        -- on check qu'on est bien dans l'état idle
        assert spy_fsm_state = "000001" report "state != IDLE" severity error;
        -- reset <= 1
        s_rst <= '1';

        -- on met le start à 1
        s_r_e_start <= '1';
        -- on check qu'on est bien dans l'état s_countdown
        assert spy_fsm_state = "000010" report "state != COUNTDOWN" severity error;
        -- reset <= 0
        s_rst <= '0';
        -- on check qu'on est bien dans l'état idle
        assert spy_fsm_state = "000001" report "state != IDLE" severity error;
        -- reset <= 1
        s_rst <= '1';

        -- on met le start à 1
        s_r_e_start <= '1';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on check qu'on est bien dans l'état s_WAIT
        assert spy_fsm_state = "000100" report "state != WAIT" severity error;
        -- reset <= 0
        s_rst <= '0';
        -- on check qu'on est bien dans l'état idle
        assert spy_fsm_state = "000001" report "state != IDLE" severity error;
        -- reset <= 1
        s_rst <= '1';

        -- on met le start à 1
        s_r_e_start <= '1';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on attend 9s
        wait for 9 s;
        -- on fait un évènement joueur A
        s_r_e_btn_p1 <= '1';
        wait for 1 ms;
        s_r_e_btn_p1 <= '0';
        -- on vérifie qu'on rentre dans l'état S_P1_EVENT
        assert spy_fsm_state = "001000" report "state != P1_EVENT" severity error;
        -- reset <= 0
        s_rst <= '0';
        -- on check qu'on est bien dans l'état idle
        assert spy_fsm_state = "000001" report "state != IDLE" severity error;
        -- reset <= 1
        s_rst <= '1';

        -- on met le start à 1
        s_r_e_start <= '1';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on attend 9s
        wait for 9 s;
        -- on fait un évènement joueur B
        s_r_e_btn_p2 <= '1';
        wait for 1 ms;
        s_r_e_btn_p2 <= '0';
        -- on vérifie qu'on rentre dans l'état S_P2_EVENT
        assert spy_fsm_state = "010000" report "state != P2_EVENT" severity error;
        -- reset <= 0
        s_rst <= '0';
        -- on check qu'on est bien dans l'état idle
        assert spy_fsm_state = "000001" report "state != IDLE" severity error;
        -- reset <= 1
        s_rst <= '1';

        -- on met le start à 1
        s_r_e_start <= '1';
        -- on attend les 30s (3s)
        wait for 3 s;
        -- on attend 9s
        wait for 9 s;
        -- on fait un évènement joueur A
        s_r_e_btn_p1 <= '1';
        -- on attend 2s
        wait for 2 s;
        -- on fait un évènement joueur B
        s_r_e_btn_p2 <= '1';
        -- on vérifie qu'on rentre dans l'état S_result
        assert spy_fsm_state = "100000" report "state != RESULT" severity error;
        -- reset <= 0
        s_rst <= '0';
        -- on check qu'on est bien dans l'état idle
        assert spy_fsm_state = "000001" report "state != IDLE" severity error;
        -- reset <= 1
        s_rst <= '1';


        ---------------------------------------------------------------
        -- test des différents timer de la fsm
        ---------------------------------------------------------------


        -- rst <= 1
        s_rst <= '1';
        -- start <= 1
        s_r_e_start <= '1';
        -- checkt that we stay 3s in the s_countdown state
        wait on spy_fsm_state for 3 s;
        if spy_fsm_state = "000010" then
            report "state = COUNTDOWN" severity error;
        end if;
        -- wait for 8s
        wait for 8 s;
        -- player A event
        s_r_e_btn_p1 <= '1';
        wait for 1 ms;
        s_r_e_btn_p1 <= '0';
        -- check that we stay 20s in the s_WAIT
        wait on spy_fsm_state for 19999 ms;
        if spy_fsm_state = "000100" then
            report "state = WAIT" severity error;
        end if;
        -- verify that the result is equal to -2 so that the 10s timer works
        assert s_result_p1 = "10000000010" report "result != -2" severity error;
        -- start <= 1
        s_r_e_start <= '1';
        -- checkt that we stay 3s in the s_countdown state
        wait on spy_fsm_state for 3 s;
        -- wait for 8s
        wait for 8 s;
        -- player B event
        s_r_e_btn_p2 <= '1';
        wait for 1 ms;
        s_r_e_btn_p2 <= '0';
        -- check that we stay 20s in the s_WAIT
        wait on spy_fsm_state for 19999 ms;
        -- verify that the result is equal to -2 so that the 10s timer works
        assert s_result_p2 = "10000000010" report "result != -2" severity error;

    end process;

end bench;