`ifndef  TEST_VIRTUAL_SEQ_SV
`define TEST_VIRTUAL_SEQ_SV

class test_virtual_seq extends test_base_test;
    test_virtual_sequencer  virt_sqr;
    wr_agent             wr_agt;
    apb_agent             rd_agt;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        virt_sqr = test_virtual_sequencer::type_id::create("virt_sqr", this);
        wr_agt   = wr_agent::type_id::create("wr_agt", this);
        rd_agt   = rd_agent::type_id::create("rd_agt", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        // 将物理Sequencer连接到Virtual Sequencer
        virt_sqr.wr_agt = wr_agt.sequencer;
        virt_sqr.rd_agt = rd_agt.sequencer;
    endfunction

    task run_phase(uvm_phase phase);
        test_virtual_seq vseq;
        vseq = test_virtual_seq::type_id::create("vseq");
        vseq.start(virt_sqr);  
    endtask
endclass