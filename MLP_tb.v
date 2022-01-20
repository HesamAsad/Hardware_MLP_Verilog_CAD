module MLP_tb;
    reg clk = 1'b0, rst=1'b1, start = 1'b0;
    reg[9:0] test_num;
    wire[3:0] out;
    wire done;
    MLP u(
    clk, rst, start, test_num, out, done
    );
    integer i;
    always #50 clk = ~clk;
    initial begin
        for(i=0; i<4; i=i+1) begin
            rst = 1'b1;
            start = 1'b0;
            test_num = i;
            #75 rst = 1'b0;
            start = 1'b1;
            #100 start = 1'b0;
            #16000;
        end
        $stop; 
    end
endmodule
