`ifndef UVM_REG_BLOCK_SV
`define UVM_REG_BLOCK_SV    

class uvm_reg_block0 extends uvm_reg_block;
  `uvm_object_utils(uvm_reg_block0)
  
  rand uvm_reg0 reg0;
  rand uvm_reg1 reg1;
  uvm_reg_map default_map;
  
  function new(string name = "uvm_reg_block0");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
  
  virtual function void build();

    reg0 = my_register::type_id::create("reg0");
    reg1 = my_register::type_id::create("reg1");
    

    reg0.configure(this, null, "");
    reg0.build();
    reg0.add_hdl_path_slice("reg0", 0, 32);
    
    reg1.configure(this, null, "");
    reg1.build();
    reg1.add_hdl_path_slice("reg1", 0, 32);
    

    default_map = create_map("default_map", 'h0, 4, UVM_LITTLE_ENDIAN);
    
    
    default_map.add_reg(reg0, 'h0000, "RW");
    default_map.add_reg(reg1, 'h0004, "RW");
    

    lock_model();
  endfunction
endclass
`endif // UVM_REG_BLOCK_SV