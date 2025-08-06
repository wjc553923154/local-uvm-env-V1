`ifndef TEST_ENV_SV
`define TEST_ENV_SV
// File: test_env.sv
// Description: This file defines the test environment for the UVM environment

class test_env extends uvm_env;
  `uvm_component_utils(test_env)

  // Configuration object
  test_cfg cfg;
  test_agent i_agent;
  test_agent o_agent;
  test_scoreboard scoreboard;
  test_ref_model ref_model;
  reg_adapter adapter;
  reg_predictor predictor;

  uvm_tlm_analysis_fifo #(test_traction) i_agent_mon_to_refmodel_fifo;
  uvm_tlm_analysis_fifo #(test_traction) o_agent_mon_to_scb_fifo;
  uvm_tlm_analysis_fifo #(test_traction) refmodel_to_scb_fifo;


  // Constructor
  function new(string name = "test_env");
    super.new(name);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)

    // Get configuration object
    if (!uvm_config_db#(test_cfg)::get(this, "", "cfg", cfg)) begin
      cfg = test_cfg::type_id::create("cfg");
    end

    // Create register block and adapter
    adapter = reg_adapter::type_id::create("adapter");
    predictor = reg_predictor::type_id::create("predictor", this);

    // Create agent and scoreboard components
    i_agent = test_agent::type_id::create("i_agent", this);
    i_agent.is_active = cfg.i_agent_active;
    o_agent = test_agent::type_id::create("o_agent", this);     
    o_agent.is_active = cfg.o_agent_active;
    scoreboard = test_scoreboard::type_id::create("scoreboard", this);
    ref_model = test_ref_model::type_id::create("ref_model", this);
    `uvm_info(get_type_name(), "Components created", UVM_LOW)
    // Create fifos
    i_agent_mon_to_refmodel_fifo = new("i_agent_mon_to_refmodel_fifo");     
    o_agent_mon_to_scb_fifo = new("o_agent_mon_to_scb_fifo");
    refmodel_to_scb_fifo = new("refmodel_to_scb_fifo");

    `uvm_info(get_type_name(), "Components created and connected", UVM_LOW)
  endfunction : build_phase
    // Connect phase
    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "connect_phase", UVM_LOW)
    //connect predictor
    predictor.map = reg_model.default_map;
    predictor.adapter = adapter; 
    i_agent.monitor.analysis_port.connect(predictor.req_in);
    o_agent.monitor.analysis_port.connect(predictor.rsp_in);  
    // Connect agent ports
    i_agent.monitor.mon_to_refmodel_port.connect(i_agent_mon_to_refmodel_fifo.uvm_analysis_port);
    ref_model.mon_to_c_port.connect(i_agent_mon_to_refmodel_fifo.uvm_analysis_export);
    //i_agent.driver.seq_item_export.connect(i_agent.sequencer.seq_item_port); atuo connect by super connect_phase
    `uvm_info(get_type_name(), "Input Agent ports connected", UVM_LOW)
    //connect output agent ports
    o_agent.monitor.mon_to_scb_port.connect(o_agent_mon_to_scb_fifo.uvm_analysis_port);
    scoreboard.actual_port.connect(o_agent_mon_to_scb_fifo.uvm_analysis_export);
    //conect ref model ports
    ref_model.c_to_scr_port.connect(refmodel_to_scb_fifo.uvm_analysis_port);
    scoreboard.expecet_port.connect(refmodel_to_scb_fifo.uvm_analysis_export);
    `uvm_info(get_type_name(), "Output Agent ports connected", UVM_LOW)
    endfunction : connect_phase

    function void report();
        `uvm_info(get_type_name(), "Test Environment Report", UVM_LOW)
        if (i_agent.monitor.item_num==o_agent.monitor.item_num) begin
          `uvm_info(get_type_name(), $sformatf("Input and Output Agent item count match: %0d", i_agent.monitor.item_num), UVM_MEDIUM)
        end else begin
          `uvm_error(get_type_name(), $sformatf("Input and Output Agent item count mismatch: Input %0d, Output %0d", i_agent.monitor.item_num, o_agent.monitor.item_num))
        end
        scoreboard.report();
    endfunction : report

    
endclass : test_env
`endif // TEST_ENV_SV

    