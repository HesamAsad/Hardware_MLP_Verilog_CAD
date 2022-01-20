module mux_8to1 #(parameter N = 64) (
    input[2:0] sel,
    input[N-1:0] in1,in2,in3,in4, in5,in6,in7,in8,
    output[N-1:0] out
);
    assign out = (sel == 3'd0) ? in1 :
                (sel == 3'd1) ? in2 : 
                (sel == 3'd2) ? in3 : 
                (sel == 3'd3) ? in4 : 
                (sel == 3'd4) ? in5 : 
                (sel == 3'd5) ? in6 : 
                (sel == 3'd6) ? in7 : 
                (sel == 3'd7) ? in8 : {N{1'bz}};
endmodule

module mux_5to1 #(parameter N = 64) (
    input[2:0] sel,
    input[N-1:0] in1,in2,in3,in4,
    output[N-1:0] out
);
    assign out = (sel == 3'd0) ? in1 :
                (sel == 3'd1) ? in2 : 
                (sel == 3'd2) ? in3 : 
                (sel == 3'd3) ? in4 : 
                (sel == 3'd4) ? {N{1'b0}} : {N{1'bz}};
endmodule

module mux_2to1 #(parameter N = 62*8)(
    input sel, input[N-1:0] in1, in2,
    output [N-1:0] out
);
    assign out = sel ? in2 : in1;
endmodule
