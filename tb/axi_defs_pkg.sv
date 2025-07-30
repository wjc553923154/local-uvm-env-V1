package axi_defs_pkg;
    // AXI operation type enum
    typedef enum {
        AXI_READ,
        AXI_WRITE
    } axi_op_t;

    // AXI burst type enum
    typedef enum {
        AXI_BURST_FIXED,
        AXI_BURST_INCR,
        AXI_BURST_WRAP,
        AXI_BURST_RESERVED
    } axi_burst_t;
    // AXI response type enum
  typedef enum {
    BASE_RD,
    BASE_WR,
    RAND_RD,
    ERR_INJ
  } seq_type_t;
    
 typedef enum {
    NO_ERROR,
    TIMEOUT_ERROR,
    CHECKSUM_ERROR,
    PROTOCOL_ERROR
  } error_type_e;
endpackage : axi_defs_pkg