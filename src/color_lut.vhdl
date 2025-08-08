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
        (red => x"00", green => x"00", blue => x"AA"),  -- BLUE
        (red => x"00", green => x"AA", blue => x"00"),  -- GREEN
        (red => x"00", green => x"AA", blue => x"AA"),  -- CYAN
        (red => x"AA", green => x"00", blue => x"00"),  -- RED
        (red => x"AA", green => x"00", blue => x"AA"),  -- MAGENTA
        (red => x"AA", green => x"AA", blue => x"00"),  -- DARK YELLOW
        (red => x"AA", green => x"AA", blue => x"AA"),  -- LIGHT GRAY
        (red => x"55", green => x"55", blue => x"55"),  -- DARK GRAY
        (red => x"55", green => x"55", blue => x"FF"),  -- LIGHT BLUE  
        (red => x"85", green => x"FF", blue => x"85"),  -- LIGHT GREEN
        (red => x"85", green => x"FF", blue => x"FF"),  -- LIGHT CYAN
        (red => x"FF", green => x"55", blue => x"55"),  -- LIGHT RED
        (red => x"FF", green => x"55", blue => x"FF"),  -- LIGHT MAGENTA
        (red => x"FF", green => x"FF", blue => x"55"),  -- YELLOW
        (red => x"FF", green => x"FF", blue => x"FF")   -- WHITE
    );

begin

    red_channel     <= color_lookup_table(to_integer(unsigned(in_color))).red;
    green_channel   <= color_lookup_table(to_integer(unsigned(in_color))).green;
    blue_channel    <= color_lookup_table(to_integer(unsigned(in_color))).blue;

end architecture;