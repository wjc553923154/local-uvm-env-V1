`ifndef TEST_RD_BASE_SEQ_SV
`define TEST_RD_BASE_SEQ_SV
// File: test_rd_base_seq.sv
// Description: This file defines the base sequence class for the UVM environment
class test_rd_base_seq extends uvm_sequence #(test_transaction);
  `uvm_object_utils(test_rd_base_seq)

  // Configuration object
  test_cfg cfg;
  rand bit [`ADDR_WIDTH-1:0]    start_addr;
  rand int                      trans_cnt;
  rand int                      idle_cycles;
  bit                           wait_rsp = 1;
  // Constraints
  constraint valid_cfg {
    trans_cnt inside {[1:100]};
    idle_cycles inside {[0:20]};
  }
  // Constructor
  function new(string name = "test_rd_base_seq");
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
  endfunction : build_phase

  // Body task
  virtual task body();
    `uvm_info(get_type_name(), "body", UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Starting address: %0h, Transaction count: %0d, Idle cycles: %0d",
    // Create a test transaction
    repeat(trans_cnt)begin
        test_transaction tr = test_transaction::type_id::create("tr");
        tr.op = AXI_READ; // Set operation type to READ
        if(!tr.randomize()with{
            addr==start_addr;
            delay==idle_cycles;
        }) begin
        `uvm_fatal(get_type_name(), "Transaction randomization failed")
        end
        start_item(tr);
        finish_item(tr);
        if(wait_rsp) get_response(item);
        start_addr += 4; // Increment address for next transaction
        `uvm_info(get_type_name(), $sformatf("Transaction sent: addr=%0h, data=%0h", tr.addr, tr.data), UVM_LOW)
    end
  endtask : body

  task static start_with(
    uvm_sequencer_base  sequencer,
    int trans_cnt = 10,
    int idle_cycles = 0,
    bit [31:0] start_addr = 32'h00000000,
    test_cfg cfg = null,
    bit wait_rsp = 1
  );
    test_rd_base_seq seq = test_rd_base_seq::type_id::create("seq");
    seq.cfg = cfg;
    seq.wait_rsp = wait_rsp;
    seq.trans_cnt =trans_cnt;
    seq.start_addr = start_addr;
    seq.idle_cycles= idle_cycles;
    seq.start(sequencer,parent);
  );
  endtask : start_with
endclass : test_rd_base_seq
`endif // TEST_RD_BASE_SEQ_SV
