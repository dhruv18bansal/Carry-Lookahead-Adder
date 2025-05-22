`include "Verilog_Project.v"
module tb_cla_4bit_with_dff;
    reg [3:0] A, B;
    reg Cin;
    reg clk;
    wire [3:0] S;
    wire Cout;

    // Instantiate the DUT (Device Under Test)
    cla_4bit_with_dff dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .clk(clk),
        .S(S),
        .Cout(Cout)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Test stimulus
    initial begin
        $dumpfile("tb_cla_4bit_with_dff.vcd");
        $dumpvars(0,tb_cla_4bit_with_dff);
        // Monitor outputs
        $monitor("Time=%0t | A=%b, B=%b, Cin=%b | S=%b, Cout=%b", $time, A, B, Cin, S, Cout);

        // Initialize inputs
        A = 4'b0101; B = 4'b1010; Cin = 1'b0;
        #10;
        A = 4'b1001; B = 4'b1101;
        #20;

        // Finish simulation
        $finish;
    end
endmodule
