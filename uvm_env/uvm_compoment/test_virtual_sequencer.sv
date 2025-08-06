`ifndef TEST_VIRTUAL_SEQUENCER_SV
`define TEST_VIRTUAL_SEQUENCER_SV
class test_virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(test_virtual_sequencer)


    wr_sequencer    wr_sqr;
    rd_sequencer    rd_sqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass