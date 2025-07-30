`ifndef TEST_MONITOR_SV
`define TEST_MONITOR_SV
// File: test_monitor.sv
// Description: This file defines the test_monitor component for the UVM environment

class test_monitor extends uvm_monitor;
 `uvm_component_utils(test_monitor)
  // Configuration object
  test_cfg cfg;
  virtual test_interface vif;
  uvm_analysis_port #(test_sequence) analysis_port;
  int item_num = 0;

  // Constructor
  function new(string name = "test_monitor");
    super.new(name);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)
    analysis_port= new("analysis_port");
    // Get configuration object
    if (!uvm_config_db#(test_cfg)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "Configuration object not found")
    end
    
    // Get virtual interface
    if (!$cast(vif, cfg.vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found")
    end
    `uvm_info(get_type_name(), "Virtual interface found", UVM_LOW)
  endfunction : build_phase

  // Run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "run_phase", UVM_LOW)
    
    // Monitor the DUT outputs
    forever begin
      @(posedge vif.clk);
      if (vif.VALID && vif.READY) begin//NTD confirm vif.READY 
        // Capture data from the DUT
        test_sequence seq_item = test_sequence::type_id::create("seq_item");
        seq_item.data_out = vif.data_out;
        item_num++;
        // Send the captured item to the analysis port
        analysis_port.write(seq_item);
      end
      // Add monitoring logic here, e.g., checking outputs or logging data
      `uvm_info(get_type_name(), $sformatf("Data Out: %h", vif.data_out), UVM_MEDIUM)
    end
  endtask : run_phase
`endif // TEST_MONITOR_SV