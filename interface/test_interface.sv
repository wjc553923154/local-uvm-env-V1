`ifndef TEST_INTERFACE_SV
`define TEST_INTERFACE_SV
// File: test_interface.sv
// Description: This file defines the test_interface for the UVM environment
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../tb/param.v"
interface test_interface(input logic clk, input logic rst_n);
    // -------------------------
    // AXI Write Address Channel (AW)
    // -------------------------
    logic [`AXI_ID_WIDTH-1:0]   awid;     // Write address ID
    logic [`AXI_ADDR_WIDTH-1:0] awaddr;   // Write address
    logic [7:0]                 awlen;    // Burst length (number of transfers)
    logic [2:0]                 awsize;   // Burst size (bytes per transfer)
    logic [1:0]                 awburst;  // Burst type (e.g., INCR, FIXED)
    logic                       awvalid;  // Write address valid
    logic                       awready;  // Write address ready
    logic [`AXI_USER_WIDTH-1:0] awuser;   // Optional user signals

    // -------------------------
    // AXI Write Data Channel (W)
    // -------------------------
    logic [`AXI_DATA_WIDTH-1:0] wdata;    // Write data
    logic [`AXI_DATA_WIDTH/8-1:0] wstrb;  // Write strobes (byte enables)
    logic                       wlast;    // Last write transfer in burst
    logic                       wvalid;   // Write data valid
    logic                       wready;   // Write data ready
    logic [`AXI_USER_WIDTH-1:0] wuser;    // Optional user signals

    // -------------------------
    // AXI Write Response Channel (B)
    // -------------------------
    logic [`AXI_ID_WIDTH-1:0]   bid;      // Write response ID
    logic [1:0]                 bresp;    // Write response (e.g., OKAY, EXOKAY, SLVERR, DECERR)
    logic                       bvalid;   // Write response valid
    logic                       bready;   // Write response ready
    logic [`AXI_USER_WIDTH-1:0] buser;    // Optional user signals

    // -------------------------
    // AXI Read Address Channel (AR)
    // -------------------------
    logic [`AXI_ID_WIDTH-1:0]   arid;     // Read address ID
    logic [`AXI_ADDR_WIDTH-1:0] araddr;   // Read address
    logic [7:0]                 arlen;    // Burst length
    logic [2:0]                 arsize;   // Burst size
    logic [1:0]                 arburst;  // Burst type
    logic                       arvalid;  // Read address valid
    logic                       arready;  // Read address ready
    logic [`AXI_USER_WIDTH-1:0] aruser;   // Optional user signals

    // -------------------------
    // AXI Read Data Channel (R)
    // -------------------------
    logic [`AXI_ID_WIDTH-1:0]   rid;      // Read data ID
    logic [`AXI_DATA_WIDTH-1:0] rdata;    // Read data
    logic [1:0]                 rresp;    // Read response
    logic                       rlast;    // Last read transfer in burst
    logic                       rvalid;   // Read data valid
    logic                       rready;   // Read data ready
    logic [`AXI_USER_WIDTH-1:0] ruser;    // Optional user signals

    // -------------------------
    // Clocking Blocks (Synchronous Signal Control)
    // -------------------------
    // Master Driving Clocking Block
    clocking cb_master @(posedge clk);
        default input #1ps output #1ps;  // Default I/O timing
        // Write Address Channel
        output awid, awaddr, awlen, awsize, awburst, awvalid, awuser;
        input  awready;
        // Write Data Channel
        output wdata, wstrb, wlast, wvalid, wuser;
        input  wready;
        // Write Response Channel
        input  bid, bresp, bvalid, buser;
        output bready;
        // Read Address Channel
        output arid, araddr, arlen, arsize, arburst, arvalid, aruser;
        input  arready;
        // Read Data Channel
        input  rid, rdata, rresp, rlast, rvalid, ruser;
        output rready;
    endclocking

    // Slave Driving Clocking Block
    clocking cb_slave @(posedge clk);
        default input #1ps output #1ps;
        // Directions reversed from Master
        input  awid, awaddr, awlen, awsize, awburst, awvalid, awuser;
        output awready;
        input  wdata, wstrb, wlast, wvalid, wuser;
        output wready;
        output bid, bresp, bvalid, buser;
        input  bready;
        input  arid, araddr, arlen, arsize, arburst, arvalid, aruser;
        output arready;
        output rid, rdata, rresp, rlast, rvalid, ruser;
        input  rready;
    endclocking

        // -------------------------
    // Modports (Direction Control)
    // -------------------------
    modport master_mp(
        clocking cb_master,  // Master uses cb_master for signal control
        input    clk,        // Clock input
        input    rst_n       // Active-low reset
    );

    modport slave_mp(
        clocking cb_slave,   // Slave uses cb_slave for signal control
        input    clk,
        input    rst_n
    );
        // -------------------------
    // Signal Initialization
    // -------------------------
    initial begin
        // Initialize all signals to default values
        awid     = 0; awaddr = 0; awvalid = 0;
        wdata    = 0; wvalid = 0; wlast  = 0;
        bready   = 0;
        arid     = 0; araddr = 0; arvalid = 0;
        rready   = 0;
    end
    endinterface : test_interface
`endif // TEST_INTERFACE_SV