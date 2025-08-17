library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pix_Streacher is
    port (
        clk_25MHz : in  std_logic;
        rst       : in  std_logic; -- active high
        line_end  : in  std_logic;
        frame_end : in  std_logic;
        DE_enable : in  std_logic; -- Display enable
        data_in   : in  std_logic_vector(3 downto 0);
        data_out  : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of pix_Streacher is
    -- FSM state type
    type state_type is (IDLE, COUNTING);
    signal state, next_state : state_type;

    -- counter for DE_enable pulses
    signal de_count, next_count : unsigned(3 downto 0) := (others => '0');

    -- data register
    signal data_reg, next_data : std_logic_vector(3 downto 0) := (others => '0');
begin
    ------------------------------------------------------------------
    -- Sequential process: state, counter, and output registers
    ------------------------------------------------------------------
    process(clk_25MHz)
    begin
        if rising_edge(clk_25MHz) then
            if rst = '1' then
                state     <= IDLE;
                de_count  <= (others => '0');
                data_reg  <= (others => '0');
            else
                state     <= next_state;
                de_count  <= next_count;
                data_reg  <= next_data;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- Combinational process: next state and outputs
    ------------------------------------------------------------------
    process(state, de_count, DE_enable, data_in, data_reg)
    begin
        -- default assignments
        next_state <= state;
        next_count <= de_count;
        next_data  <= data_reg;

        case state is
            ----------------------------------------------------------
            when IDLE =>
                if DE_enable = '1' then
                    next_count <= de_count + 1;
                    next_state <= COUNTING;
                end if;

            ----------------------------------------------------------
            when COUNTING =>
                if DE_enable = '1' then
                    if de_count = 9 then  -- after 10 pulses (0 to 9)
                        next_data  <= data_in;
                        next_count <= (others => '0');
                        next_state <= IDLE;
                    else
                        next_count <= de_count + 1;
                    end if;
                end if;
        end case;
    end process;

    -- output assignment
    data_out <= data_reg;

end architecture;
