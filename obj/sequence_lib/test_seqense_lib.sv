`ifndef  TEST_SEQUENCER_LIB_SV
`define TEST_SEQUENCER_LIB_SV
// File: test_sequencer_lib.sv
// Description: This file defines the test sequencer library for the UVM environment    
  class test_sequencer_lib extends uvm_sequence_library  #(test_transaction);
    `uvm_object_utils(test_sequencer_lib)
    `uvm_sequence_library_utils(test_sequencer_lib)

    // Configuration object
    test_cfg cfg;

    // Constructor
    function new(string name = "test_sequencer_lib");
      super.new(name);
      add_typewide_sequence(test_rd_base_seq::get_type(),`SEQ_LIB_WR_WIDTH);
      add_typewide_sequence(test_wr_base_seq::get_type(),`SEQ_LIB_RD_WIDTH);  
    endfunction

    // Build phase
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "build_phase", UVM_LOW)

      // Get configuration object
      if (!uvm_config_db#(test_cfg)::get(this, "", "cfg", cfg)) begin
        cfg= test_cfg::type_id::create("cfg");
      end
    endfunction : build_phase
    
    static function uvm_sequence create_seq(
        seq_type_t seq_type,
        string name = ""
    );
        case(seq_type)
        BASE_RD: return axi_base_rd_seq::type_id::create(name);
        BASE_WR: return axi_base_wr_seq::type_id::create(name);
        RAND_RD: return axi_base_rd_seq::type_id::create(name);
        ERR_INJ: return axi_base_wr_seq::type_id::create(name);
        default: `uvm_fatal("TYPERR", "Invalid sequence type")
        endcase
    endfunction

    static task run_sequences(
        uvm_sequencer_base sequencer,
        seq_type_t seq_types[],
        uvm_sequence_base parent = null
        );
        foreach(seq_types[i]) begin
        uvm_sequence seq = create_seq(seq_types[i]);
        seq.start(sequencer, parent);
        end
    endtask
endclasss : test_sequencer_lib 
`endif // TEST_SEQUENCER_LIB_SV 


//    seq_lib::run_sequences(
//      env.axi_agt.sequencer,
//      '{seq_lib::BASE_WR, seq_lib::RAND_RD}
//    );

