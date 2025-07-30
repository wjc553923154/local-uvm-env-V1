`ifndef  TEST_CONFIG_SV
`define TEST_CONFIG_SV

class test_cfg extends uvm_object;
  `uvm_object_utils(test_cfg)

  // Configuration parameters
  string vif_name; // Name of the virtual interface
  test_interface vif; // Virtual interface handle
  uvm_active_passive i_agent_is_active=UVM_ACTIVE; // Active or passive mode
  uvm_active_passive o_agent_is_active=UVM_ACTIVE; // Active or passive mode
  // Constructor
  function new(string name = "test_cfg");
    super.new(name);
  endfunction

  // Function to set the virtual interface
  function void set_vif(test_interface vif);
    this.vif = vif;
    this.vif_name = vif.get_name();
    `uvm_info(get_type_name(), $sformatf("Virtual interface set: %s", this.vif_name), UVM_LOW)
  endfunction