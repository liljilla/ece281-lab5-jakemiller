----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2024 05:50:25 PM
-- Design Name: 
-- Module Name: ALU_tb - Behavioral
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

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is


component ALU is
    Port ( i_op : in std_logic_vector (2 downto 0);
           i_A : in std_logic_vector (7 downto 0);
           i_B :  in std_logic_vector (7 downto 0);
           o_flag : out std_logic_vector (2 downto 0);
           o_result : out std_logic_vector (7 downto 0));
end component;

 signal w_op : std_logic_vector (2 downto 0);
 signal w_A :  std_logic_vector (7 downto 0);
 signal w_B : std_logic_vector (7 downto 0);
 
 signal w_flag : std_logic_vector (2 downto 0);
 signal w_result : std_logic_vector(7 downto 0);
 
begin

    uut: ALU port map (
        i_op => w_op,
        i_A => w_A,
        i_B => w_B,
        o_flag => w_flag,
        o_result => w_result
        );
        
        
    sim_proc: process
    begin
        w_A <= "00000011";
        w_B <= "00000110";
        w_op <= "000";
        wait for 10ns;
        --assert w_result = "00001001" report "bad sum" severity error;
        
        w_A <= "00000111";
        w_B <= "00000110";
        w_op <= "000";
        wait for 10ns;
        --assert w_result = "00001101" report "bad sum" severity error;
        
        w_A <= "00001000";
        w_B <= "00000010";
        w_op <= "001";
        wait for 10ns;
        --assert w_result = "00000100" report "bad sum" severity error;
        
        w_A <= "00001000";
        w_B <= "00000010";
        w_op <= "001";
        wait for 10ns;
        --assert w_result = "00000100" report "bad sum" severity error;
        
        w_A <= "00001000";
        w_B <= "00001010";
        w_op <= "010";
        wait for 10ns;
        --assert w_result = "00001000" report "bad sum" severity error;
        
        w_A <= "00001000";
        w_B <= "00000010";
        w_op <= "011";
        wait for 10ns;
        --assert w_result = "00001010" report "bad sum" severity error;
        
        w_A <= "00001000";
        w_B <= "00000010";
        w_op <= "100";
        wait for 10ns;
        --assert w_result = "00100000" report "bad sum" severity error;
        
        w_A <= "00001000";
        w_B <= "00000010";
        w_op <= "101";
        wait for 10ns;
        --assert w_result = "00000010" report "bad sum" severity error;
        
    end process;
        

end Behavioral;
