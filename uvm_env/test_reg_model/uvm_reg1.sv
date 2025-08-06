`ifndef UVM_REG1_SV
`define UVM_REG1_SV
class uvm_reg1 extends uvm_reg;
  `uvm_object_utils(uvm_reg1)
  
  rand uvm_reg_field field1; 
  rand uvm_reg_field field2;  
  
  function new(string name = "uvm_reg1");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction
  
  virtual function void build();

    field1 = uvm_reg_field::type_id::create("field1");
    field2 = uvm_reg_field::type_id::create("field2");
    

    field1.configure(this, 16, 0,  "RW", 0, 16'h0, 1, 1, 1);
    add_hdl_path_slice("top.dut.reg1.field1", 0, 8);
    field2.configure(this, 16, 16, "RO", 0, 16'h0, 1, 1, 1);
    add_hdl_path_slice("top.dut.reg1.field2", 0, 8);
  endfunction
endclass
`endif // UVM_REG1_SV