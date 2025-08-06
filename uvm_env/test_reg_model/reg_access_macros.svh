`ifndef REG_ACCESS_MACROS_SVH
`define REG_ACCESS_MACROS_SVH


`define REG_WRITE(REG_PATH, VALUE, PATH=UVM_FRONTDOOR) \
    begin \
        uvm_status_e status; \
        REG_PATH.write(status, VALUE, .path(PATH)); \
        if (status != UVM_IS_OK) begin \
            `uvm_error("REG_ACCESS", $sformatf("Write failed to %0s", `"REG_PATH`")) \
        end \
    end


`define REG_READ(REG_PATH, VALUE, PATH=UVM_FRONTDOOR) \
    begin \
        uvm_status_e status; \
        REG_PATH.read(status, VALUE, .path(PATH)); \
        if (status != UVM_IS_OK) begin \
            `uvm_error("REG_ACCESS", $sformatf("Read failed from %0s", `"REG_PATH`")) \
        end \
    end

`endif // REG_ACCESS_MACROS_SVH