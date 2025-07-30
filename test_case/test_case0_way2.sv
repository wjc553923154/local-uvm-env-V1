`ifndef TEST_CASE0_WAY2_SV
`define TEST_CASE0_WAY2_SV

class test_case0_way2_seq extends test_base_seqense;
  `uvm_object_utils(test_case0_way2_seq)
  test_rd_base_seq rd_seq;
  test_wr_base_seq wr_seq;
  int num_iterations = 10; // Number of iterations for the sequences

  // Constructor
  function new(string name = "test_case0_way2_seq");
    super.new(name);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "run_phase", UVM_LOW)
    // Start read sequence
    rd_seq = test_rd_base_seq::type_id::create("rd_seq");
    // Start write sequence
    wr_seq = test_wr_base_seq::type_id::create("wr_seq");

    if(!this.randomize()) begin
      `uvm_fatal(get_type_name(), "Randomization failed")
    end

    for(int i=0; i<num_iterations; i++) begin
      automatic int j = i;
      `uvm_info(get_type_name(), $sformatf("Iteration %0d", j), UVM_LOW)
            if(!rd_seq.randomize()) begin
        `uvm_fatal(get_type_name(), "Read sequence randomization failed")
      end
      rd_seq.start(p_sequencer);
      if(rd_seq.get_status()!=UVM_SEQ_DONE) begin
        `uvm_error(get_type_name(), "Read sequence did not complete successfully")
      end
      if(!wr_seq.randomize()) begin
        `uvm_fatal(get_type_name(), "Write sequence randomization failed")
      end
      wr_seq.start(p_sequencer);
      if(wr_seq.get_status()!=UVM_SEQ_DONE) begin
        `uvm_error(get_type_name(), "Write sequence did not complete successfully")
      end
    end
    `uvm_info(get_type_name(), "All sequences completed successfully", UVM_LOW)
    phase.drop_objection(this);
    endtask : run_phase 
endclass : test_case0_way2_seq

class test_case0_way2 extends test_base_test;
  `uvm_component_utils(test_case0_way2)
  test_case0_way2_seq seq;

  // Constructor
  function new(string name = "test_case0_way2");
    super.new(name);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)
    seq = test_case0_way2_seq::type_id::create("seq");
    seq.start(p_sequencer);
    if(seq.get_status() != UVM_SEQ_DONE) begin
      `uvm_error(get_type_name(), "Sequence did not complete successfully")
    end 
    `uvm_info(get_type_name(), "Sequence completed successfully", UVM_LOW)
  endfunction : build_phase
`endif // TEST_CASE0_WAY2_SV