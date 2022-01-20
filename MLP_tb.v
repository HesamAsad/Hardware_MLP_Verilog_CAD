module MLP_tb;
    reg clk = 1'b0, rst=1'b1, start = 1'b0, mem_read=1'b1;
    reg[9:0] test_num;
    wire[3:0] out, label;
    wire done;
    label_mem u6(test_num, mem_read, label);
    MLP u(
    clk, rst, start, test_num, out, done
    );
    integer i, cnt=0;
    always #50 clk = ~clk;
    initial begin
        for(i=0; i<100; i=i+1) begin
            rst = 1'b1;
            start = 1'b0;
            test_num = $urandom($realtime)%750;
            #75 rst = 1'b0;
            start = 1'b1;
            #100 start = 1'b0;
            #16200;
            if(label == out)
                cnt = cnt+1;
        end
        $stop; 
    end
endmodule
