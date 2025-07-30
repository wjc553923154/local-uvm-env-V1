`ifndef TEST_CASE1_SEQ_LIB_SV
`define TEST_CASE1_SEQ_LIB_SV

class test_case1_seq_lib extends test_base_test;
  `uvm_component_utils(test_case1_seq_lib)
  

  // Constructor
  function new(string name = "test_case1_seq_lib");
    super.new(name);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)
        uvm_config_db#(uvm_object_wrapper)::set(
      this,
      "env.i_agent.sequencer.main_phase",
      "default_sequence",
      test_sequencer_lib::get_type()
    );
    uvm_config_db#(uvm_sequence_lib_mode)::set(
      this,
      "env.i_agent.sequencer.test_sequencer_lib",
      "selection_mode",
      UVM_SEQ_LIB_RAND
    );
    
    uvm_config_db#(int)::set(
      this,
      "env.i_agent.sequencer.test_sequencer_lib",
      "min_random_count",
      5
    );
    
    uvm_config_db#(int)::set(
      this,
      "env.i_agent.sequencer.test_sequencer_lib",
      "max_random_count",
      15
    );
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        test_sequencer_lib seq_lib;
        seq_lib = test_sequencer_lib::type_id::create("seq_lib");
  
        seq_lib.selection_mode = UVM_SEQ_LIB_RAND;
        seq_lib.min_random_count = 10;
        seq_lib.start(env.axi_agt.sequencer);
        phase.drop_objection(this);
    endtask
  endfunction : build_phase