library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity tb_bin2bcd is
end;

architecture bench of tb_bin2bcd is

    component bin2bcd
        Port ( 
            rst : in STD_LOGIC;
            clk : in STD_LOGIC;
            display_mode  : in std_logic_vector(1 downto 0);
            bin : in std_logic_vector(9 downto 0);
            bcd : out std_logic_vector(11 downto 0));        
    end component;

    signal s_rst : STD_LOGIC := '1';
    signal s_clk : STD_LOGIC := '0';
    signal s_display_mode : std_logic_vector(1 downto 0) := "00";
    signal s_bin : std_logic_vector(9 downto 0) := "0000000000";
    signal s_bcd : std_logic_vector(11 downto 0);

    signal spy_fsm_state : std_logic_vector(4 downto 0); 

    signal nb_shift : integer := 0;


begin
    fsm: bin2bcd port map ( 
        rst => s_rst,
        clk => s_clk,
        display_mode => s_display_mode,
        bin => s_bin,
        bcd => s_bcd);

    init_signal_spy("/bin2bcd/state_vector", "spy_fsm_state"); 

    s_clk <= not s_clk after 5 ns;
    
    stimulus : process
    begin
        -- reset à 0
        s_rst <= '0';
        wait for 10 ns;
        s_rst <= '1';

        -- check that we are in IDLE state
        assert (spy_fsm_state = "00001") report "Error: not in IDLE state" severity error;
        
        -- change value of bin
        s_bin <= "0000000001";
        wait for 0 ns;

        -- for loop on nb_shift
        for nb_shift in 0 to 9 loop
            -- check that we are in s_SHIFT state
            assert (spy_fsm_state = "00010") report "Error: not in s_SHIFT state" severity error;
            wait until rising_edge(s_clk);
            -- check that we are in s_CHECK_SHIFT_INDEX state
            assert (spy_fsm_state = "00100") report "Error: not in s_CHECK_SHIFT_INDEX state" severity error;
            wait until rising_edge(s_clk);
            -- check that we are in s_ADD state
            assert (spy_fsm_state = "01000") report "Error: not in s_ADD state" severity error;
            wait until rising_edge(s_clk);
        end loop;

        -- check that we are in s_SHIFT state
        assert (spy_fsm_state = "00010") report "Error: not in s_SHIFT state" severity error;
        wait until rising_edge(s_clk);
        -- check that we are in s_CHECK_SHIFT_INDEX state
        assert (spy_fsm_state = "00100") report "Error: not in s_CHECK_SHIFT_INDEX state" severity error;
        wait until rising_edge(s_clk);
        -- check that we are in s_BCD_DONE state
        assert (spy_fsm_state = "10000") report "Error: not in s_BCD_DONE state" severity error;
        wait until rising_edge(s_clk);
        --check that we are in IDLE state
        assert (spy_fsm_state = "00001") report "Error: not in IDLE state" severity error;
    end process;
end bench;