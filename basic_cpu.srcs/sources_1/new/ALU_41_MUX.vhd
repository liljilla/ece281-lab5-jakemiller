----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2024 11:12:18 PM
-- Design Name: 
-- Module Name: ALU_41_MUX - Behavioral
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

entity ALU_41_MUX is
    Port ( i_mux_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_mux_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_mux_C : in STD_LOGIC_VECTOR (7 downto 0);
           i_mux_D : in STD_LOGIC_VECTOR (7 downto 0);
           i_sel : in STD_LOGIC_VECTOR (1 downto 0);
           o_res : out STD_LOGIC_VECTOR (7 downto 0));
end ALU_41_MUX;

architecture Behavioral of ALU_41_MUX is

begin
    o_res <= i_mux_A when i_sel = "00" else
             i_mux_B when i_sel = "01" else
             i_mux_C when i_sel = "10" else
             i_mux_D when i_sel = "11" else
             i_mux_A;

end Behavioral;
