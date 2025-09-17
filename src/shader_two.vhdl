
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shader_two is
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
end entity shader_two;

architecture rtl of shader_two is
    signal time_cnt : unsigned(7 downto 0) := (others => '0');  -- 8-bit time
begin

    -- Time counter increments once per frame
    process(clk, reset)
    begin
        if reset = '1' then
            time_cnt <= (others => '0');
        elsif rising_edge(clk) then
            if frame_end = '1' then
                time_cnt <= time_cnt + 1;
            end if;
        end if;
    end process;

    process(all)
        -- working signals, carefully sized
        variable tmp_x : unsigned(10 downto 0);
        variable h_x   : unsigned(9 downto 0);
        variable h_y   : unsigned(9 downto 0);
        variable q_x   : unsigned(8 downto 0);
        variable q_y   : unsigned(8 downto 0);

        variable rv, gv, bv : unsigned(7 downto 0);
        variable rv9, hv9, qv9 : unsigned(3 downto 0); -- mod 9 fits in 4 bits
    begin
        if disp_active = '1' then
            -- tmp_x = x + time
            tmp_x := resize(video_x, tmp_x'length) + resize(time_cnt, tmp_x'length);

            -- divisions by power of two = shifts
            h_x := tmp_x(tmp_x'high downto 1);              -- /2
            h_y := video_y(video_y'high downto 1);          -- /2
            q_x := tmp_x(tmp_x'high downto 2);              -- /4
            q_y := video_y(video_y'high downto 2);          -- /4

            -- XORs
            rv9 := std_logic_vector(resize(tmp_x xor resize(video_y, tmp_x'length), 4)) mod 9;
            hv9 := std_logic_vector(resize(h_x xor h_y, 4)) mod 9;
            qv9 := std_logic_vector(resize(q_x xor q_y, 4)) mod 9;

            -- AND chain, then shift left by 5 (= multiply by 32)
            rv := std_logic_vector(to_unsigned(
                (to_integer(rv9) and to_integer(hv9) and to_integer(qv9)) * 32, 8));

            -- g = (y + time) mod 8
            gv := std_logic_vector(to_unsigned(
                (to_integer(video_y) + to_integer(time_cnt)) mod 8, 8));

            bv := gv;

            -- if(r > 40 && r < 70) b = time
            if (to_integer(rv) > 40) and (to_integer(rv) < 70) then
                bv := time_cnt;
            end if;

            -- if(r == 0) b = 30
            if rv = x"00" then
                bv := to_unsigned(30, 8);
            end if;

            -- final clamp mod 256 (implicit since 8 bits)
            r <= std_logic_vector(rv);
            g <= std_logic_vector(gv);
            b <= std_logic_vector(bv);
        else
            r <= (others => '0');
            g <= (others => '0');
            b <= (others => '0');
        end if;
    end process;

end architecture rtl;
