module get_max (
    input[7:0] in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,
    output reg[3:0] argmax
);
    wire[7:0] in[0:9];
    reg[7:0] max = 8'd0;
    assign in[0]=in1;
    assign in[1]=in2;
    assign in[2]=in3;
    assign in[3]=in4;
    assign in[4]=in5;
    assign in[5]=in6;
    assign in[6]=in7;
    assign in[7]=in8;
    assign in[8]=in9;
    assign in[9]=in10;
    integer i;
    always @(*) begin
        max = 8'd0;
        for(i = 0; i < 10; i=i+1) begin
            if(in[i]>max) begin
                max = in[i];
                argmax = i;
            end
        end
    end
endmodule


module get_max_tb;

    reg[7:0] in1=8'd0,in2=8'd0,in3=8'd0,in4=8'd5,in5=8'd0,
            in6=8'd0,in7=8'd0,in8=8'd0,in9=8'd0,in10=8'd0;
    wire[3:0] argmax;
    get_max u1(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,argmax);
    initial begin
        #50 in9=8'd10;
        #50 $stop;
    end

endmodule
