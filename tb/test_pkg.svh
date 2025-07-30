import uvm_pkg::*;
import axi_defs_pkg::*;
`include "uvm_macros.svh"
`include "../uvm_env/test_reg_model/reg_access_macros.svh"

`include "../interface/test_interface.sv"

`include "../obj/test_config.sv"
`include "../obj/test_transaction.sv"
//include seqs


`include "../uvm_env/compoment/test_driver.sv"
`include "../uvm_env/compoment/test_monitor.sv"
`include "../uvm_env/compoment/test_sequencer.sv"
`include "../uvm_env/compoment/test_agent.sv"

`include "../uvm_env/compoment/test_ref_model.sv"
`include "../uvm_env/compoment/test_scoreboard.sv"
`include "../uvm_env/compoment/test_env.sv" 
`include "../uvm_env/compoment/test_base_test.sv"

`include "../obj/sequence_lib/test_base_seqense.sv"
`include "../obj/sequence_lib/test_sequencer_lib.sv"
`include "../obj/sequence_lib/test_rd_base_seq.sv"
`include "../obj/sequence_lib/test_wr_base_seq.sv"

`include "../uvm_env/test_reg_model/uvm_reg0.sv"
`include "../uvm_env/test_reg_model/uvm_reg1.sv"
`include "../uvm_env/test_reg_model/uvm_reg_block0.sv" 
`include "../uvm_env/test_reg_model/uvm_reg_model.sv"
`include "../uvm_env/test_reg_model/reg_adapter.sv"
`include "../uvm_env/test_reg_model/reg_predictor.sv"



`include "../test_case/test_case1_seq_lib.sv"
`include "../test_case/test_case0_way1.sv "
`include "../test_case/test_case0_way2.sv"

//inclde testcase




