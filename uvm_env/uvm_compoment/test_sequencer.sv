`ifndef TEST_SEQUENCER_SV
`define TEST_SEQUENCER_SV

// File: test_sequencer.sv
// Description: This file defines the test_sequencer component for the UVM environment.

class test_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(test_sequencer)
  // Constructor
  function new(string name = "sequencer");
    super.new(name);
  endfunction

  function void test_sequencer::build();
	super.build();
	`uvm_info(get_type_name(), "built", UVM_LOW)
endfunction : build

//NTD : confirm it neccessary
//   // Function to start a sequence
//   virtual function void start_sequence(uvm_sequence seq);
//     `uvm_info("SEQUENCER", $sformatf("Starting sequence: %s", seq.get_name()), UVM_MEDIUM)
//     seq.start(this);
//   endfunction

//   // Function to stop a sequence
//   virtual function void stop_sequence(uvm_sequence seq);
//     `uvm_info("SEQUENCER", $sformatf("Stopping sequence: %s", seq.get_name()), UVM_MEDIUM)
//     seq.stop();
//   endfunction
  
  endclass : test_sequencer
`endif // TEST_SEQUENCER_SV


















