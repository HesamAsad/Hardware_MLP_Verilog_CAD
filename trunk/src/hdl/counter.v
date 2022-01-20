module counter (
    input clk, rst, cnt, 
    output reg[4:0] out
);

    reg co;
    always @(posedge clk or posedge rst) begin
        if(rst)
            out <= 5'd0;
        else if(cnt)
            {co, out} <= out+1'b1;
        else 
            out <= out;
    end

endmodule
