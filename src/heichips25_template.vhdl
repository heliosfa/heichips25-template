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
        rst_n       : in  std_logic

        --! TMDS Blue (TMDS channel 0)
        --tmds_0      : out std_logic;
        --! TMDS Green (TMDS channel 1)
        --tmds_1      : out std_logic;
        --! TMDS Red (TMDS channel 2)
        --tmds_2      : out std_logic;
        --! TMDS Clock (TMDS channel 3)
        --tmds_clk    : out std_logic
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
    uo_out(7 downto 4) <= (others => '0');
    uio_out <= (others => '0');
    uio_oe <= (others => '0');


    uo_out(3) <= clk_video;

    -- Repurposed video test generator, only supports 3-bit colors, so only the MSB
    -- of the color signal vectors is set
    --! Video Test Image Generator
    VIDEOGEN : entity work.video
        port map (
            clk   => clk_video,
            reset => reset,
            r     => red(7),
            g     => green(7),
            b     => blue(7),
            hsync => hsync,
            vsync => vsync,
            de    => display_enable
    );

    -- Set the remaining bits of the color signal vectors to zero
    red(6 downto 0)   <= (others => red(7));
    green(6 downto 0) <= (others => green(7));
    blue(6 downto 0)  <= (others => blue(7));

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
            TMDS_serial_r => uo_out(2),--tmds_2,
            TMDS_serial_g => uo_out(1),--tmds_1,
            TMDS_serial_b => uo_out(0),--tmds_0,
            TMDS_serial_c => clk_video--tmds_clk
    );

end architecture;
