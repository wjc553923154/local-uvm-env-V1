`ifndef TEST_DRiVER_SV
`define TEST_DRIVER_SV
// File: test_driver.sv
// Description: This file defines the test_driver component for the UVM environment

class test_driver extends uvm_driver #(test_sequence);
 `uvm_component_utils(test_driver)   
  test_cfg cfg;
  veirtual test_interface vif;

  extern task run(); 
  extern task reset();
  extern task get_and_driving();

  // Constructor
  function new(string name = "test_driver");
    super.new(name);
    endfunction
  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)
    // Get configuration object NTD confirm it is necessary?
    //cfg = test_cfg::type_id::get();
    //if (cfg == null) begin
    //  `uvm_fatal(get_type_name(), "Configuration object not found")
    //end
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
    // Reset the DUT
    reset();
    // Start driving sequences
    forever begin
      get_and_driving();
      @(posedge vif.clk);
    end
  endtask : run_phase

  // Reset task
  virtual task reset();
    `uvm_info(get_type_name(), "Resetting DUT", UVM_LOW)
    vif.rst_n = 0;
    @(posedge vif.clk);
    vif.rst_n = 1;
  endtask : reset

  // Task to get and drive sequence items
  virtual task get_and_driving();
    test_sequence seq_item;

    seq_item_port.get_next_item(seq_item)
    `uvm_info(get_type_name(), $sformatf("Driving item: %s", seq_item.get_name()), UVM_MEDIUM)
    // Drive the sequence item to the DUT
    @(posedge vif.cb_master);///NTD 扩充一下这里，
    vif.data_in = seq_item.data_in;
    // wait slave ready
    wait (vif.cb_master.awready == 1);
    vif.cb_master.awvalid <= 0;
    // Indicate that the item has been driven
    seq_item_port.item_done();///NTD confirm it is necessary? other way to send item_done?

      `uvm_info(get_type_name(), "AWVALID and AWREADY are high, ready to drive", UVM_MEDIUM)

  endtask : get_and_driving

endclass : test_driver
`endif // TEST_DRIVER_SV
