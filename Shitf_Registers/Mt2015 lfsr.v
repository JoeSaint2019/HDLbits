module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR);  // Q
    wire clk;
    assign clk = KEY[0];
    sub_f f0(clk, KEY[1], LEDR[2], SW[0], LEDR[0]);
    sub_f f1(clk, KEY[1], LEDR[0], SW[1], LEDR[1]);
    sub_f f2(clk, KEY[1], LEDR[2]^LEDR[1], SW[2], LEDR[2]);
endmodule

module sub_f (
	input clk,
	input sel,
	input val0,
	input val1,
	output Q);
	wire d;
    assign d = sel&val1||~sel&val0;
    always@(posedge clk)begin
        Q <= d;
    end
endmodule
