module mult (
    input[7:0] in1, in2,
    output[14:0] out
);
    wire[13:0] res;
    assign res = in1[6:0] * in2[6:0];
    assign out = {in1[7]^in2[7] ? 1'b1 : 1'b0, res};
endmodule

module multtb;
    reg[7:0] in1 = 8'd2, in2 = 8'd4;
    wire[14:0] out;
    mult u1(in1, in2, out);
    initial begin
        #50 in1 = {1'b1, 7'd2};
        #50 in2 = {1'b1, 7'd4};
        #50 $stop;
    end
endmodule
