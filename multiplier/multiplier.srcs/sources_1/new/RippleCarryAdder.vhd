library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RippleCarryAdder is
    generic (
        data_width : integer := 4
    );
    port (
        A : in STD_LOGIC_VECTOR(data_width-1 downto 0);
        B : in STD_LOGIC_VECTOR(data_width-1 downto 0);
        Cin : in STD_LOGIC;
        Sum : out STD_LOGIC_VECTOR(data_width-1 downto 0);
        Cout : out STD_LOGIC
    );
end RippleCarryAdder;

architecture Behavioral of RippleCarryAdder is
    signal carry : STD_LOGIC_VECTOR(data_width downto 0);
begin
    carry(0) <= Cin;

    gen_adder: for i in 0 to data_width-1 generate
        process(A, B, carry)
        begin
            Sum(i) <= A(i) xor B(i) xor carry(i);
            carry(i+1) <= (A(i) and B(i)) or (A(i) and carry(i)) or (B(i) and carry(i));
        end process;
    end generate;

    Cout <= carry(data_width);
end Behavioral;