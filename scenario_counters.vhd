---------------------------------------------------------------
-- test des différents timer de la fsm
---------------------------------------------------------------


-- rst <= 1
-- start <= 1
-- checkt that we stay 3s in the s_countdown state
-- wait for 8s
-- player A event
-- check that we stay 20s in the s_WAIT
-- verify that the result is equal to -2 so that the 10s timer works
-- start <= 1
-- checkt that we stay 3s in the s_countdown state
-- wait for 8s
-- player B event
-- check that we stay 20s in the s_WAIT
-- verify that the result is equal to -2 so that the 10s timer works
