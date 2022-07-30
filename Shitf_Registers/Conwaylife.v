module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 
 
    //padding
    wire [323:0] pq;    //padded q
    integer row;
    always @(*) begin
        {pq[0], pq[17], pq[306],pq[323]} = {q[255], q[240], q[15],q[0]}; // 4 corners
        {pq[16:1], pq[322:307]} = {q[255:240], q[15:0]}; // up and down side
        for (row = 0; row < 16; row ++) begin
            {pq[18*row+18], pq[18*row+35]} = {q[16*row+15], q[16*row]}; // left and right side
            pq[18*row+19 +: 16] = q[16*row +: 16]; // core
        end
    end
    
    //add calc
    integer r; // rows
    integer c; // columns
    integer m; // loc in 18*18 (pq)
    integer l; // loc in 16*16 (sum & q & qn)
    reg [3:0] sum [255:0]; // calc neighbours save in sum
    reg [255:0] qn; //next state
    always @(*) begin
        for (r = 0; r < 16; r++) begin
            for (c = 0; c < 16; c++) begin
                m = 18*r + c + 19;
                l = 16*r +c;
                            sum[l] = pq[m-19] + pq[m-18] + pq[m-17] + pq[m-1] + pq[m+1] + pq[m+17] + pq[m+18] + pq[m+19];
                qn[l] = (sum[l] < 4'd2)?(1'b0):((sum[l] < 4'd3)?(q[l]):((sum[l] < 4'd4)?(1'b1):(1'b0))); //conways rule
            end
        end
    end
    
    // state 
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= qn;
    end
    
endmodule
                
                
