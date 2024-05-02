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
--|
--| ALU OPCODES:
--|
--|     ADD     000
--|
--|
--|
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
    Port ( i_op : in std_logic_vector (2 downto 0);
           i_A : in std_logic_vector (7 downto 0);
           i_B :  in std_logic_vector (7 downto 0);
           o_flag : out std_logic_vector (2 downto 0);
           o_result : out std_logic_vector (7 downto 0));
end ALU;

architecture behavioral of ALU is
    component ALU_21_MUX is
        port ( i_mux_A : in std_logic_vector(7 downto 0);
               i_mux_B : in std_logic_vector(7 downto 0);
               i_sel : in std_logic;
               o_res : out std_logic_vector(7 downto 0) 
              );
    end component ALU_21_MUX;
    
    component ALU_41_MUX is
        Port ( i_mux_A : in STD_LOGIC_VECTOR (7 downto 0);
               i_mux_B : in STD_LOGIC_VECTOR (7 downto 0);
               i_mux_C : in STD_LOGIC_VECTOR (7 downto 0);
               i_mux_D : in STD_LOGIC_VECTOR (7 downto 0);
               i_sel : in STD_LOGIC_VECTOR (1 downto 0);
               o_res : out STD_LOGIC_VECTOR (7 downto 0));
    end component ALU_41_MUX;
    
    component FA_8bit is
    port(x,y : in std_logic_vector(7 downto 0);
         cin : in std_logic;
          sum : out std_logic_vector(7 downto 0);
          co : out std_logic);
    end component FA_8bit;
    
    signal w_ls, w_rs, w_shift, w_or, w_and, w_taskB, w_presub, w_postsub, w_preresult, w_result : std_logic_vector(7 downto 0);
    signal w_cout : std_logic;
	-- declare components and signals
	
  
begin
	-- PORT MAPS ----------------------------------------
    shift_mux_inst : ALU_21_MUX
        port map(
             i_mux_A => w_ls,
             i_mux_B => w_rs,
             i_sel => i_op(0),
             o_res => w_shift
        );
    sub_mux_inst : ALU_21_MUX
         port map(
             i_mux_A => i_B,
             i_mux_B => w_presub,
             i_sel => i_op(0),
             o_res => w_postsub
        );
    adder_mux_inst : ALU_41_MUX
         port map(
            i_mux_A => w_taskB,
            i_mux_B => w_taskB,
            i_mux_C => w_and,
            i_mux_D => w_or,
            i_sel => i_op(1 downto 0),
            o_res => w_preresult
         );
     result_mux_inst : ALU_21_MUX
         port map(
            i_mux_A => w_preresult,
            i_mux_B => w_shift,
            i_sel => i_op(2),
            o_res => w_result
         );
    
    full_adder_inst : FA_8bit
        port map(
            x => i_A,
            y => w_postsub,
            cin => i_op(0),
            sum => w_taskB,
            co => w_cout
        );

	-- CONCURRENT STATEMENTS ----------------------------
	w_ls <= std_logic_vector(shift_left(unsigned(i_A), to_integer(unsigned(i_B))));
    w_rs <= std_logic_vector(shift_right(unsigned(i_A), to_integer(unsigned(i_B))));
	w_presub <= not(i_B);
	w_and <= i_A and i_B;
	w_or <= i_A or i_B;
	o_flag(2) <= w_result(7);
	o_flag(1) <= (not(w_result(7)) and not(w_result(6)) and not(w_result(5)) and not(w_result(4)) and not(w_result(3)) and not(w_result(2)) and not(w_result(1)) and not(w_result(0))) ;
	o_flag(0) <= ((not(i_op(1))) and (w_cout) and (not(i_op(2))));
	o_result <= w_result;
	
end behavioral;
