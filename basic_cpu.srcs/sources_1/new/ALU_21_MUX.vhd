----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2024 11:08:19 PM
-- Design Name: 
-- Module Name: ALU_21_MUX - Behavioral
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

entity ALU_21_MUX is
    Port ( i_sel : in STD_LOGIC;
           i_mux_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_mux_B : in STD_LOGIC_VECTOR (7 downto 0);
           o_res : out STD_LOGIC_VECTOR (7 downto 0));
end ALU_21_MUX;

architecture Behavioral of ALU_21_MUX is

begin

    o_res <= i_mux_A when i_sel = '0' else
             i_mux_B when i_sel = '1';


end Behavioral;
