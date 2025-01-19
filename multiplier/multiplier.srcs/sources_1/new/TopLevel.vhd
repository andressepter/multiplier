library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Use only numeric_std for unsigned

entity TopLevel is
    port (
        SW : in STD_LOGIC_VECTOR(15 downto 0);
        AN : out STD_LOGIC_VECTOR(7 downto 0);
        CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC;
        CLK : in STD_LOGIC
    );
end TopLevel;

architecture Behavioral of TopLevel is
    signal A, B : STD_LOGIC_VECTOR(7 downto 0);
    signal Product : STD_LOGIC_VECTOR(15 downto 0);
    signal hex_digit : STD_LOGIC_VECTOR(3 downto 0);
    signal refresh_counter : integer := 0;
    signal display_select : unsigned (2 downto 0) := "000";
    constant DELAY : integer := 20000000; -- 0.2 seconds @ 100 MHz
begin
    A <= SW(7 downto 0);
    B <= SW(15 downto 8);

    -- Instantiate the multiplier
    multiplier: entity work.Multiplier
        generic map (data_width => 8)
        port map (
            A => A,
            B => B,
            Product => Product
        );

    -- Refresh counter to create a delay
    process(CLK)
    begin
        if rising_edge(CLK) then
            if refresh_counter = DELAY then
                refresh_counter <= 0;
                display_select <= display_select + 1;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;

    -- Multiplexer to select which display is active
    process(display_select)
    begin
        case display_select is
            when "000" =>
                AN <= "11111110"; -- AN0 active
                hex_digit <= Product(3 downto 0);
            when "001" =>
                AN <= "11111101"; -- AN1 active
                hex_digit <= Product(7 downto 4);
            when "010" =>
                AN <= "11111011"; -- AN2 active
                hex_digit <= Product(11 downto 8);
            when "011" =>
                AN <= "11110111"; -- AN3 active
                hex_digit <= Product(15 downto 12);
            when "100" =>
                AN <= "11101111"; -- AN4 active
                hex_digit <= "0000"; -- Placeholder for other displays
            when "101" =>
                AN <= "11011111"; -- AN5 active
                hex_digit <= "0000"; -- Placeholder for other displays
            when "110" =>
                AN <= "10111111"; -- AN6 active
                hex_digit <= "0000"; -- Placeholder for other displays
            when "111" =>
                AN <= "01111111"; -- AN7 active
                hex_digit <= "0000"; -- Placeholder for other displays
            when others =>
                AN <= "11111111"; -- All displays off
        end case;
    end process;

    -- Decode the hex_digit to the seven-segment display
    process(hex_digit)
    begin
        case hex_digit is
            when "0000" => -- 0
                CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '1';
            when "0001" => -- 1
                CA <= '1'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1';
            when "0010" => -- 2
                CA <= '0'; CB <= '0'; CC <= '1'; CD <= '0'; CE <= '0'; CF <= '1'; CG <= '0';
            when "0011" => -- 3
                CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '1'; CG <= '0';
            when "0100" => -- 4
                CA <= '1'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '0'; CG <= '0';
            when "0101" => -- 5
                CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0';
            when "0110" => -- 6
                CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0';
            when "0111" => -- 7
                CA <= '0'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1';
            when "1000" => -- 8
                CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0';
            when "1001" => -- 9
                CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0';
            when "1010" => -- A
                CA <= '0'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '0'; CF <= '0'; CG <= '0';
            when "1011" => -- B
                CA <= '1'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0';
            when "1100" => -- C
                CA <= '0'; CB <= '1'; CC <= '1'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '1';
            when "1101" => -- D
                CA <= '1'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '1'; CG <= '0';
            when "1110" => -- E
                CA <= '0'; CB <= '1'; CC <= '1'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0';
            when "1111" => -- F
                CA <= '0'; CB <= '1'; CC <= '1'; CD <= '1'; CE <= '0'; CF <= '0'; CG <= '0';
            when others =>
                CA <= '1'; CB <= '1'; CC <= '1'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1';
        end case;
    end process;
end Behavioral;
