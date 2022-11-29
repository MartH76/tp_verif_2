---------------------------------------------------------------
-- test des starts de la fsm
---------------------------------------------------------------

-- reset <= 1
rst <= '1';
-- on check qu'on est bien dans l'état idle
assert state = s_IDLE report "state != IDLE" severity error;
-- on met le start à 1
start <= '1';
-- on check qu'on est bien dans l'état s_countdown
assert state = s_COUNTDOWN report "state != COUNTDOWN" severity error;
-- on met le start à 1
start <= '1';
-- on attend les 30s (3s)
wait for 3 s;
-- on check qu'on est bien dans l'état s_WAIT
assert state = s_WAIT report "state != WAIT" severity error;
-- on met le start à 1
start <= '1';
-- on check qu'on est bien dans l'état s_countdown
assert state = s_COUNTDOWN report "state != COUNTDOWN" severity error;

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
assert state = s_P1_EVENT report "state != P1_EVENT" severity error;
-- on met le start à 1
start <= '1';
-- on check qu'on est bien dans l'état s_countdown
assert state = s_COUNTDOWN report "state != COUNTDOWN" severity error;

-- on met le start à 1
start <= '1';
-- on attend les 30s (3s)
wait for 3 s;
-- on attend 9s
wait for 9 s;
-- on fait un évènement joueur B
btn_p2 <= '1';
-- on vérifie qu'on rentre dans l'état S_P2_EVENT
assert state = s_P2_EVENT report "state != P2_EVENT" severity error;
-- on met le start à 1
start <= '1';   
-- on check qu'on est bien dans l'état s_countdown
assert state = s_COUNTDOWN report "state != COUNTDOWN" severity error;

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
assert state = s_RESULT report "state != RESULT" severity error;
-- on met le start à 1
start <= '1';
-- on check qu'on est bien dans l'état s_countdown
assert state = s_COUNTDOWN report "state != COUNTDOWN" severity error;