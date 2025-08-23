library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_5_div is
    port (
        clk     : in std_logic;
        reset   : in std_logic;

        clkdiv  : out std_logic       
    );
end entity clock_5_div;

architecture rtl of clock_5_div is

    signal partitial_clock_a, partitial_clock_b : std_logic;
    signal counter_a_reg, counter_b_reg : unsigned(3 downto 0);

begin

    --! Clock Divider on the rising edge, going high for two cycles, followed by a low of three cycles
    CLKDIV_A : process (clk, reset)
    begin
        if reset = '1' then
            -- Reset things to a clean state
            partitial_clock_a <= '0';
            counter_a_reg <= (others => '0');
        elsif rising_edge(clk) then
            -- Increment counter
            counter_a_reg <= counter_a_reg + 1;

            if counter_a_reg = 5 then
                -- Reached 5 cycles? Reset things to one
                counter_a_reg <= to_unsigned(1, counter_a_reg'length);
                partitial_clock_a <= '1';
            elsif counter_a_reg >= 2 then
                -- more than 2 cycles? clear the output
                partitial_clock_a <= '0';
            else
                partitial_clock_a <= '1';
            end if;
        end if;
    end process CLKDIV_A;

    --! Clock Divider on the falling edge, going high for two cycles, followed by a low of three cycles
    CLKDIV_B : process (clk, reset)
    begin
        if reset = '1' then
            -- Reset things to a clean state
            partitial_clock_b <= '0';
            counter_b_reg <= (others => '0');
        elsif falling_edge(clk) then
            -- Increment counter
            counter_b_reg <= counter_b_reg + 1;

            if counter_b_reg = 5 then
                -- Reached 5 cycles? Reset things to one
                counter_b_reg <= to_unsigned(1, counter_b_reg'length);
                partitial_clock_b <= '1';
            elsif counter_b_reg >= 2 then
                -- more than 2 cycles? clear the output
                partitial_clock_b <= '0';
            else
                partitial_clock_b <= '1';
            end if;
        end if;
    end process CLKDIV_B;

    -- Just OR the two outputs together! Should give us a nice 50% duty cycle, clk div of 5.
    clkdiv <= partitial_clock_a or partitial_clock_b;

end architecture;