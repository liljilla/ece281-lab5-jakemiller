--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
    port(
          btnU : in std_logic;
          btnC : in std_logic;
          sw : in std_logic_vector(7 downto 0);
          clk: in std_logic;
          led : out std_logic_vector(15 downto 0);
          seg : out std_logic_vector(6 downto 0);
          an : out std_logic_vector(3 downto 0)
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	component controller_fsm is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
    end component controller_fsm;
    
    component clock_divider is
        generic ( constant k_DIV : natural := 2    );
        port (     i_clk    : in std_logic;         
                o_clk    : out std_logic     
        );
    end component clock_divider;
    
    component TDM4 is
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_clk        : in  STD_LOGIC;
               i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
        );
    end component TDM4;
    
    component ALU is
        Port ( i_op : in std_logic_vector (2 downto 0);
               i_A : in std_logic_vector (7 downto 0);
               i_B :  in std_logic_vector (7 downto 0);
               o_flag : out std_logic_vector (2 downto 0);
               o_result : out std_logic_vector (7 downto 0));
    end component ALU;
    
    component twoscomp_decimal is
        port (
            i_binary: in std_logic_vector(7 downto 0);
            o_negative: out std_logic_vector(3 downto 0);
            o_hundreds: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
    end component twoscomp_decimal;
    
    component sevenSegDecoder is
        Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
               o_S : out STD_LOGIC_VECTOR (6 downto 0));
    end component sevenSegDecoder;
    
    component top_MUX is
        Port ( i_C1 : in STD_LOGIC_VECTOR (7 downto 0);
               i_C2 : in STD_LOGIC_VECTOR (7 downto 0);
               i_C3 : in STD_LOGIC_VECTOR (7 downto 0);
               i_C4 : in STD_LOGIC_VECTOR (7 downto 0);
               i_sel : in STD_LOGIC_VECTOR (3 downto 0);
               o_bin : out STD_LOGIC_VECTOR (7 downto 0));
    end component top_MUX;

  
    component top_21MUX is
        Port ( i_sel : in STD_LOGIC;
               i_primary : in STD_LOGIC_VECTOR (3 downto 0);
               i_ground : in STD_LOGIC_VECTOR (3 downto 0);
               o_anodes : out STD_LOGIC_VECTOR (3 downto 0));
    end component top_21MUX;
    
    signal w_A, w_B, w_result, w_bin : std_logic_vector(7 downto 0);
    signal w_cycle, w_hund, w_tens, w_ones, w_data, w_sel, w_anodes, w_negative : std_logic_vector(3 downto 0);
    signal  w_flags : std_logic_vector(2 downto 0);
    signal w_clk, w_fsm_clk : std_logic;
    
begin
	-- PORT MAPS ----------------------------------------
	clock_divider_fsm_inst : clock_divider
            generic map( k_DIV => 12500000)
            port map (i_clk => clk,       
                  o_clk => w_fsm_clk
             );
    controller_fsm_inst : controller_fsm
        port map(
            i_clk => w_fsm_clk,
            i_reset => btnU,
            i_adv => btnC,
            o_cycle => w_cycle
        );
    clock_divider_inst : clock_divider
        generic map( k_DIV => 90000)
        port map (i_clk => clk,       
              o_clk => w_clk
         );
         
    register_A_proc : process (w_cycle(0))
    begin
        if(rising_edge(w_cycle(0))) then
            w_A <= sw;
        else
            w_A <= w_A;
        end if;
    end process;
    
    
    register_B_proc : process (w_cycle(1))
    begin
        if(rising_edge(w_cycle(1))) then
            w_B <= sw;
        else
            w_B <= w_B;
        end if;
    end process;
    
    ALU_inst : ALU
        port map( i_op => sw(2 downto 0),
               i_A => w_A,
               i_B => w_B,
               o_flag => w_flags,
               o_result => w_result
       );
   
   top_MUX_inst : top_MUX
        port map( i_C1 => w_A,
                  i_C2 => w_B,
                  i_C3 => w_result,
                  i_C4 => "00000000",
                  i_sel => w_cycle,
	              o_bin => w_bin
	   );
    
   twoscomp_decimal_inst : twoscomp_decimal
        port map( i_binary => w_bin,
                  o_negative => w_negative,
                  o_hundreds => w_hund,
                  o_tens => w_tens,
                  o_ones => w_ones
       );
    
   TDM4_inst : TDM4
        port map( i_D0 => w_ones,
                  i_D1 => w_tens,
                  i_D2 => w_hund,
                  i_D3 => w_negative,
                  o_data => w_data,
                  o_sel => w_sel,
                  i_clk => w_clk
       );
       
   sevenSegDecoder_inst : sevenSegDecoder
         port map( i_D => w_data,
                   o_S => seg(6 downto 0)
       );
       
   top_21MUX_inst : top_21MUX
         port map(i_sel => w_cycle(3),
                  i_primary => w_sel,
                  i_ground => "1111",
                  o_anodes => w_anodes
       );
       
   
	
	-- CONCURRENT STATEMENTS ----------------------------
	--seg(6) <= '1' when (w_negative = '1') and (w_anodes(3) = '0') else
	  -- '0';
	an(0) <= w_anodes(0);
	an(1) <= w_anodes(1);
	an(2) <= w_anodes(2);
	an(3) <= w_anodes(3);
	
	led(3) <= w_cycle(3);
	led(2) <= w_cycle(2);
	led(1) <= w_cycle(1);
	led(0) <= w_cycle(0);
	led(15 downto 13) <= w_flags when (w_cycle = "0100") else
	   "000";
	
end top_basys3_arch;
