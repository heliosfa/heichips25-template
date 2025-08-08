library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gol_test is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        line_end : in std_logic;

        r,g,b : out std_logic_vector(7 downto 0)
    );
end entity gol_test;

architecture rtl of gol_test is

    signal gol_counter_reg : unsigned(3 downto 0);

begin

    process (clk)
    begin
        if rising_edge(clk) then
            gol_counter_reg <= gol_counter_reg;
            if reset = '1' then
                gol_counter_reg <= (others => '0');
            else
                if line_end = '1' then
                    gol_counter_reg <= gol_counter_reg + 1;
                end if;
            end if;
        end if;
    end process;
    
    color_lut_inst : entity work.color_lut
        port map (
            in_color        => std_logic_vector(gol_counter_reg),
            red_channel     => r,
            green_channel   => g,
            blue_channel    => b
    );

end architecture;