----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2024 10:36:10 PM
-- Design Name: 
-- Module Name: controller_fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm is
    Port ( i_clk : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture Behavioral of controller_fsm is

    type sm_current_state is (s_a, s_b, s_op, s_blank);
    
    signal f_Q, f_Q_next : sm_current_state;

begin
    
    f_Q_next <= 
           s_a when (i_adv = '1' and f_Q = s_blank) else
           s_b when (i_adv = '1' and f_Q = s_a) else
           s_op when (i_adv = '1' and f_Q = s_b) else
           s_blank when (i_adv = '1' and f_Q = s_op) else
           s_a;
           
    with f_Q select
        o_cycle <= "0001" when s_a,
                   "0010" when s_b, 
                   "0100" when s_op,
                   "1000" when s_blank,
                   "0001" when others;
                   
   register_proc : process (i_adv, i_reset, i_clk)
       begin
       if(rising_edge(i_clk)) then
            if (i_reset = '1') then
                f_Q <= s_a;
            elsif (i_adv = '1') then
                f_Q <= f_Q_next;
            end if;
       end if;

   end process register_proc;
end Behavioral;
