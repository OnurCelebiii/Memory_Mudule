----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.09.2022 07:53:23
-- Design Name: 
-- Module Name: memory_modulee - Behavioral
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


entity memory_modulee is

    Port (i_wea_memory                          :           in std_logic                            ;
          i_ena_memory                          :           in std_logic                            ;
          i_dina_memory                         :           in std_logic_vector (15 downto 0)       ;
          i_clk_memory                          :           in std_logic                            ;
          i_constant_memory_address_reset       :           in std_logic                            ;
          o_constant_dout_memory                :           out std_logic_vector (15 downto 0)      ;
          o_message                             :           out std_logic_vector (5 downto 0)       ;
          o_temp_douta_memory                   :           out std_logic_vector (15 downto 0))     ;
          
end memory_modulee;

architecture Behavioral of memory_modulee is

signal temp_memory_address              :           std_logic_vector (3 downto 0)    :="0000"                   ;
signal constant_memory_address          :           std_logic_vector (10 downto 0)   :="00000000000"            ;
signal s_i_dina_memory                  :           std_logic_vector (15 downto 0)                              ;
signal s_dout_temp_memory               :           std_logic_vector (15 downto 0)                              ;
signal s_dout_constant_memory           :           std_logic_vector (15 downto 0)                              ;
signal s_o_message                      :           std_logic_vector (5 downto 0)                               ;

COMPONENT blk_mem_gen_0  -- temp memory
  PORT (
    clka            :           IN STD_LOGIC                        ;
    ena             :           IN STD_LOGIC                        ;
    wea             :           IN STD_LOGIC_VECTOR(0 DOWNTO 0)     ;
    addra           :           IN STD_LOGIC_VECTOR(3 DOWNTO 0)     ;
    dina            :           IN STD_LOGIC_VECTOR(15 DOWNTO 0)    ;
    douta           :           OUT STD_LOGIC_VECTOR(15 DOWNTO 0))  ;
END COMPONENT;

COMPONENT depo_memory  --constant memory
  PORT (
    clka            :           IN STD_LOGIC                        ;
    ena             :           IN STD_LOGIC                        ;
    wea             :           IN STD_LOGIC_VECTOR(0 DOWNTO 0)     ;
    addra           :           IN STD_LOGIC_VECTOR(10 DOWNTO 0)    ;
    dina            :           IN STD_LOGIC_VECTOR(15 DOWNTO 0)    ;
    douta           :           OUT STD_LOGIC_VECTOR(15 DOWNTO 0))  ;
END COMPONENT;


begin



temp_meory : blk_mem_gen_0
  PORT MAP (
    clka            =>          i_clk_memory            ,
    ena             =>          i_ena_memory            ,
    wea(0)          =>          i_wea_memory            ,
    addra           =>          temp_memory_address     ,
    dina            =>          s_i_dina_memory         ,
    douta           =>          s_dout_temp_memory)     ;



constant_memory : depo_memory --- const memory
  PORT MAP (
    clka            =>          i_clk_memory                ,
    ena             =>          i_ena_memory                ,
    wea(0)          =>          i_wea_memory                ,
    addra           =>          constant_memory_address     ,
    dina            =>          s_dout_temp_memory          ,
    douta           =>          s_dout_constant_memory)     ;


address_increase : process (i_clk_memory) begin

if rising_edge(i_clk_memory) then 

    s_i_dina_memory          <=      i_dina_memory          ;
    o_temp_douta_memory      <=      s_dout_temp_memory     ;   
    o_constant_dout_memory   <=      s_dout_constant_memory ;

    if i_ena_memory = '1' then 

        if i_wea_memory = '1' then 

            if constant_memory_address = "11111111111" then 

                constant_memory_address <=      "11111111111"                                               ;
                temp_memory_address     <=      std_logic_vector(unsigned(temp_memory_address) + 1)         ;

            else

                constant_memory_address     <=      std_logic_vector(unsigned(constant_memory_address) + 1)     ;
                temp_memory_address         <=      std_logic_vector(unsigned(temp_memory_address) + 1)         ;
                
            end if;
            
            if i_constant_memory_address_reset = '1' then
            
                constant_memory_address     <=  "00000000000"       ;
            
            end if;

        end if;

    else

        --s_dout_temp_memory      <=      "0000000000000000"       ;
        s_i_dina_memory         <=      "0000000000000000"       ;

    end if;

end if; 

end process;

error_p     :   process (i_clk_memory) begin

if rising_edge(i_clk_memory) then 

o_message    <=       s_o_message       ;
----------------------------------------------------------------------------------------------
--------------------------output temp and const memory compare--------------------------------
----------------------------------------------------------------------------------------------

if s_dout_temp_memory =  s_dout_constant_memory and s_i_dina_memory = s_dout_temp_memory and s_i_dina_memory = s_dout_constant_memory then 
        
            s_o_message <= "111111" ;--true 

        else 
    
            s_o_message <= "000000" ;-- false temp memory and constant memory can not same
    
end if;
----------------------------------------------------------------------------------------------
------------------------------constant memory address length----------------------------------
----------------------------------------------------------------------------------------------

  --- if constant_memory_address = "11111111111" then 
  --- 
  ---     s_o_message <= "000001" ;  -- constant memory address full
  --- 
  --- else 
  --- 
  ---     s_o_message <= "000010" ; -- constant memory address not full
  --- 
  --- end if;

----------------------------------------------------------------------------------------------
------------------------------constant memory address reset-----------------------------------
----------------------------------------------------------------------------------------------

       -- if constant_memory_address_reset = '1' then 
       -- 
       --     s_o_message <= "000011" ; --const memory address reset
       -- 
       -- else 
       -- 
       --     s_o_message <= "000100" ; -- const memory address not reset 
       -- 
       -- end if;

----------------------------------------------------------------------------------------------
------------------------------------enable pin control----------------------------------------
----------------------------------------------------------------------------------------------

      --      if i_ena_memory = '1'  then 
      --      
      --          s_o_message <= "000101" ; -- enable = 1
      --      
      --      else 
      --      
      --          s_o_message <= "000110" ; -- enable = 0
      --      
      --      end if;

----------------------------------------------------------------------------------------------
------------------------------------wea pin control-------------------------------------------
----------------------------------------------------------------------------------------------

      --          if i_wea_memory = '1' then 
      --          
      --              s_o_message <= "000111" ; -- wea pin = 1
      --          
      --          else
      --          
      --              s_o_message <= "001000" ; -- wea pin = 0
      --          
      --          end if;


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
end if;

end process;


end Behavioral;
