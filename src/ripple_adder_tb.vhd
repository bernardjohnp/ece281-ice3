--+----------------------------------------------------------------------------
--| Testbench for 4-bit Ripple-Carry Adder
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ripple_adder_tb is
end ripple_adder_tb;

architecture test_bench of ripple_adder_tb is 
    
    component ripple_adder is
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Cin : in STD_LOGIC;
               S : out STD_LOGIC_VECTOR (3 downto 0);
               Cout : out STD_LOGIC);
    end component ripple_adder;
  
    signal w_addends : std_logic_vector(7 downto 0) := x"00";
    signal w_sum : std_logic_vector(3 downto 0) := x"0";
    signal w_Cin, w_Cout : std_logic;

begin
    ripple_adder_uut : ripple_adder port map (
        A => w_addends(3 downto 0),
        B => w_addends(7 downto 4),
        Cin => w_Cin,
        S => w_sum,
        Cout => w_Cout
    );
    
    test_process : process 
begin
    -- Test 0 + 0 + 0
    w_addends <= x"00"; w_Cin <= '0'; wait for 10 ns;
        assert (w_sum = x"0" and w_Cout = '0') report "0+0+0 failed" severity failure;

    -- Test 8 + F + 0 (Overflow case)
    w_addends <= x"8F"; w_Cin <= '0'; wait for 10 ns;
        assert (w_sum = x"7" and w_Cout = '1') report "8+F+0 failed" severity failure;

    -- Test 1 + 1 + 0 (Carry propagation)
    w_addends <= x"11"; w_Cin <= '0'; wait for 10 ns;
        assert (w_sum = x"2" and w_Cout = '0') report "1+1+0 failed" severity failure;

    -- Test 0 + 1 + 1 (Carry-in)
    w_addends <= x"01"; w_Cin <= '1'; wait for 10 ns;
        assert (w_sum = x"2" and w_Cout = '0') report "0+1+1 failed" severity failure;

    -- Test F + F + 1 (Max values + carry)
    w_addends <= x"FF"; w_Cin <= '1'; wait for 10 ns;
        assert (w_sum = x"F" and w_Cout = '1') report "F+F+1 failed" severity failure;

    wait;
    end process;  
end test_bench;