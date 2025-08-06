`ifndef REGG_PREDICTOR_SV
`define REGG_PREDICTOR_SV

class reg_predictor extends uvm_reg_predictor #(my_transaction);
  `uvm_component_utils(reg_predictor)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
`endif // REGG_PREDICTOR_SV