library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- TODO: we need some way to control the simulation speed (maybe just 1 bit to cycle though presets/dercrease speed?)

--! Cellular Automaton - Update logic for a single cell
--! inputs:
-- center_age  : current age of the cell (pixel value)
-- nbrs_active : 8-bit vector indicating which of the 8 neighbors are active (any bit is 1))
-- - B/S rule sets are 9-bit (index = neighbor count 0..8). Example:
--     B="101000000" => births at 0 and 2 neighbors
--     S="001100000" => survives at 2 or 3 neighbors
-- - ruleset_sel selects between rule set 0 and 1.
-- output: updated_age is the new N-bit age to be written into the framebuffer -> input to CLUT for actual color values.

entity cellular_automaton is
  generic (
    AGE_WIDTH : positive := 4; --Sets color depth
    RULE_COUNT : positive := 5
  );
  port (
    clk          : in  std_logic;
    reset        : in  std_logic;

    center_age   : in  unsigned(AGE_WIDTH-1 downto 0);
    nbrs_active  : in  std_logic_vector(7 downto 0); -- 8 neighbors, each as 1 bit value (1 if alive)

    ruleset_next : in  std_logic; -- Pulse to advance to next ruleset

    updated_age  : out unsigned(AGE_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of cellular_automaton is
  constant AGE_MAX : unsigned(AGE_WIDTH-1 downto 0) := (others => '1');

  -- Example rule sets: each is (B, S)
  type rule_array_t is array (0 to RULE_COUNT-1) of std_logic_vector(8 downto 0);

  --TODO will update with more fancy rules later
  constant B_RULE_SET : rule_array_t := (
    0 => "000100000", -- Conway B3
    1 => "101000000", -- B02
    2 => "000011000", -- B45
    3 => "001110000", -- B234
    4 => "000000001"  -- B8
  );

  constant S_RULE_SET : rule_array_t := (
    0 => "001100000", -- S23
    1 => "001100000", -- S23
    2 => "001110000", -- S234
    3 => "001111000", -- S2345
    4 => "111111111"  -- all
  );

  signal rule_index : integer range 0 to RULE_COUNT-1 := 0;
  signal b_rules, s_rules : std_logic_vector(8 downto 0);

  signal alive_now  : std_logic;
  signal nbr_count  : integer range 0 to 8;
  signal birth_cond : std_logic;
  signal surv_cond  : std_logic;

begin
  -- Rule set cycling logic
  process(clk, reset)
  begin
    if reset = '1' then
      rule_index <= 0;
    elsif rising_edge(clk) then
      if ruleset_next = '1' then
        if rule_index = RULE_COUNT-1 then
          rule_index <= 0;
        else
          rule_index <= rule_index + 1;
        end if;
      end if;
    end if;
  end process;

  -- Get current rules from rule set
  b_rules <= B_RULE_SET(rule_index);
  s_rules <= S_RULE_SET(rule_index);

  -- Alive if age > 0
  alive_now <= '1' when center_age > 0 else '0';

  -- TODO: Is this efficient? Otherwise calculate sum beforehand and input just the sum or input full values  
  process(nbrs_active)
    variable sum : integer range 0 to 8;
  begin
    sum := 0;
    for i in 0 to 7 loop
      if nbrs_active(i) = '1' then
        sum := sum + 1;
      end if;
    end loop;
    nbr_count <= sum;
  end process;

  -- Evaluate Rules - check if bit is set at index == neighbor count
  birth_cond <= '1' when (alive_now = '0' and b_rules(nbr_count) = '1') else '0';
  surv_cond  <= '1' when (alive_now = '1' and s_rules(nbr_count) = '1') else '0';

  -- Compute next age
  process(center_age, birth_cond, surv_cond)
    variable next_age : unsigned(AGE_WIDTH-1 downto 0);
  begin
    if birth_cond = '1' then
      next_age := (others => '0');
      next_age(0) := '1'; -- birth -> set age to 1
    elsif surv_cond = '1' then
      if center_age = AGE_MAX then
        next_age := AGE_MAX;
      else
        next_age := center_age + 1; -- was alive and survives -> increment age
      end if;
    else
      next_age := (others => '0'); -- dead
    end if;
    updated_age <= next_age;
  end process;

end architecture;