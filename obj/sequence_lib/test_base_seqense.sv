`ifndef TEST_BASE_SEQENSE_SV
`define TEST_BASE_SEQENSE_SV
// File: test_base_seqense.sv
// Description: This file defines the base sequence class for the UVM environment
class test_base_seqense extends uvm_sequence #(test_transaction);
  `uvm_object_utils(test_sequencer)
  `uvm_declare_p_sequencer(my_axi_sequencer)
    // Configuration object
     test_cfg cfg;

    // Constructor
    function new(string name = "test_base_seqense");
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
    endfunction : build_phase
    // Body task
    virtual task body();   
    `uvm_info(get_type_name(), "body", UVM_LOW)
    // Create a test transaction
    endtask : body
    endclass : test_base_seqense
`endif // TEST_BASE_SEQENSE_SV