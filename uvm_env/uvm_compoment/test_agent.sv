`ifndef TEST_AGENT_SV
`define TEST_AGENT_SV   
// File: test_agent.sv
// Description: This file defines the test_agent component for the UVM environment

class test_agent extends uvm_agent;
  `uvm_component_utils(test_agent)

  // Configuration object
  test_cfg cfg;
  virtual test_interface vif;
  test_sequencer sequencer;
  test_driver driver;
  test_monitor monitor;

  // Constructor
  function new(string name = "test_agent");
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
    
    // Get virtual interface
    if (!$cast(vif, cfg.vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found")
    end
    `uvm_info(get_type_name(), "Virtual interface found", UVM_LOW)

    // Create components
    if (is_active==UVM_ACTIVE) begin
        sequencer = test_sequencer::type_id::create("sequencer", this);
        driver = test_driver::type_id::create("driver", this);
      `uvm_info(get_type_name(), "Creating components", UVM_LOW)
    end else begin
      `uvm_info(get_type_name(), "Seq and Dri Components will not be created as agent is not active", UVM_LOW)
      return;
    end
    monitor = test_monitor::type_id::create("monitor", this);
    // Connect components
    driver.vif = vif;
    monitor.vif = vif;
    
    `uvm_info(get_type_name(), "Components created and connected", UVM_LOW)
  endfunction : build_phase 

virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "connect_phase", UVM_LOW)
    
    // Connect sequencer to driver
    if (is_active==UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
      `uvm_info(get_type_name(), "Sequencer connected to Driver", UVM_LOW)
    end else begin
      `uvm_info(get_type_name(), "Seq and Dri Components will not be connected as agent is not active", UVM_LOW)
    end
    
  endfunction : connect_phase
  endclass : test_agent
`endif // TEST_AGENT_SV