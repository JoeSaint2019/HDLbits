module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q); 
    always @(posedge clk)begin
        if(load)begin
            q <= data;
        end
        else if(ena) begin
            case(amount)
                2'b00:   q <= {q[62:0],1'b0}; //算术左移和逻辑左移一样，不过因为位数原因溢出截断了
                2'b01:   q <= {q[55:0], 8'b0};
                2'b10:   q <= {q[63],q[63:1]};//有符号数右移动  如果符号位为1，则右移后是补1；如果符号位为0，则右移后是补0
                2'b11:   q <= { { 8{q[63]} },q[63:8]};
            endcase
        end
        else q <= q;
    end

endmodule
