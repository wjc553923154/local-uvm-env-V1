`ifndef TEST_SCOREBOARD_SV
`define TEST_SCOREBOARD_SV
// File: test_scoreboard.sv
// Description: This file defines the test_scoreboard component for the UVM environment

class test_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(test_scoreboard)

  // Configuration object
  test_cfg cfg;

  uvm_tlm_analysis_fifo  #(test_sequence) expecet_port;
  uvm_tlm_analysis_fifo  #(test_sequence) actual_port;
  test_traction expected_traction, actual_traction;
  int success_num=0;
  int fail_num=0;

  // Constructor
  function new(string name = "test_scoreboard");
    super.new(name);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)
    expecet_port = new("expecet_port");
    actual_port = new("actual_port");
    // Get configuration object
    if (!uvm_config_db#(test_cfg)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "Configuration object not found")
    end
    
  endfunction : build_phase

    function void report();
      `uvm_info(get_type_name(), $sformatf("Total Success: %0d, Total Failures: %0d", success_num, fail_num), UVM_MEDIUM)   
    endfunction : report  
  // Run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "run_phase", UVM_LOW)
    // Add scoreboard logic here, e.g., checking outputs or logging data
    forever begin
      expecet_port.get(expected_traction);
      actual_port.get(actual_traction);
      if (expected_traction.data_out == actual_traction.data_out) begin
        success_num++;
        `uvm_info(get_type_name(), $sformatf("Match found: %h", expected_traction.data_out), UVM_MEDIUM)
      end else begin
        fail_num++;
        `uvm_error(get_type_name(), $sformatf("Mismatch: Expected %h, Actual %h", expected_traction.data_out, actual_traction.data_out))
      end
      // Example of checking DUT outputs and logging them
      `uvm_info(get_type_name(), $sformatf("Data Out: %h", vif.data_out), UVM_MEDIUM)
      // Add more scoreboard logic as needed
    end

    virtual funtion void report_phase(uvm_phase phase);
      super.report_phase(phase);
      report();
      if (success_num > 0) begin
        `uvm_info(get_type_name(), "TEST PASSED", UVM_LOW)
      end else begin
        `uvm_error(get_type_name(), "TEST FAILED", UVM_LOW)
      end
    endfunction : report_phase
    
  endtask : run_phase   
endclass : test_scoreboard
`endif // TEST_SCOREBOARD_SV