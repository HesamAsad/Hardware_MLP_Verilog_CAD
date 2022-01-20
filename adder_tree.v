module adder_tree (
    input[14:0] in1,in2, in3,in4, in5,in6, in7,in8,
    output[20:0] out
);
    wire[20:0] adder1_out, adder2_out, adder3_out, adder4_out,
            adder5_out, adder6_out;
    adder_21bit adder1({in1[14], 6'b0, in1[13:0]}, {in2[14], 6'b0, in2[13:0]}, adder1_out),
            adder2({in3[14], 6'b0, in3[13:0]}, {in4[14], 6'b0, in4[13:0]}, adder2_out),
            adder3({in5[14], 6'b0, in5[13:0]}, {in6[14], 6'b0, in6[13:0]}, adder3_out),
            adder4({in7[14], 6'b0, in7[13:0]}, {in8[14], 6'b0, in8[13:0]}, adder4_out),
            adder5(adder1_out, adder2_out, adder5_out),
            adder6(adder3_out, adder4_out, adder6_out),
            adder7(adder5_out, adder6_out, out);
endmodule

module addertree_tb;

    reg[14:0] in1 = 15'd1, in2 = 15'd2, in3 = 15'd3, in4 = 15'd4,
            in5 = 15'd5, in6 = 15'd6, in7 = 15'd7, in8 = 15'd8;
    reg[7:0] bias = 8'd3;
    wire[20:0] out;
    adder_tree u1(in1,in2, in3,in4, in5,in6, in7,in8, bias, out);
    initial begin
        #50 in1 = 15'd9;
        #50 in1 = {1'b1, 14'd1};
        #50 in2 = {1'b1, 14'd3};
        #50 in1 = {1'b1, 14'd3};
        in2 = 15'd2;
        #50 $stop;
    end

endmodule 
