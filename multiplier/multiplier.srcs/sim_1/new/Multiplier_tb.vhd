
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplier_tb is
end Multiplier_tb;

architecture Behavioral of Multiplier_tb is
    -- Constants
    constant data_width : integer := 8;

    -- Signals
    signal A, B : STD_LOGIC_VECTOR(data_width-1 downto 0);
    signal Product : STD_LOGIC_VECTOR(2*data_width-1 downto 0);

begin
    -- Instantiate the Multiplier
    uut: entity work.Multiplier
        generic map (data_width => data_width)
        port map (
            A => A,
            B => B,
            Product => Product
        );

    -- Test process
    process
    begin
        -- Test case 1
        A <= "00000001"; -- 1
        B <= "00000001"; -- 1
        wait for 10 ns;
        assert (Product = "0000000000000001") report "Test case 1 failed" severity error;

        -- Test case 2
        A <= "00000010"; -- 2
        B <= "00000010"; -- 2
        wait for 10 ns;
        assert (Product = "0000000000000100") report "Test case 2 failed" severity error;

        -- Test case 3
        A <= "00000100"; -- 4
        B <= "00000011"; -- 3
        wait for 10 ns;
        assert (Product = "0000000000001100") report "Test case 3 failed" severity error;

        -- Test case 4
        A <= "00001111"; -- 15
        B <= "00000010"; -- 2
        wait for 10 ns;
        assert (Product = "0000000000011110") report "Test case 4 failed" severity error;

        -- Test case 5
        A <= "11111111"; -- 255
        B <= "00000001"; -- 1
        wait for 10 ns;
        assert (Product = "0000000011111111") report "Test case 5 failed" severity error;

        -- Test case 6
        A <= "11111111"; -- 255
        B <= "11111111"; -- 255
        wait for 10 ns;
        assert (Product = "1111111000000001") report "Test case 6 failed" severity error;

        -- End simulation
        wait;
    end process;
end Behavioral;
