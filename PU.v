module PU (
    input clk, rst, ld_mult, ld_add, acc,
    input[63:0] x, w,
    input[7:0] bias,
    output[7:0] out
);

    wire[14:0] mult_out[0:7];
    wire[14:0] reg_mult[0:7];
    wire[14:0] mult_bias_out;
    wire[20:0] adder_bias_out, saved_out, adder_out;
    mult mult1(bias, {8'b01111111}, mult_bias_out);
    genvar i;
    generate
        for (i = 0; i < 8; i=i+1) begin
            mult multiplier(
                .in1(x[(8*(i+1)-1):8*i]),
                .in2(w[(8*(i+1)-1):8*i]),
                .out(mult_out[i])
            );
            register #15 regi(
                .clk(clk),
                .rst(rst),
                .ld(ld_mult),
                .in(mult_out[i]),
                .out(reg_mult[i])
            );
        end
    endgenerate
    adder_tree adder1(
        reg_mult[0],reg_mult[1], reg_mult[2],reg_mult[3],
        reg_mult[4],reg_mult[5], reg_mult[6],reg_mult[7], adder_out
    );
    acc_register #21 save_reg(clk, rst, ld_add, acc, adder_out, saved_out);
    adder_21bit adder8(saved_out, {mult_bias_out[14], 6'b0, mult_bias_out[13:0]}, adder_bias_out);
    relu activation_function(
        {adder_bias_out[20], adder_bias_out[19:0] >> 9},
        out
    );
endmodule

module PU_tb;
    reg clk = 1'b0, rst = 1'b1, acc = 1'b0, ld_mult = 1'b0, ld_add =1'b1;
    always #50 clk = ~clk;
    reg[4:0] addr1 = 5'd0;
    reg[9:0] addr3 = 5'd0;
    reg mem_read = 1'b1;
    wire[62*8-1:0] out1, out5;
    wire[7:0] out2, out;
    wh_mem u1(addr1, mem_read, out1);
    bh_mem u2(addr1, mem_read, out2);
    data_mem u5(addr3, mem_read, out5);
    PU pu(clk, rst, ld_mult, ld_add, acc, out5[62*8-1:54*8], out1[62*8-1:54*8], out2, out);
    initial begin
        #50 rst = 1'b0;
        #50 ld_mult = 1'b1;
        #5000 $stop;
    end
endmodule
