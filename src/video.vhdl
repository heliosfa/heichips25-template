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
    --! Constants for the color strip test
    constant testbar : positive := 80;
    
    --! Horizontal resolution
    constant GRADIENT_SCALE : positive := 12;    -- Gradient scaling factor
    
    --! X coordinates of the currently drawn pixel
    signal draw_x : unsigned(9 downto 0);
    --! Y coordinates of the currently drawn pixel
    signal draw_y : unsigned(9 downto 0);
    --! Active signal to indicate if the current pixel is being drawn
    signal draw_active : std_logic;

    signal video_x : unsigned(9 downto 0);
    signal video_y : unsigned(9 downto 0);

    signal box_x_reg, box_x_next : unsigned(9 downto 0) := (others => '0');

    signal increment_counter : std_logic := '0';

    --! Video Color Output Registers
    signal r_next, r_reg, g_next, g_reg, b_next, b_reg : std_logic_vector(7 downto 0);
    --! Video Control / Timing Output Registers
    signal de_next, de_reg, hsync_next, hsync_reg, vsync_next, vsync_reg : std_logic;
begin
    -- Register to output assignments
    r <= r_reg;
    g <= g_reg;
    b <= b_reg;
    de <= de_reg;
    hsync <= hsync_reg;
    vsync <= vsync_reg;

    draw_x <= video_x(9 downto 0);
    draw_y <= video_y(9 downto 0);

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
                box_x_reg <= (others => '0');
            else
                r_reg <= r_next;
                g_reg <= g_next;
                b_reg <= b_next;
                de_reg <= de_next;
                hsync_reg <= hsync_next;
                vsync_reg <= vsync_next;
                box_x_reg <= box_x_next;
            end if;
        end if;
    end process;

    --! Next-State-Logic, generating the swiss flag
    CHFLAG : process (draw_x, draw_y, draw_active, box_x_reg, increment_counter)
        variable tmp_y : unsigned(9 downto 0);
    begin
        r_next <= (others => '0');
        g_next <= (others => '0');
        b_next <= (others => '0');
        box_x_next <= box_x_reg;

        if (increment_counter = '1') then
            box_x_next <= box_x_reg + 1;
        end if;
        
        if (draw_active = '1') then
            -- if unsigned(std_logic_vector(unsigned((draw_y + box_x_reg) xor (draw_x + box_x_reg)) mod 7) or 
            --    std_logic_vector(unsigned((draw_y + box_x_reg) xor (draw_x + box_x_reg)) mod 9))>1 then 
            --     r_next <= '1';
            --     g_next <= '1';
            -- else
            --     g_next <= '0';
            --     r_next <= '1';
            -- end if;
            -- if unsigned(std_logic_vector(unsigned((draw_y + box_x_reg + 1) xor (draw_x + box_x_reg + 1)) mod 7) or std_logic_vector(unsigned((draw_y +box_x_reg+1) xor (draw_x+box_x_reg+1)) mod 9))>1 then 
            --     b_next <= '0';
            -- else
            --     b_next <= '1';
            -- end if;       


            tmp_y  := draw_y; --! + sin( draw_x);

            r_next := (((draw_x + box_x_reg) xor tmp_y)  mod 7) + (draw_x * GRADIENT_SCALE);
            g_next := (((draw_x+1 + box_x_reg) xor tmp_y)  mod 7) + (draw_x * GRADIENT_SCALE);
            b_next := (((draw_x-2 + box_x_reg) xor tmp_y)  mod 7) + (draw_x * GRADIENT_SCALE);

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
            frame_end   => increment_counter,
            hdmi_vsync  => vsync_next,
            hdmi_hsync  => hsync_next,
            hdmi_de     => de_next
    );

end architecture;