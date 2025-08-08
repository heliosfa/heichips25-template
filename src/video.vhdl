-- TEROSHDL Documentation:
--! @title Swiss Flag Test Image Generator
--! @author Pascal G. (gfcwfzkm)
--! @version 1.1
--! @date 19.03.2024
--! @brief Generates a test image with the Swiss flag and color strips for video output.
--!
--! Developed for the BFH oscilloscope project.
--!
--! This module generates a test image for video output, which includes the Swiss flag
--! and color strips at the top and bottom of the screen. While the video timing generator
--! generates a video resolution of 1920x1080p, only half that resolution is actually used
--! by the test image generator, resulting in an actual resolution of 960x540p, with a 
--! Swiss flag in the center of the size 320x320, and a color bar at the top and bottom
--!
--! Only the MSB of the RGB color signals are used, as this is a 3-bit color output.
--!
--! Proportions of the swiss flag are from wikimedia:
--! https://commons.wikimedia.org/wiki/File:Swiss_Flag_Specifications.svg
--! ![Swiss Flag Proportions](https://upload.wikimedia.org/wikipedia/commons/6/61/Swiss_Flag_Specifications.svg)
--!

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity video is
    port (
        --! Pixel Clock
        clk     : in  std_logic;
        --! Synchronous Reset signal (active-high)
        reset   : in  std_logic;

        animation_select : in std_logic;

        --! RGB Color Output
        r,g,b   : out std_logic_vector(7 downto 0);
        --! Horizontal Sync signal (active-high)
        hsync   : out std_logic;
        --! Vertical Sync signal (active-high)
        vsync   : out std_logic;
        --! Data Enable signal (active-high)
        de      : out std_logic
    );
end entity video;

architecture rtl of video is

    --! X coordinates of the currently drawn pixel
    signal video_x : unsigned(9 downto 0);
    --! Y coordinates of the currently drawn pixel
    signal video_y : unsigned(9 downto 0);
    --! Active signal to indicate if the current pixel is being drawn
    signal draw_active : std_logic;
    signal line_end_reached : std_logic;
    signal frame_end_reached : std_logic;

    --! Video Color Output Registers
    signal r_next, r_reg, g_next, g_reg, b_next, b_reg : std_logic_vector(7 downto 0);
    --! Video Control / Timing Output Registers
    signal de_next, de_reg, hsync_next, hsync_reg, vsync_next, vsync_reg : std_logic;

    --! Shader color output
    signal shader_red, shader_green, shader_blue : std_logic_vector(7 downto 0);

    --! Color from the LUT
    signal lut_red, lut_green, lut_blue : std_logic_vector(7 downto 0);

begin
    -- Register to output assignments
    r <= r_reg;
    g <= g_reg;
    b <= b_reg;
    de <= de_reg;
    hsync <= hsync_reg;
    vsync <= vsync_reg;

    --! Register Process
    REGBANK : process (reset, clk) begin
        if rising_edge(clk) then
            if reset = '1' then
                r_reg <= (others => '0');
                g_reg <= (others => '0');
                b_reg <= (others => '0');
                de_reg <= '0';
                hsync_reg <= '0';
                vsync_reg <= '0';
            else
                r_reg <= r_next;
                g_reg <= g_next;
                b_reg <= b_next;
                de_reg <= de_next;
                hsync_reg <= hsync_next;
                vsync_reg <= vsync_next;
            end if;
        end if;
    end process;

    --! Next-State-Logic, generating the swiss flag
    CHFLAG : process (video_x, video_y, draw_active, animation_select)
        variable tmp_y : unsigned(9 downto 0);
    begin
        r_next <= (others => '0');
        g_next <= (others => '0');
        b_next <= (others => '0');
        
        -- Only assign stuff when we're even active, right?
        if (draw_active = '1') then
            if animation_select = '1' then
                r_next <= shader_red;
                g_next <= shader_green;
                b_next <= shader_blue;
            else
                r_next <= lut_red;
                g_next <= lut_green;
                b_next <= lut_blue;
            end if;
        end if;
    end process CHFLAG;

    --! Video Timing Generator, configured for 1920x1080p@30Hz
    VIDEO_TIMING_GENERATOR : entity work.vtgen
        generic map (
            H_VISIBLE => 640,  --! Horizontal resolution
            H_FPORCH  => 16,   --! Horizontal Front Porch
            H_SYNC    => 96,   --! Horizontal Sync Pulse
            H_BPORCH  => 48,   --! Horizontal Back Porch
            V_VISIBLE => 480,  --! Vertical resolution
            V_FPORCH  => 19,   --! Vertical Front Porch
            V_SYNC    => 2,    --! Vertical Sync Pulse
            V_BPORCH  => 33    --! Vertical Back Porch,
        )
        port map (
            clk         => clk,
            reset       => reset,
            disp_active => draw_active,
            disp_x      => video_x,
            disp_y      => video_y,
            frame_end   => frame_end_reached,
            line_end    => line_end_reached,
            hdmi_vsync  => vsync_next,
            hdmi_hsync  => hsync_next,
            hdmi_de     => de_next
    );

    FANCY_SHADER : entity work.shader
        port map (
            clk         => clk,
            reset       => reset,
            video_x     => video_x,
            video_y     => video_y,
            disp_active => draw_active,
            frame_end   => frame_end_reached,
            line_end    => line_end_reached,
            r           => shader_red,
            g           => shader_green,
            b           => shader_blue
    );

    TEST_LUT_THINGY : entity work.gol_test
        port map (
            clk => clk,
            reset => reset,
            line_end => line_end_reached,
            r => lut_red,
            g => lut_green,
            b => lut_blue
    );

end architecture;