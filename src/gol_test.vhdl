library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gol_test is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        line_end : in std_logic;
        frame_end : in std_logic;
        display_enable : in std_logic;

        r,g,b : out std_logic_vector(7 downto 0);

        pixel_in : in std_logic_vector(3 downto 0);
        addr : out std_logic_vector(8 downto 0);
        pix_sel : out std_logic_vector(2 downto 0);
        bank : out std_logic
    );
end entity gol_test;

architecture rtl of gol_test is

    signal gol_counter_reg : unsigned(3 downto 0);
    signal col_to_lut : std_logic_vector(3 downto 0);

begin

    process (clk)
    begin
        if rising_edge(clk) then
            gol_counter_reg <= gol_counter_reg;
            if reset = '1' then
                gol_counter_reg <= (others => '0');
            else
                gol_counter_reg <= gol_counter_reg + 1;
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

    pix_Streacher_inst : entity work.pix_Streacher
        port map (
            clk_25MHz => clk,
            rst => reset,
            line_end => line_end,
            frame_end => frame_end,
            DE_enable => display_enable,
            data_in => std_logic_vector(gol_counter_reg),
            data_out => col_to_lut
    );

    pixel_feeder_inst : entity work.pixel_feeder
        port map (
            clk_25 => clk,
            rst_n => not reset,
            line_end => line_end,
            frame_end => frame_end,
            disp_active => display_enable,
            pixel_out => std_logic_vector(col_to_lut),
            pixel_in => pixel_in,
            addr => addr,
            pix_sel => pix_sel,
            bank => bank

    );

end architecture;