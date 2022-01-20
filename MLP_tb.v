module MLP_tb;
    reg clk = 1'b0, rst=1'b1, start = 1'b0;
    reg[9:0] test_num = 10'd6;
    wire[3:0] out;
    wire done;
    MLP u(
    clk, rst, start, test_num, out, done
    );
    always #50 clk = ~clk;
    initial begin
        #75 rst = 1'b0;
        start = 1'b1;
        #100 start = 1'b0;
        #50000 $stop; 
    end
endmodule
