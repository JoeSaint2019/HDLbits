module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 
    reg [511:0] qnext;
    always @ (*) begin
        for(int i=1;i<511;i++)
            qnext[i] = q[i+1]^q[i-1];
        qnext[0] = q[1]^1'b0;
        qnext[511] = 1'b0^q[510];
    end
        
    always @ (posedge clk)begin
        if (load)
            q <= data;
        else 
            q <= qnext;
    end
endmodule
