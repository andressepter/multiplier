
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplier is
    generic (
        data_width : integer := 4
    );
    port (
        A : in STD_LOGIC_VECTOR(data_width-1 downto 0);
        B : in STD_LOGIC_VECTOR(data_width-1 downto 0);
        Product : out STD_LOGIC_VECTOR(2*data_width-1 downto 0)
    );
end Multiplier;

architecture Behavioral of Multiplier is
    type partial_product_array is array (0 to data_width-1) of STD_LOGIC_VECTOR(2*data_width-1 downto 0);
    signal partial_products : partial_product_array;
    signal sum : STD_LOGIC_VECTOR(2*data_width-1 downto 0);
    signal carry : STD_LOGIC;
begin
    -- Generate partial products
    gen_partial_products: for i in 0 to data_width-1 generate
        process(A, B)
        begin
            partial_products(i) <= (others => '0');
            for j in 0 to data_width-1 loop
                partial_products(i)(i+j) <= A(j) and B(i);
            end loop;
        end process;
    end generate;

    -- Sum the partial products using ripple-carry adders
    sum <= partial_products(0);
    gen_adders: for i in 1 to data_width-1 generate
        signal temp_sum : STD_LOGIC_VECTOR(2*data_width-1 downto 0);
        signal temp_carry : STD_LOGIC;
        begin
            adder: entity work.RippleCarryAdder
                generic map (data_width => 2*data_width)
                port map (
                    A => sum,
                    B => partial_products(i),
                    Cin => '0',
                    Sum => temp_sum,
                    Cout => temp_carry
                );
            sum <= temp_sum;
        end generate;

    Product <= sum;
end Behavioral;
