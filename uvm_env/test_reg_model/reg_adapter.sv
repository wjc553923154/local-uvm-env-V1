`ifdef REG_ADAPTER_SV
`define REG_ADAPTER_SV

class reg_adapter extends uvm_reg_adapter;
  `uvm_object_utils(reg_adapter)
  
  function new(string name = "reg_adapter");
    super.new(name);
  endfunction
  
  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    test_transaction tr = test_transaction::type_id::create("tr");
    tr.kind = (rw.kind == READ) ? READ : WRITE;
    tr.addr = {rw.addr[31:2], 2'b00};
    tr.data = rw.data;
    return tr;
  endfunction
  
  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    test_transaction tr;
    if (!$cast(tr, bus_item)) begin
      `uvm_fatal("CASTFAIL", "Failed to cast bus_item to test_transaction")
      return;
    end
    rw.kind = (tr.kind == READ) ? READ : WRITE;
    rw.addr = {rw.addr[31:2], 2'b00};
    rw.data = tr.data;
    rw.status = UVM_IS_OK;
  endfunction
endclass
`endif // REG_ADAPTER_SV