`ifndef TEST_TRANSACTION_SV
`define TEST_TRANSACTION_SV 


class test_transaction extends uvm_sequence_item;
    `uvm_object_utils(test_transaction)  // Register with factory

    //-------------------
    // AXI4 Common Signals
    //-------------------
    rand axi_op_t                       op;          // Operation type (READ/WRITE)
    rand bit [`ADDR_WIDTH-1:0]          addr;        // Address (32-bit)
    rand axi_burst_t                    burst;       // Burst type (FIXED/INCR/WRAP)
    rand int                            len;         // Burst length (AXI3: 1-16, AXI4: 1-256)
    rand int                            size;        // Bytes per transfer (1,2,4,8,...)
    rand bit [3:0]                      id;          // Transaction ID
    rand bit [2:0]                      prot;        // Protection type
    rand bit [3:0]                      os;         // QoS identifier
    rand bit [`DATA_WIDTH-1:0]          data[];      // Data array (dynamic size)
    rand bit [(`DATA_WIDTH/8)-1:0]      strb[];      // Byte strobes (1-to-1 with data)
    bit                                 resp;        // Response (OKAY/EXOKAY/SLVERR/DECERR)

    `uvm_object_param_utils(test_transaction)
        `uvm_field_enum(axi_op_t, op, UVM_DEFAULT)
        `uvm_field_int(addr, UVM_DEFAULT | UVM_HEX)
        `uvm_field_enum(axi_burst_t, burst, UVM_DEFAULT)
        `uvm_field_int(len, UVM_DEFAULT)
        `uvm_field_int(size, UVM_DEFAULT)
        `uvm_field_int(id, UVM_DEFAULT)
        `uvm_field_int(prot, UVM_DEFAULT)
        `uvm_field_int(qos, UVM_DEFAULT)
        `uvm_field_array_int(data, UVM_DEFAULT | UVM_HEX)
        `uvm_field_array_int(strb, UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(resp, UVM_DEFAULT)
    `uvm_object_utils_end


    // Constraints
    constraint c_valid {
        len  inside {[0:255]};         // AXI4 supports max 256 beats
        size inside {1,2,4,8};         // Valid transfer sizes
        burst != AXI_BURST_RESERVED;   // Exclude reserved values
        data.size() == len + 1;        // Data array size matches burst length
        strb.size() == len + 1;        // Strobes size matches data size
    }

    //-------------------
    // Constructor
    //-------------------
    function new(string name = "test_transaction");
        super.new(name);
    endfunction

    //-------------------
    // Field printing (for debugging)
    //-------------------
    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_string("op", op.name());
        printer.print_field("addr", addr, 32, UVM_HEX);
        printer.print_string("burst", burst.name());
        printer.print_field("len", len, 8);
        printer.print_field("size", size, 4);
        printer.print_field("id", id, 4);
        printer.print_field("resp", resp, 2);
    endfunction

    //-------------------
    // Deep copy implementation
    //-------------------
    function void do_copy(uvm_object rhs);
        test_transaction tx;
        if (!$cast(tx, rhs)) begin
            `uvm_error("COPY_ERR", "Type mismatch in copy")
            return;
        end
        super.do_copy(rhs);
        this.op    = tx.op;
        this.addr  = tx.addr;
        this.burst = tx.burst;
        this.len   = tx.len;
        this.size  = tx.size;
        this.id    = tx.id;
        this.prot  = tx.prot;
        this.qos   = tx.qos;
        this.resp  = tx.resp;
        this.data  = new[tx.data.size()];
        this.strb  = new[tx.strb.size()];
        foreach (tx.data[i]) begin
            this.data[i] = tx.data[i];
            this.strb[i] = tx.strb[i];
        end
    endfunction
endclass