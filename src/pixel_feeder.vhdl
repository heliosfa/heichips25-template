library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pixel_feeder is
    port (
        --! Pixelclock
        clk_25      : in  std_logic;
        --! Active-high reset
        reset       : in  std_logic;

        --! Output pixel. Feb from 64-pixel buffer
        pixel_out   : out std_logic_vector(3 downto 0);
        --! Input pixel, from memory
        pixel_in    : in  std_logic_vector(3 downto 0);

        -- Address pins
        --! Memory address word (32-bit) we want to read
        addr        : out std_logic_vector(8 downto 0);
        --! Pixel (4-bit) from memory word we want to read
        pix_sel     : out std_logic_vector(2 downto 0);

        --! Video signals for sync
        disp_active, line_end, frame_end : in std_logic;

        --! Indicates if we are actively using memory
        mem_read    : out std_logic;
        --! Indicates if we are in the row where we read memory
        mem_row     : out std_logic
    );
end entity pixel_feeder;

architecture rtl of pixel_feeder is

    subtype t_pixel is std_logic_vector(3 downto 0);
    --! Buffer type to hold an row of 64 4-bit color values
    type t_rows is array (0 to 63) of t_pixel;

    --! Pixel Fetcher State machine:
    -- If we are at v_counter 9, we want to read the pixel for the next row into the buffer when h_counter gets to 9
    -- We can get away with one state for reading memory as memory is running at 126 MHz while this is running at 25 MHz,
    -- So memory will be ready on the negative clock edge...
    type t_states is (
        S_IDLE,
        S_MEM_READ,
        S_BLANK,
        S_POST_IDLE
    );
    --! State machine
    signal state, next_state    : t_states;

    --! 64-pixel buffer to hold an entire row
    signal row                  : t_rows;
    --! Counter for tracking the /10 for horizontal pixels
    signal h_counter_reg        : unsigned(3 downto 0);
    --! Counter for tracking the /10 for vertical pixels
    signal v_counter_reg        : unsigned(3 downto 0);
    --! Local pixel counts
    signal h_pix_reg, v_pix_reg : unsigned(5 downto 0);

    signal intermediate_address : std_logic_vector(11 downto 0);

begin

    REGISTER_STATE : process (clk_25, reset)
    begin
        if reset = '1' then
            state <= S_BLANK;
        elsif rising_edge(clk_25) then
            state <= next_state;
        end if;
    end process REGISTER_STATE;

    REGISTER_ROW : process (clk_25)
    begin
        if falling_edge(clk_25) then
            if (h_pix_reg = 63 and v_counter_reg = 0) then
                row(63) <= pixel_in;
            else
                row(to_integer(h_pix_reg - 1)) <= pixel_in;
            end if;
        end if;
    end process REGISTER_ROW;

    REGISTER_HORIZONTAL : process (clk_25, reset)
    begin
        if (reset = '1') then
            h_counter_reg <= (others => '0');
            h_pix_reg <= (others => '0');
        elsif rising_edge(clk_25) then
            --! Only increment if the display is active
            if (disp_active = '1') then
                if (h_counter_reg < 9) then
                    h_counter_reg   <= h_counter_reg + 1;
                else
                    h_counter_reg   <= (others => '0');
                    h_pix_reg       <= h_pix_reg + 1;
                end if;
            end if;
        end if;    
    end process REGISTER_HORIZONTAL;

    REGISTER_VERTICAL : process(line_end, frame_end, reset)
    begin
        if (frame_end = '1') or (reset = '1') then
            v_counter_reg <= (others => '0');
            v_pix_reg <= (others => '0');
        elsif line_end'event and line_end = '1' then
            if state /= s_blank then
                if v_counter_reg < to_unsigned(9, v_counter_reg'length) then
                    v_counter_reg <= v_counter_reg + 1;
                else
                    v_counter_reg <= (others => '0');
                    if v_pix_reg < to_unsigned(47, v_pix_reg'length) then
                        v_pix_reg <= v_pix_reg + 1; -- Increment the vertical pixel co-ordinate
                    else
                        v_pix_reg <= (others => '0');
                    end if;
                end if;
            end if;
        end if;
    end process REGISTER_VERTICAL;

--    REGISTER_VERTICAL : process (clk_25, reset)
--    begin
--        if reset = '1' then
--            v_counter_reg <= (others => '0');
--            v_pix_reg <= (others => '0');
--        elsif rising_edge(clk_25) then
--            if (frame_end = '1') then
--                v_counter_reg <= (others => '0');
--                v_pix_reg <= (others => '0');
--            else
--                if (state /= S_BLANK) and (line_end = '1') then
--                    if (v_counter_reg < 9) then
--                        v_counter_reg <= v_counter_reg + 1;
--                    else
--                        v_counter_reg <= (others => '0');
--                        if (v_pix_reg < 47) then
--                            v_pix_reg <= v_pix_reg + 1;
--                        else
--                            v_pix_reg <= (others => '0');
--                        end if;
--                    end if;
--                end if;
--            end if;
--        end if;
--    end process REGISTER_VERTICAL;

    NEXT_STATE_LOGIC : process (state, disp_active, v_counter_reg, h_counter_reg, line_end)
    begin
        next_state <= state;

        case state is
            when S_MEM_READ =>
                next_state <= S_IDLE;
            when S_BLANK =>
                if disp_active = '1' then
                    next_state <= S_IDLE;
                else
                    next_state <= S_BLANK;
                end if;
            when others =>
                if (v_counter_reg = 9) and (h_counter_reg = 9) and ((disp_active = '1') or (line_end = '1')) then
                    next_state <= S_MEM_READ;
                elsif (disp_active = '0') and (state = S_IDLE) then
                    next_state <= S_POST_IDLE;
                elsif (disp_active = '0') then
                    next_state <= S_BLANK;
                else
                    next_state <= S_IDLE;
                end if;
        end case;
    end process NEXT_STATE_LOGIC;

    -- Match the first SV always_comb thingy
    pixel_out <= row(to_integer(h_pix_reg));
    mem_read <= '1' when state = S_MEM_READ else '0';
    mem_row <= '1' when (disp_active = '1' and v_counter_reg = 9) or state = S_MEM_READ else '0';
    -- Address decode from the intermediate 12-bit vector
    addr <= intermediate_address(11 downto 3);
    pix_sel <= intermediate_address(2 downto 0);

    ADDRESS_DECODE : process (state, v_pix_reg, h_pix_reg, v_counter_reg)
    begin
        intermediate_address <= (others => '0');

        if state = S_MEM_READ then
            if v_pix_reg = 47 then
                -- Edge-case if we are on the last line
                if (h_pix_reg = 63) and (v_counter_reg = 0) then
                   intermediate_address <= (others => '0');
                else
                    intermediate_address <= std_logic_vector(resize(h_pix_reg, intermediate_address'length)-1);
                end if;
            else
                if (h_pix_reg = 63) and (v_counter_reg = 0) then
                    -- Edge case to grab the last pixel
                    intermediate_address <= std_logic_vector(v_pix_reg) & "111111";
                else
                    -- Set the memory address to get the next row
                    intermediate_address <= std_logic_vector(((v_pix_reg + 1) & h_pix_reg) - 1);
                end if;
            end if;
        end if;
    end process ADDRESS_DECODE;


end architecture;