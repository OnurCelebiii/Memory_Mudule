----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- Create Date: 14.09.2022 11:57:17
-- Design Name: Memory Recovery Module if message = "000000" o_temp_data_memory save
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity memory_recovery is
    Port (i_recovery_constant_mem         :       in std_logic_vector(15 downto 0)      ;
          i_recovery_temp_mem             :       in std_logic_vector(15 downto 0)      ;
          i_clk_recovery                  :       in std_logic                           ;
          i_message_recovery              :       in std_logic_vector(5 downto 0))       ;
end memory_recovery;

architecture Behavioral of memory_recovery is

signal recovery_address             :           std_logic_vector (14 downto 0)   := "000000000000000"     ;
signal recovery_enable              :           std_logic                             ;
signal recovery_wea                 :           std_logic                             ;
signal data_out                     :           std_logic_vector (15 downto 0)        ;
signal recovery_address_reset       :           std_logic                             ;

COMPONENT recovery_memory
  PORT (
    clka            :           IN STD_LOGIC                                ;
    ena             :           IN STD_LOGIC                                ;
    wea             :           IN STD_LOGIC_VECTOR(0 DOWNTO 0)             ;
    addra           :           IN STD_LOGIC_VECTOR(14 DOWNTO 0)            ;
    dina            :           IN STD_LOGIC_VECTOR(15 DOWNTO 0)            ;
    douta           :           OUT STD_LOGIC_VECTOR(15 DOWNTO 0))          ;
END COMPONENT;

begin


recovery_module     :       recovery_memory port map(
clka                 =>           i_clk_recovery                ,
ena                  =>           recovery_enable               ,
wea(0)               =>           recovery_wea                  ,
addra                =>           recovery_address              ,
dina                 =>           i_recovery_temp_mem           ,
douta                =>           data_out)                     ;



process (i_clk_recovery) begin


if rising_edge(i_clk_recovery) then 

    if i_message_recovery = "000000" then
    
        recovery_enable         <=          '1'          ;
        recovery_wea            <=          '1'          ;
    else 
    
        recovery_enable         <=          '0'          ;
        recovery_wea            <=          '0'          ;
----------------address data writing and address clear command--------------------
    if recovery_enable = '1' and recovery_wea = '1' then 
    
            recovery_address   <= std_logic_vector(unsigned(recovery_address) + 1 );
            
            if recovery_address = "111111111111111" then
            
                recovery_address <= "111111111111111";
        
                    if recovery_address_reset = '1' and recovery_address = "111111111111111" then 
            
                        recovery_address <= "000000000000000" ;
            
                    end if;
            end if;
        end if;
    end if;
-----------------------------------------------------------------------

end if;


end process;


end Behavioral;
