library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shader is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        
        video_x     : in  unsigned(9 downto 0);
        video_y     : in  unsigned(9 downto 0);

        disp_active : in  std_logic;
        frame_end   : in  std_logic;
        line_end    : in  std_logic;

        r,g,b       : out std_logic_vector(7 downto 0)
    );
end entity shader;

architecture rtl of shader is

    constant GRADIENT_SCALE : positive := 3;    -- Gradient scaling factor

    signal shader_counter_reg, shader_counter_next : unsigned(9 downto 0);

    signal temp_r, temp_g, temp_b : unsigned(9 downto 0);

begin

    r <= std_logic_vector(temp_r(9 downto 2));
    b <= std_logic_vector(temp_b(7 downto 0));
    g <= std_logic_vector(temp_g(7 downto 0));

    CLKREG : process (clk, reset) begin
        if rising_edge(clk) then
            shader_counter_reg <= shader_counter_next;            
            if reset = '1' then
                shader_counter_reg <= (others => '0');
            end if;
        end if;
    end process CLKREG;

    COMBLOGIC : process (video_x, video_y, frame_end, line_end, shader_counter_reg) begin

        -- We don't want accidental latches
        temp_r <= (others => '0');
        temp_g <= (others => '0');
        temp_b <= (others => '0');
        shader_counter_next <= shader_counter_reg;

        -- Increment shader counter if we reached the end of the video frame
        if frame_end = '1' then
            shader_counter_next <= shader_counter_reg + 1;
        end if;

        -- Shader magic
        --if unsigned(std_logic_vector(unsigned((video_y + shader_counter_reg) xor (video_x + shader_counter_reg)) mod 7) or 
        --   std_logic_vector(unsigned((video_y + shader_counter_reg) xor (video_x + shader_counter_reg)) mod 9))>1 then 
        --    r <= (others => '1');
        --    g <= (others => '1');
        --else
        --    g <= (others => '0');
        --    r <= (others => '1');
        --end if;
        --if unsigned(std_logic_vector(unsigned((video_y + shader_counter_reg + 1) xor (video_x + shader_counter_reg + 1)) mod 7) or 
        --   std_logic_vector(unsigned((video_y +shader_counter_reg+1) xor (video_x+shader_counter_reg+1)) mod 9))>1 then 
        --    b <= (others => '0');
        --else
        --    b <= (others => '1');
        --end if; 

        temp_r <= (((video_x + shader_counter_reg) xor video_y)  mod 7) + (video_x / GRADIENT_SCALE);
        temp_g <= (((video_x+5 + shader_counter_reg) xor video_y)  mod 7) + (video_x / GRADIENT_SCALE);
        temp_b <= (((video_x-8 + shader_counter_reg) xor video_y)  mod 7) + (video_x / GRADIENT_SCALE);

    end process COMBLOGIC;

end architecture;