`include "../tb/param.v"

module  controller (
    input logic clk,
    input logic rst_n,
    input logic start,
    output logic done
);

    // Internal signals
    logic [31:0] counter;

    // Sequential logic for counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            done <= 0;
        end else if (start) begin
            counter <= counter + 1;
            if (counter == `WITDTH - 1) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end
    // Reset logic

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 0;
        end else if (start && counter == `WITDTH - 1) begin
            done <= 1;
        end
    end

    // Output logic
    always_comb begin
        if (done) begin
            // Logic when done
        end else begin
            // Logic when not done
        end
    end
    
endmodule