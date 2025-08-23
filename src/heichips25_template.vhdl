library ieee;
use ieee.std_logic_1164.all;

entity heichips25_template is
    port (
        ui_in       : in  std_logic_vector(7 downto 0);
        uo_out      : out std_logic_vector(7 downto 0);
        uio_in      : in  std_logic_vector(7 downto 0);
        uio_out     : out std_logic_vector(7 downto 0);
        uio_oe      : out std_logic_vector(7 downto 0);
        ena         : in  std_logic;

        --! 126 MHz clock
        clk         : in  std_logic;
        --! Active-Low Reset
        rst_n       : in  std_logic;

        --! TMDS Blue (TMDS channel 0)
        tmds_b      : out std_logic;
        --! TMDS Green (TMDS channel 1)
        tmds_g      : out std_logic;
        --! TMDS Red (TMDS channel 2)
        tmds_r      : out std_logic;
        --! TMDS Clock (TMDS channel 3)
        tmds_clk    : out std_logic
    );
end entity heichips25_template;

architecture rtl of heichips25_template is

    signal reset        : std_logic;
    signal clk_video    : std_logic;

    signal display_enable : std_logic;
    signal hsync, vsync : std_logic;

    signal red, green, blue : std_logic_vector(7 downto 0);
    signal red_tmds_par, green_tmds_par, blue_tmds_par : std_logic_vector(9 downto 0);

begin

    -- Active-high resets
    reset <= not rst_n;

    -- Get rid of unassigned stuff warnings
    --uo_out(7 downto 4) <= (others => '0');
    uio_out(7 downto 5) <= (others => '0');
    uio_oe <= (others => '0');

    --! By 5 Clock Divider
    clock_5_div_inst : entity work.clock_5_div(rtl)
    port map (
        clk => clk,
        reset => reset,
        clkdiv => clk_video
    );

    --! Video Image Generator
    VIDEOGEN : entity work.video(rtl)
        port map (
            clk   => clk_video,
            reset => reset,
            animation_select => ui_in(1 downto 0),
            r     => red,
            g     => green,
            b     => blue,
            hsync => hsync,
            vsync => vsync,
            de    => display_enable,
            pixel_in => ui_in(7 downto 4),
            addr(8) => uio_out(0),
            addr(7 downto 0) =>uo_out,
            pix_sel => uio_out(4 downto 2),
            bank => uio_out(1)
    );

    --! Encode the video red channel to a TMDS signal
    TMDS_RED : entity work.tmds_encoder
        port map (
            clk  => clk_video,
            reset => reset,
            disp_enable => display_enable,
            hsync => '0',
            vsync => '0',
            color_data  => red,
            tmds_encoded => red_tmds_par
    );
    --! Encode the video green channel to a TMDS signal
    TMDS_GREEN : entity work.tmds_encoder
        port map (
            clk  => clk_video,
            reset => reset,
            disp_enable   => display_enable,
            hsync => '0',
            vsync => '0',
            color_data  => green,
            tmds_encoded => green_tmds_par
    );
    --! Encode the video blue channel, H/VSYNC and ENABLE signals to a TMDS signal
    TMDS_BLUE : entity work.tmds_encoder
        port map (
            clk  => clk_video,
            reset => reset,
            disp_enable   => display_enable,
            hsync => hsync,
            vsync => vsync,
            color_data  => blue,
            tmds_encoded => blue_tmds_par
    );

    -------------- Serialize the 10 bit raw/parallel TMDS signals --------------
    --! Serializer for the red TMDS channel
    SERIALIZE : entity work.TMDS_serializer
        port map (
            serclk => clk,
            rst => reset,
            TMDS_parallel_r => red_tmds_par,
            TMDS_parallel_g => green_tmds_par,
            TMDS_parallel_b => blue_tmds_par,
            TMDS_serial_r => tmds_r,
            TMDS_serial_g => tmds_g,
            TMDS_serial_b => tmds_b,
            TMDS_serial_c => tmds_clk
    );

end architecture;
