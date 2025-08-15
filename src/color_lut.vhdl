library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity color_lut is
    port (
        in_color        : in  std_logic_vector(3 downto 0);
        red_channel     : out std_logic_vector(7 downto 0);
        green_channel   : out std_logic_vector(7 downto 0);
        blue_channel    : out std_logic_vector(7 downto 0)
    );
end entity color_lut;

architecture rtl of color_lut is

    type color_RGB_record is record
        red     : std_logic_vector(7 downto 0);
        green   : std_logic_vector(7 downto 0);
        blue    : std_logic_vector(7 downto 0);
    end record;

    type color_lut_t is array (natural range <>) of color_RGB_record;

    constant color_lookup_table : color_lut_t := (
        (red => x"00", green => x"00", blue => x"00"),  -- BLACK
        (red => x"FF", green => x"00", blue => x"00"),  -- Red
        (red => x"FF", green => x"80", blue => x"00"),  -- Orange
        (red => x"FF", green => x"BF", blue => x"00"),  -- Yellow-Orange
        (red => x"FF", green => x"FF", blue => x"00"),  -- Yellow
        (red => x"BF", green => x"FF", blue => x"00"),  -- Yellow-Green
        (red => x"80", green => x"FF", blue => x"00"),  -- Green-Yellow
        (red => x"40", green => x"FF", blue => x"00"),  -- Yellowish Green
        (red => x"00", green => x"FF", blue => x"00"),  -- Green
        (red => x"00", green => x"FF", blue => x"80"),  -- Green-Cyan
        (red => x"00", green => x"FF", blue => x"BF"),  -- Cyan-Green
        (red => x"00", green => x"FF", blue => x"FF"),  -- Cyan
        (red => x"00", green => x"80", blue => x"FF"),  -- Blue-Cyan
        (red => x"00", green => x"00", blue => x"FF"),  -- Blue
        (red => x"4B", green => x"00", blue => x"82"),  -- Indigo
        (red => x"8F", green => x"00", blue => x"FF")   -- Violet
    );

begin

    red_channel     <= color_lookup_table(to_integer(unsigned(in_color))).red;
    green_channel   <= color_lookup_table(to_integer(unsigned(in_color))).green;
    blue_channel    <= color_lookup_table(to_integer(unsigned(in_color))).blue;

end architecture;