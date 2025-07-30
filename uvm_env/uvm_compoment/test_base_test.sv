`ifndef TEST_BASE_TEST_SV
`define TEST_BASE_TEST_SV
// File: test_base_test.sv
// Description: This file defines the base test class for the UVM environment
class test_base_test extends uvm_test;
  `uvm_component_utils(test_base_test)

  // Configuration object
  test_cfg cfg;
  test_env env;

  // Constructor
  function new(string name = "test_base_test");
    super.new(name);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)

    // Create environment
    env = test_env::type_id::create("env", this);
    cfg.is_active = UVM_ACTIVE;
    cfg.num_agents = 2;
    uvm_config_db#(my_config)::set(this, "*", "config", cfg);
    `uvm_info(get_type_name(), "Environment created", UVM_LOW)
  endfunction : build_phase

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    uvm_report_server report_server = uvm_report_server::get_server();
    int ERROR_NUM=0;
    ERROR_NUM = report_server::get_severity_count(UVM_ERROR);
    if (ERROR_NUM > 0) begin
      `uvm_error(get_type_name(), $sformatf("Test failed with %0d errors", ERROR_NUM))
    end else begin
      `uvm_info(get_type_name(), "Test passed", UVM_LOW)
    end
    `uvm_info(get_type_name(), "Test completed", UVM_LOW)
    env.scoreboard.report();    
    endfunction : report_phase
endclass : test_base_test
`endif // TEST_BASE_TEST_SV