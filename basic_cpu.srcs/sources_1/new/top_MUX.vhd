----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2024 10:00:04 AM
-- Design Name: 
-- Module Name: top_ALU - Behavioral
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

entity top_MUX is
    Port ( i_C1 : in STD_LOGIC_VECTOR (7 downto 0);
           i_C2 : in STD_LOGIC_VECTOR (7 downto 0);
           i_C3 : in STD_LOGIC_VECTOR (7 downto 0);
           i_C4 : in STD_LOGIC_VECTOR (7 downto 0);
           i_sel : in STD_LOGIC_VECTOR (3 downto 0);
           o_bin : out STD_LOGIC_VECTOR (7 downto 0));
end top_MUX;

architecture Behavioral of top_MUX is

begin
    
    o_bin <= i_C1 when i_sel = "0001" else
             i_C2 when i_sel = "0010" else
             i_C3 when i_sel = "0100" else
             i_C4 when i_sel = "1000" else
             i_C1;

end Behavioral;
