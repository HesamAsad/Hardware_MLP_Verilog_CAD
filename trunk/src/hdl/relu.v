module relu (
    input[20:0] in,
    output[7:0] out
);
    wire[20:0] in_sat;
    assign in_sat = (in[19:0] > 127) ? 7'd127 : in; 
    assign out = in[20] ? 8'd0 : {in[20], in_sat[6:0]};
endmodule

module relu_tb;

    reg[20:0] in = 21'd3;
    wire[7:0] out;
    relu u1(in, out);
    initial begin
        #50 in = {1'b1, 20'd3};
        #50 in = 21'd32000;
        #50 $stop;
    end

endmodule
