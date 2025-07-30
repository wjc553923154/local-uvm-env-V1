`ifndef TEST_CASE0_WAY1_SV
`define TEST_CASE0_WAY1_SV  

class test_case0_way1 extends test_base_test;
  `uvm_component_utils(test_case0_way1)
  test_rd_base_seq rd_seq;
  test_wr_base_seq wr_seq;
  int num_iterations = 10; // Number of iterations for the sequences

  // Constructor
  function new(string name = "test_case0_way1");
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
    if(!this.randomize()) begin
      `uvm_fatal(get_type_name(), "Randomization failed")
    end
    // Get the sequencer from the test base class
    // Start read sequence
    rd_seq = test_rd_base_seq::type_id::create("rd_seq");
    // Start write sequence
    wr_seq = test_wr_base_seq::type_id::create("wr_seq");

    `REG_WRITE.write(status, 32'h12345678);
    `REG_READ.read(status, data);
    `REG_WRITE(env.reg_model.reg1.field1, 8'hFF, UVM_BACKDOOR);

    for(int i=0;i<num_iterations;i++) begin
      automatic intj=i ;
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

      for(int i=0;i<num_iterations;i++) begin
        automatic int j = i;
        `uvm_info(get_type_name(), $sformatf("Iteration %0d", j), UVM_LOW)
        fork
            begin
              rd_seq.start_with(sequencer=p_sequencer,trans_cnt=5, idle_cycles=1, start_addr=32'h00000000, wait_rsp=0);
              `uvm_info(get_type_name(), $sformatf("Read sequence started",) UVM_LOW)
            end
            begin
              wr_seq.start_with(sequencer=p_sequencer,trans_cnt=5, idle_cycles=1, start_addr=32'h00000000, wait_rsp=0);
             `uvm_info(get_type_name(), $sformatf("Write sequence started",) UVM_LOW)
            end    
        join_none
      end
      wait fork;
      `uvm_info(get_type_name(), "All sequences completed", UVM_LOW)
    end
