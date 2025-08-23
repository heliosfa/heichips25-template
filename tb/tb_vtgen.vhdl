-- Run: nvc -a ..\src\vtgen.vhdl tb_vtgen.vhdl -e tb_vtgen -r --wave
-- to dump a wave file.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vtgen is
end entity tb_vtgen;

architecture rtl of tb_vtgen is

    constant CLK_PERIOD : time := 40 ns;

    signal tb_clk : std_logic := '0';
    signal tb_rst : std_logic := '1';
    signal tb_display_active : std_logic;
    signal tb_disp_x : unsigned(9 downto 0);
    signal tb_disp_y : unsigned(9 downto 0);
    signal tb_frame_end : std_logic;
    signal tb_line_end : std_logic;
    signal tb_hdmi_vsync : std_logic;
    signal tb_hdmi_hsync : std_logic;
    signal tb_hdmi_de : std_logic;

    signal testbench_finished : boolean := false;

begin

    --! DUT
    vtgen_inst : entity work.vtgen(rtl)
        generic map (
            H_VISIBLE   => 640,
            H_FPORCH    => 16,
            H_SYNC      => 96,
            H_BPORCH    => 48,
            V_VISIBLE   => 480,
            V_FPORCH    => 10,
            V_SYNC      => 2,
            V_BPORCH    => 33
        )
        port map (
            clk         => tb_clk,
            reset       => tb_rst,
            disp_active => tb_display_active,
            disp_x      => tb_disp_x,
            disp_y      => tb_disp_y,
            frame_end   => tb_frame_end,
            line_end    => tb_line_end,
            hdmi_vsync  => tb_hdmi_vsync,
            hdmi_hsync  => tb_hdmi_hsync,
            hdmi_de     => tb_hdmi_de
    );

    tb_clk <= not tb_clk after CLK_PERIOD/2 when testbench_finished = false else '0';

    STIMULI : process begin
        
        wait for 100 ns;

        tb_rst <= '0';
        -- run it for a whole frame (I know, looks hacky)
        wait for 17 ms;

        report "The end" severity note;

        -- End the testbench
        testbench_finished <= true;
        wait;

    end process STIMuLI;

end architecture;
