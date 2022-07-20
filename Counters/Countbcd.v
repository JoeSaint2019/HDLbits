module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
  
    assign ena[1] = q[3:0]==4'h9;
    assign ena[2] = q[7:4]==4'h9&&ena[1];
    assign ena[3] = q[11:8]==4'h9&&ena[2]&&ena[1];
    bcd bcd0(clk, reset, 1'b1, q[3:0]);
    bcd bcd1(clk, reset, ena[1], q[7:4]);
    bcd bcd2(clk, reset, ena[2], q[11:8]);
    bcd bcd3(clk, reset, ena[3], q[15:12]);
endmodule

module bcd (
    input clk,
    input reset,
    input ena,
    output [3:0] q);
  
    always@(posedge clk) begin
        if (reset==1'b1)
            q<=0;
        else if (ena && q==4'h9)
            q<=0;
        else if (ena)
            q<=q+1;
    end
endmodule
