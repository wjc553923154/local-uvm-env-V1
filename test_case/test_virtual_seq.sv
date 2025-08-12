`ifndef  TEST_VIRTUAL_SEQ_SV
`define TEST_VIRTUAL_SEQ_SV

class test_virtual_seq extends test_base_test;
    test_virtual_sequencer  virt_sqr;
    test_env env;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        virt_sqr = test_virtual_sequencer::type_id::create("virt_sqr", this);
        env = test_env::type_id::create("env", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        virt_sqr.wr_sqr = env.wr_agt.sequencer;
        virt_sqr.rd_sqr = env.rd_agt.sequencer;
    endfunction

    task run_phase(uvm_phase phase);
        test_virtual_seq vseq;
        vseq = test_virtual_seq::type_id::create("vseq");
        vseq.start(virt_sqr);  
    endtask
endclass