module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); 
	
	// state defines
	localparam WAIT = 0;
	localparam FIND_HEAD = 1;
	localparam COUNT2 = 2;
	localparam COUNT3 = 3;
	reg [1:0] state, next_state;
	reg [7:0] shifter[3];
	reg en;
    // State transition logic (combinational)
	always @(*)begin
		case(state)
			WAIT: if (in[3])begin
					next_state = FIND_HEAD;
					en = 1'b1;
					end
				  else begin
				    next_state = WAIT;
					en = 1'b0;
					end
			FIND_HEAD: next_state = COUNT2;
			COUNT2: next_state = COUNT3;
			COUNT3: if (in[3])begin
						next_state = FIND_HEAD;
						en = 1'b1;
						end
					else begin
						next_state = WAIT;
						en = 1'b0;
					    end
            default: en = 1'b0;
		endcase
	end
    // State flip-flops (sequential)
	always @(posedge clk)begin
		if(reset)
			state <= WAIT;
		else
			state <= next_state;
	end
	// shifter
	always@(posedge clk)begin
		if(en)begin
			shifter[2] <= in;
			shifter[1] <= shifter[2];
			shifter[0] <= shifter[1];
			end
	end
    // Output logic
	assign done = state == COUNT3;
	assign out_bytes = {shifter[0],shifter[1],shifter[2]};
endmodule

