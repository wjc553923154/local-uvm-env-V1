`timescale 1ps/1ps

`include "./param.sv"
module tb_dut;

    // Parameters



    // Signals
    logic clk;
    logic rst_n;
    logic [7:0] data_in;
    logic [7:0] data_out;

    // Instantiate the DUT
    dut #(
        .DUT_PARAM(DUT_PARAM)
    ) dut_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(`CLK_PERIOD / 2) clk = ~clk;
    end

    // Reset generation
    initial begin
        rst_n = 0;
        #(CLK_PERIOD * 2);
        rst_n = 1;
    end

    // Testbench stimulus
    initial begin
        // Initialize inputs
        data_in = 8'h00;

        // Wait for reset
        @(posedge rst_n);
        // Wait for some time
        #(CLK_PERIOD * 100);
        // Apply test vectors
        @(posedge clk);
        data_in = 8'hA5; // Example input
        @(posedge clk);
        data_in = 8'h5A; // Another example input

        // Wait for some time to observe outputs
        #(CLK_PERIOD * 100);
        // Finish simulation
        $finish;
    end
    ////NTDO check  where is the monitor need to do ???
    // Monitor outputs
    initial begin
        $monitor("Time: %0t | clk: %b | rst_n: %b | data_in: %h | data_out: %h",
                 $time, clk, rst_n, data_in, data_out);
    end
    ////NTDO check  where is the dump wave  need to do ???
    // Dump waveform
    initial begin
        $dumpfile("tb_dut.vcd");
        $dumpvars(0, tb_dut);
    end
endmodule