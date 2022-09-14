----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- Create Date: 14.09.2022 13:42:18
-- Design Name: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top_memory_module is
    Port (i_clk_top_memory                          :               in std_logic                           ;
          i_enable_top_memory                       :               in std_logic                           ;
          i_wea_top_memory                          :               in std_logic                           ;
          i_const_memory_address_reset_top_memory   :               in std_logic)                          ;
end top_memory_module;

architecture Behavioral of top_memory_module is
----------------------------------------signal decleration--------------------------------------------------
signal message                                      :               std_logic_vector (5 downto 0)          ;
signal constant_memory_module_output                :               std_logic_vector (15 downto 0)         ;
signal temp_meemory_module_output                   :               std_logic_vector (15 downto 0)         ;
signal o_memory_message                             :               std_logic_vector (5 downto 0)          ;
signal o_message_module_message                     :               std_logic_vector (5 downto 0)          ;
signal clk_10MHz                                    :               std_logic                              ;
signal clk_100MHz                                   :               std_logic                              ;
signal i_data_top_memory                            :               std_logic_vector(15 downto 0)          ;

------------------------------------------------------------------------------------------------------------


--------------------------------------------memory module---------------------------------------------------
component memory_modulee is                                                                            
                                                                                                    
    Port (i_wea_memory                          :           in std_logic                                   ;
          i_ena_memory                          :           in std_logic                                   ;
          i_dina_memory                         :           in std_logic_vector (15 downto 0)              ;
          i_clk_memory                          :           in std_logic                                   ;
          i_constant_memory_address_reset       :           in std_logic                                   ;
          o_constant_dout_memory                :           out std_logic_vector (15 downto 0)             ;
          o_message                             :           out std_logic_vector (5 downto 0)              ;
          o_temp_douta_memory                   :           out std_logic_vector (15 downto 0))            ;

end component;
------------------------------------------------------------------------------------------------------------


---------------------------------------memry recovery module------------------------------------------------
component memory_recovery is

    Port (i_recovery_constant_mem               :           in std_logic_vector(15 downto 0)               ;
          i_recovery_temp_mem                   :           in std_logic_vector(15 downto 0)               ;
          i_clk_recovery                        :           in std_logic                                   ;
          i_message_recovery                    :           in std_logic_vector(5 downto 0))               ;
          
end component;
------------------------------------------------------------------------------------------------------------


------------------------------------------message module----------------------------------------------------
component message_module is
    
    Port (i_clk_message                         :           in std_logic                                   ;
          i_message                             :           in std_logic_vector (5 downto 0)               ;
          o_message                             :           out std_logic_vector (5 downto 0))             ;
          
end component;
------------------------------------------------------------------------------------------------------------


-----------------------------------------------vio----------------------------------------------------------
COMPONENT vio_0
  PORT (
    clk                 :           IN STD_LOGIC                                ;
    probe_out0          :           OUT STD_LOGIC_VECTOR(15 DOWNTO 0))          ;
END COMPONENT;
------------------------------------------------------------------------------------------------------------


-----------------------------------------------ila----------------------------------------------------------
COMPONENT ila
PORT (
	clk                :            IN STD_LOGIC                                ;
	probe0             :            IN STD_LOGIC_VECTOR(15 DOWNTO 0))           ;
END COMPONENT  ;
------------------------------------------------------------------------------------------------------------


-------------------------------------------clk wizard-------------------------------------------------------
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out_10MHz         :               out    std_logic                      ;
  clk_out_100MHz        :               out    std_logic                      ;
  clk_in1               :               in     std_logic)                     ;
end component;
------------------------------------------------------------------------------------------------------------


begin


------------------------------------memory module port map--------------------------------------------------
module_memory : memory_modulee port map(
i_wea_memory                             =>                  i_wea_top_memory                              ,
i_ena_memory                             =>                  i_enable_top_memory                           ,
i_dina_memory                            =>                  i_data_top_memory                             ,
i_clk_memory                             =>                  clk_10MHz                              ,
i_constant_memory_address_reset          =>                  i_const_memory_address_reset_top_memory       ,
o_constant_dout_memory                   =>                  constant_memory_module_output                 ,
o_message                                =>                  o_memory_message                              ,
o_temp_douta_memory                      =>                  temp_meemory_module_output)                   ;
------------------------------------------------------------------------------------------------------------


------------------------------------memory recovery port map------------------------------------------------
module_recovery : memory_recovery port map(
i_recovery_constant_mem                  =>                  constant_memory_module_output                 ,
i_recovery_temp_mem                      =>                  temp_meemory_module_output                    ,
i_clk_recovery                           =>                  clk_10MHz                                     ,
i_message_recovery                       =>                  o_message_module_message)                     ;
------------------------------------------------------------------------------------------------------------


------------------------------------message module port map-------------------------------------------------
module_message : message_module port map(
i_clk_message                           =>                   clk_10MHz                                     ,
i_message                               =>                   o_memory_message                              ,
o_message                               =>                   o_message_module_message)                     ;
------------------------------------------------------------------------------------------------------------


---------------------------------------ila port map---------------------------------------------------------
illa : ila
PORT MAP (
	clk                    =>       clk_100MHz                                  ,
	probe0                 =>       temp_meemory_module_output)                 ;
------------------------------------------------------------------------------------------------------------


----------------------------------------vio port map--------------------------------------------------------
vioo : vio_0
  PORT MAP (
    clk                     =>      clk_100MHz                                  ,
    probe_out0              =>      i_data_top_memory)                          ;
------------------------------------------------------------------------------------------------------------


---------------------------------------clk_wizard_port map--------------------------------------------------
clk_viz : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out_10MHz            =>      clk_10MHz                                   ,
   clk_out_100MHz           =>      clk_100MHz                                  ,
   -- Clock in ports
   clk_in1                  =>      i_clk_top_memory)                           ;
------------------------------------------------------------------------------------------------------------

end Behavioral;
