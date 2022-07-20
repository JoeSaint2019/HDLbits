module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    //second
    always@(posedge clk) begin
        if (reset|| (ena && ss==8'h59))
            ss <= 8'h00;
        else if (ena)
            begin
                if (ss[3:0]==4'h9)
                    ss <= {ss[7:4]+1,4'h0};
                else
                    ss[3:0] <= ss[3:0]+1;
            end
    end
    //minute
    always@(posedge clk) begin
        if (reset|| (ena && mm==8'h59 && ss==8'h59))
            mm <= 8'h00;
        else if (ena && ss==8'h59)
            begin
                if (mm[3:0]==4'h9)
                    mm <= {mm[7:4]+1,4'h0};
                else
                    mm[3:0] <= mm[3:0]+1;
            end
    end
    //hour
    always@(posedge clk) begin
        if (reset)
            hh <= 8'h12;
        else if (ena && hh==8'h12 &&mm==8'h59 && ss==8'h59)
            hh <= 8'h01;
        else if (ena && mm==8'h59 && ss==8'h59)
            begin
                if (hh[3:0]==4'h9)
                    hh <= {hh[7:4]+1,4'h0};
                else
                    hh[3:0] <= hh[3:0]+1;
            end
    end
    //pm
    always@(posedge clk) begin
        if (reset)
            pm <= 1'b0;
        else if (ena && hh==8'h11 &&mm==8'h59 && ss==8'h59)
            pm <= ~pm;
    end
endmodule

