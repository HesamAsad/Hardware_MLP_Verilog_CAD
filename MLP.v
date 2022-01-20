module MLP (
    input clk, rst, start, input[9:0] test_num, output[3:0] out, output done
);
    wire rst_dp, rst_cnt, mem_read, acc, ld_add, ld_mult, ld_x, sel_h_o, cnt;
    wire[4:0] addr1;
    wire[3:0] addr2;
    wire[9:0] addr3, ld_out_o;
    wire[2:0] sel_64bit;
    wire[2:0] sel_reg;
    wire[29:0] ld, ld_out_h;
    wire[4:0] cnt_out;
    datapath dp(clk, rst_dp, rst_cnt, mem_read, acc, ld_add, ld_mult, ld_x, sel_h_o, cnt,
            addr1, addr2, addr3, sel_64bit, sel_reg, ld, ld_out_h, ld_out_o, out, cnt_out);
    controller cu(
    clk, rst, start, cnt_out, test_num, mem_read, ld_x, 
    sel_h_o, acc, ld_add, ld_mult, cnt, rst_dp, rst_cnt, done,
    addr1, addr2, addr3, sel_64bit, sel_reg, ld, ld_out_h, ld_out_o
    );

endmodule
