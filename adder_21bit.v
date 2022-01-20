module adder_21bit (
    input[20:0] in1, in2,
    output[20:0] out
);
    wire co;
    wire[19:0] in1_m, in2_m;
    assign in1_m = in1[19:0];
    assign in2_m = in2[19:0];
    assign {co, out} = in1[20]&in2[20] ? {1'b1, in1_m+in2_m} :
                        in1[20] ? ((in2_m>in1_m) ? {1'b0, in2_m-in1_m} : {1'b1, in1_m-in2_m}) :
                        in2[20] ? ((in1_m>in2_m) ? {1'b0, in1_m-in2_m} : {1'b1, in2_m-in1_m}) : 
                        in1 + in2;
endmodule
