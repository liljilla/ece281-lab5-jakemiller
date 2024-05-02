----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2024 10:21:48 AM
-- Design Name: 
-- Module Name: top_21MUX - Behavioral
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

entity top_21MUX is
    Port ( i_sel : in STD_LOGIC;
           i_primary : in STD_LOGIC_VECTOR (3 downto 0);
           i_ground : in STD_LOGIC_VECTOR (3 downto 0);
           o_anodes : out STD_LOGIC_VECTOR (3 downto 0));
end top_21MUX;

architecture Behavioral of top_21MUX is

begin
    
    o_anodes <= i_primary when i_sel = '0' else
                i_ground when i_sel = '1';
    

end Behavioral;
