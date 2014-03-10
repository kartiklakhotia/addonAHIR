-- VHDL global package produced by vc2vhdl from virtual circuit (vc) description 
library ieee;
use ieee.std_logic_1164.all;
package ahir_system_global_package is -- 
  constant Offset_base_address : std_logic_vector(3 downto 0) := "0000";
  constant best_mse_base_address : std_logic_vector(0 downto 0) := "0";
  constant best_sigma_index_base_address : std_logic_vector(0 downto 0) := "0";
  constant dotP0_base_address : std_logic_vector(3 downto 0) := "0000";
  constant dotP1_base_address : std_logic_vector(3 downto 0) := "0000";
  constant dotP2_base_address : std_logic_vector(3 downto 0) := "0000";
  constant dotP3_base_address : std_logic_vector(3 downto 0) := "0000";
  constant dotP4_base_address : std_logic_vector(3 downto 0) := "0000";
  constant dotP5_base_address : std_logic_vector(3 downto 0) := "0000";
  constant err_base_address : std_logic_vector(3 downto 0) := "0000";
  constant hF0_base_address : std_logic_vector(10 downto 0) := "00000000000";
  constant hF1_base_address : std_logic_vector(10 downto 0) := "00000000000";
  constant hF2_base_address : std_logic_vector(10 downto 0) := "00000000000";
  constant hF3_base_address : std_logic_vector(10 downto 0) := "00000000000";
  constant hF4_base_address : std_logic_vector(10 downto 0) := "00000000000";
  constant hF5_base_address : std_logic_vector(10 downto 0) := "00000000000";
  constant hFall_base_address : std_logic_vector(13 downto 0) := "00000000000000";
  constant inputData_base_address : std_logic_vector(7 downto 0) := "00000000";
  -- 
end package ahir_system_global_package;
