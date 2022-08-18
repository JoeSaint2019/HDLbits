module top_module(
    input clk,
    input areset,    // FALL_RIGHTeshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
 	
    // state registers
    reg [2:0] state, next_state;
    reg [7:0] g_Count;
    // state defines
    localparam WALK_RIGHT = 3'b000;
    localparam WALK_LEFT  = 3'b001;
	localparam FALL_RIGHT = 3'b011;
	localparam FALL_LEFT  = 3'b010;
	localparam DIG_RIGHT  = 3'b101;
	localparam DIG_LEFT   = 3'b100;
	localparam SLPAT      = 3'b111;
    // state transfer logic
    always @(*)begin
        case(state)
            WALK_RIGHT: begin
						if(ground == 1'b0)  
							next_state = FALL_RIGHT;
						else if(dig == 1'b1) 
							next_state = DIG_RIGHT;
						else 
							next_state = bump_right ? WALK_LEFT : WALK_RIGHT;
						end
						
            WALK_LEFT: begin
						if(ground == 1'b0)  
							next_state = FALL_LEFT;
						else if(dig == 1'b1) 
							next_state = DIG_LEFT;
						else 
							next_state = bump_left ? WALK_RIGHT : WALK_LEFT;
						end
						
            FALL_RIGHT: begin
						if(ground == 1'b1 && g_Count > 20)
							next_state = SLPAT;
						else if(ground == 1'b1) 
							next_state = WALK_RIGHT;
						else 
							next_state =  FALL_RIGHT;
						end
						
            FALL_LEFT: begin
					   if(ground == 1'b1 && g_Count > 20) 
							next_state = SLPAT;
					   else if(ground == 1'b1) 
							next_state = WALK_LEFT;
					   else 
							next_state = FALL_LEFT;
					   end
					   
            DIG_LEFT:  next_state = ground ? DIG_LEFT : FALL_LEFT;
			
            DIG_RIGHT:  next_state = ground ? DIG_RIGHT : FALL_RIGHT;
			
            SLPAT:  next_state = SLPAT;
			default: next_state = WALK_LEFT;
        endcase
    end
    // falling counters
    always @(posedge clk, posedge areset)begin
        if (areset)
            g_Count <= 0;
	    else if (next_state == FALL_RIGHT || next_state == FALL_LEFT)  // 必须采用next_state，否则计数器的值和实际值相差1
            g_Count <= g_Count + 1;  // count +1 while still falling
        else
            g_Count <= 0;
    end
    // state transfer
    always@(posedge clk, posedge areset)begin
        if(areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end
    // output assign
    assign aaah = (state == FALL_RIGHT | state == FALL_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign walk_left = (state == WALK_LEFT);
    assign digging = (state == DIG_RIGHT | state == DIG_LEFT);
    
endmodule
