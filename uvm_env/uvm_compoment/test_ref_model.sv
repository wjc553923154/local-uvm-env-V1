`ifndef TEST_REF_MODEL_SV
`define TEST_REF_MODEL_SV
// File: test_ref_model.sv
// Description: This file defines the test_ref_model component for the UVM environment

import "DPI-C" context function int C_ref_model(inout byte arr[]);
export "DPI-C" function dpi_test_funciton=function int dpi_test_funciton;
function int dpi_test_funciton(byte arr[]);
  //return C_ref_model(arr);
  `uvm_info("DPI", $sformatf("DPI function called with array: %p", arr), UVM_LOW)
endfunction : dpi_test_funciton


class test_ref_model extends uvm_component;
  `uvm_component_utils(test_ref_model)

  // Configuration object
  test_cfg cfg;
  test_traction c_to_scr_tr;
  test_traction mon_to_c_tr;
  byte packed_data[];
  uvm_tlm_analysis_fifo #(test_traction) c_to_scr_port;
  uvm_blocking_get_port #(test_traction) mon_to_c_port;


  // Constructor
  function new(string name = "test_ref_model");
    super.new(name);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)
    
    // Get configuration object
    if (!uvm_config_db#(test_cfg)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "Configuration object not found")
    end
    
    // Create ports
    c_to_scr_port = new("c_to_scr_port", this);
    mon_to_c_port = new("mon_to_c_port", this);
  endfunction : build_phase
    // Run phase    
    virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "run_phase", UVM_LOW)      
    // Add reference model logic here, e.g., processing data from the DUT
    forever begin
      c_to_scr_tr=new("c_to_scr_tr");
      mon_to_c_tr=new("mon_to_c_tr");
      // Wait for data from the monitor
      mon_to_c_port.get(mon_to_c_tr);
      mon_to_c_tr.pack(packed_data);
      for (int i = 0; i < packed_data.size(); i++) begin
        `uvm_info(get_type_name(), $sformatf(" mon_to_c_tr Packed data[%0d]: %0h", i, packed_data[i]), UVM_MEDIUM)
      end
     // Process the data and send it to the scoreboard
      dpi_test_funciton(packed_data);
      for (int i = 0; i < packed_data.size(); i++) begin
        `uvm_info(get_type_name(), $sformatf(" c_to_scr_tr Packed data[%0d]: %0h", i, packed_data[i]), UVM_MEDIUM)
      end
      c_to_scr_tr.unpack(packed_data);
      // Send processed data to the scoreboard
      c_to_scr_port.write(c_to_scr_tr);
    end
  endtask : run_phase
    `endif // TEST_REF_MODEL_SV