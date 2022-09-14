----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.09.2022 10:33:18
-- Design Name: 
-- Module Name: message_module - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity message_module is
    
    Port (i_clk_message     : in std_logic                          ;
          i_message         : in std_logic_vector (5 downto 0)      ;
          
          o_message         : out std_logic_vector (5 downto 0))    ;
          
end message_module;

architecture Behavioral of message_module is

begin

process (i_clk_message) begin

if rising_edge(i_clk_message) then

o_message <= i_message;

end if;

end process;

end Behavioral;