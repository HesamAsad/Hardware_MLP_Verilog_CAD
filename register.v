module register #(parameter N = 8) (
    input clk, rst, ld, input[N-1:0] in,
    output[N-1:0] out
);
    reg[N-1:0] reg_out;
    always @(posedge clk or posedge rst) begin
        if(rst)
            reg_out <= {N{1'b0}};
        else if(ld)
            reg_out <= in;
        else 
            reg_out <= reg_out;
    end
    assign out = reg_out;

endmodule


module acc_register #(parameter N = 21) (
    input clk, rst, ld, acc, input[N-1:0] in,
    output[N-1:0] out
);
    reg[N-1:0] reg_out;
    wire[N-1:0] added;
    adder_21bit acc_adder(reg_out, in, added);
    always @(posedge clk or posedge rst) begin
        if(rst)
            reg_out <= {N{1'b0}};
        else if(acc)
            reg_out <= added;
        else if(ld)
            reg_out <= in;
        else 
            reg_out <= reg_out;
    end
    assign out = reg_out;
    
endmodule

