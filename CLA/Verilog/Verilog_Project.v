module d_flip_flop_tspc (
    input wire D,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        Q <= D;
    end
endmodule

module cla_4bit (
    input wire [3:0] A, B,
    input wire Cin,
    output wire [3:0] S,
    output wire Cout
);
    wire [3:0] G;  // Generate terms
    wire [3:0] P;  // Propagate terms
    wire [4:0] C;  // Carry terms

    assign G = A & B;          // Generate term: Gi = Ai & Bi
    assign P = A ^ B;          // Propagate term: Pi = Ai ^ Bi
    assign C[0] = Cin;         // Initial carry-in

    // Carry logic
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    // Sum logic
    assign S=P^C;

    // Final carry-out
    assign Cout = C[4];
endmodule

module cla_4bit_with_dff (
    input wire [3:0] A, B,
    input wire Cin,
    input wire clk,
    output wire [3:0] S,
    output wire Cout
);
    wire [3:0] A_reg, B_reg;
    wire Cin_reg;
    wire [3:0] S_reg;
    wire Cout_reg;

    // Instantiate D flip-flops for inputs
    d_flip_flop_tspc dff_A0 (.D(A[0]), .clk(clk), .Q(A_reg[0]));
    d_flip_flop_tspc dff_A1 (.D(A[1]), .clk(clk), .Q(A_reg[1]));
    d_flip_flop_tspc dff_A2 (.D(A[2]), .clk(clk), .Q(A_reg[2]));
    d_flip_flop_tspc dff_A3 (.D(A[3]), .clk(clk), .Q(A_reg[3]));

    d_flip_flop_tspc dff_B0 (.D(B[0]), .clk(clk), .Q(B_reg[0]));
    d_flip_flop_tspc dff_B1 (.D(B[1]), .clk(clk), .Q(B_reg[1]));
    d_flip_flop_tspc dff_B2 (.D(B[2]), .clk(clk), .Q(B_reg[2]));
    d_flip_flop_tspc dff_B3 (.D(B[3]), .clk(clk), .Q(B_reg[3]));

    d_flip_flop_tspc dff_Cin (.D(Cin), .clk(clk), .Q(Cin_reg));

    // Instantiate the CLA adder
    cla_4bit cla_inst (
        .A(A_reg),
        .B(B_reg),
        .Cin(Cin_reg),
        .S(S_reg),
        .Cout(Cout_reg)
    );

    // Instantiate D flip-flops for outputs
    d_flip_flop_tspc dff_S0 (.D(S_reg[0]), .clk(clk), .Q(S[0]));
    d_flip_flop_tspc dff_S1 (.D(S_reg[1]), .clk(clk), .Q(S[1]));
    d_flip_flop_tspc dff_S2 (.D(S_reg[2]), .clk(clk), .Q(S[2]));
    d_flip_flop_tspc dff_S3 (.D(S_reg[3]), .clk(clk), .Q(S[3]));

    d_flip_flop_tspc dff_Cout (.D(Cout_reg), .clk(clk), .Q(Cout));
endmodule
