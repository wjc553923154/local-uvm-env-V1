`ifndef REG_FIELD0_SV
`define REG_FIELD0_SV

class reg_field0 extends uvm_reg_field;

  `uvm_object_utils(reg_field)

  // Constructor
  function new(string name, uvm_reg parent, int unsigned lsb, int unsigned width);
    super.new(name, parent, lsb, width);
  endfunction

virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("field_name", this.get_name());
    printer.print_field("field_lsb", this.get_lsb());
    printer.print_field("field_width", this.get_n_bits());
  endfunction

endclass : reg_field0
`endif // REG_FIELD0_SV