module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q); 
  
    singleFF f0(clk, areset, load, ena, data[0], q[1], q[0]);
    singleFF f1(clk, areset, load, ena, data[1], q[2], q[1]);
    singleFF f2(clk, areset, load, ena, data[2], q[3], q[2]);
    singleFF f3(clk, areset, load, ena, data[3], 1'b0, q[3]);

endmodule


module singleFF(
    input clk,
    input areset,
    input load,
    input ena,
    input d,
    input enad,
    output q);
  
    always@(posedge clk or posedge areset) begin
        if (areset)
            q <= 0;
        else if (load)
            q <= d;
        else if (ena)
            q <= enad;
    end
  
endmodule
