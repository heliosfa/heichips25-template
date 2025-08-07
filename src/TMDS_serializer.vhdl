-- TEROSHDL Documentation:
--! @title TMDS Serializer
--! @author Hossam Omar, Pascal G.
--! @version 1.0
--! @date 07.08.2025
--! @brief Serializes the TMDS encoded data for HDMI output.
--!
--! This module serializes the TMDS data and a pixel clock, ready to be passed
--! over to the LVDS output driver.
--!
--! To reduce the overall clock needs, only a 5x clock is required - the way 
--! this module achives double-data-rate is by abusing a multiplexer with the
--! TMDS clock! It works on the Gowin Tang Nano 9k!
--! 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TMDS_serializer is
    Port (
        serclk          : in  std_logic;
        rst             : in  std_logic;
        TMDS_parallel_r : in  std_logic_vector(9 downto 0);
        TMDS_parallel_g : in  std_logic_vector(9 downto 0);
        TMDS_parallel_b : in  std_logic_vector(9 downto 0);
        TMDS_serial_r   : out std_logic;
        TMDS_serial_g   : out std_logic;
        TMDS_serial_b   : out std_logic;
        TMDS_serial_c   : out std_logic
    );
end TMDS_serializer;

architecture Behavioral of TMDS_serializer is

    signal shift_reg_r : std_logic_vector(9 downto 0) := (others => '0');
    signal shift_reg_g : std_logic_vector(9 downto 0) := (others => '0');
    signal shift_reg_b : std_logic_vector(9 downto 0) := (others => '0');
    signal shift_reg_c : std_logic_vector(9 downto 0) := (others => '0');
    signal bit_cnt   : integer range 0 to 4 := 4; -- Force first load!

begin

    process(serclk, rst)
    begin
        if rst = '1' then
            shift_reg_r <= (others => '0');
            shift_reg_g <= (others => '0');
            shift_reg_b <= (others => '0');
            shift_reg_c <= (others => '0');
            bit_cnt     <= 4;
        elsif rising_edge(serclk) then
            if bit_cnt = 4 then
                shift_reg_r <= TMDS_parallel_r;
                shift_reg_g <= TMDS_parallel_g;
                shift_reg_b <= TMDS_parallel_b;
                shift_reg_c <= "1111100000";
                bit_cnt   <= 0;
            else
                shift_reg_r <= "00" & shift_reg_r(9 downto 2);
                shift_reg_g <= "00" & shift_reg_g(9 downto 2);
                shift_reg_b <= "00" & shift_reg_b(9 downto 2);
                shift_reg_c <= "00" & shift_reg_c(9 downto 2);
                bit_cnt   <= bit_cnt + 1;
            end if;
        end if;
    end process;

    TMDS_serial_r <= shift_reg_r(0) when serclk = '1' else shift_reg_r(1);
    TMDS_serial_g <= shift_reg_g(0) when serclk = '1' else shift_reg_g(1);
    TMDS_serial_b <= shift_reg_b(0) when serclk = '1' else shift_reg_b(1);
    TMDS_serial_c <= shift_reg_c(0) when serclk = '1' else shift_reg_c(1);

end Behavioral;
