---------------------------------------------------------------
-- test des resets de la fsm
---------------------------------------------------------------

-- reset <= 1
-- on check qu'on est bien dans l'état idle
-- reset <= 0

-- on met le start à 1
-- on check qu'on est bien dans l'état s_countdown
-- reset <= 1
-- on check qu'on est bien dans l'état idle
-- reset <= 0

-- on met le start à 1
-- on attend les 30s (3s)
-- on check qu'on est bien dans l'état s_WAIT
-- reset <= 1
-- on check qu'on est bien dans l'état idle
-- reset <= 0

-- on met le start à 1
-- on attend les 30s (3s)
-- on attend 9s
-- on fait un évènement joueur A
-- on vérifie qu'on rentre dans l'état S_P1_EVENT
-- reset <= 1
-- on check qu'on est bien dans l'état idle
-- reset <= 0

-- on met le start à 1
-- on attend les 30s (3s)
-- on attend 9s
-- on fait un évènement joueur B
-- on vérifie qu'on rentre dans l'état S_P2_EVENT
-- reset <= 1
-- on check qu'on est bien dans l'état idle
-- reset <= 0

-- on met le start à 1
-- on attend les 30s (3s)
-- on attend 9s
-- on fait un évènement joueur A
-- on attend 2s
-- on fait un évènement joueur B
-- on vérifie qu'on rentre dans l'état S_result
-- reset <= 1
-- on check qu'on est bien dans l'état idle
-- reset <= 0