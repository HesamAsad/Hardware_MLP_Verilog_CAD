module controller (
    input clk, rst, start, input[4:0] cnt_in, input[9:0] test_num, 
    output reg mem_read, ld_x, sel_h_o, acc, ld_add, ld_mult, cnt, rst_dp, rst_cnt, done,
    output reg[4:0] addr1, output reg[3:0] addr2, output reg[9:0] addr3,
    output reg[2:0] sel_64bit, output reg[2:0] sel_reg, output reg[29:0] ld, 
    output reg[29:0] ld_out_h, output reg[9:0] ld_out_o
);
    reg[4:0] ps, ns;
    parameter[4:0] idle = 0, init_h = 1, rst_cnt1 = 2, n0_7_h_c1 = 3,
     n0_7_h_c2 = 4, rst_cnt2 = 5, save_0_7 = 6, n8_15_h_c1 = 7,
     n8_15_h_c2 = 8, save_8_15 = 9, rst_cnt3 = 10, n16_23_h_c1 = 11,
     n16_23_h_c2 = 12, save_16_23 = 13, rst_cnt4 = 14, n24_30_h_c1 = 15,
     n24_30_h_c2 = 16, save_24_30 = 17, rst_cnt5 = 18, init_o = 19,
     n0_7_o_c1 = 20, n0_7_o_c2 = 21, save_o1 = 22, rst_cnt6 = 23, 
     rst_cnt7 = 28, n8_9_o_c1 = 24, n8_9_o_c2 = 25, save_o2 = 26, get_max = 27;
    reg[29:0] onehot;
    always @(cnt_in) begin
        onehot = 30'd0;
        onehot[cnt_in] = 1'b1;
    end
    always@(posedge clk or posedge rst) begin
        if(rst)
            ps <= idle;
        else
            ps <= ns;
    end
    always@(ps or start or cnt_in)  //setting next state
    begin
        ns = 4'd0;
        case(ps)
            idle: ns = start ? init_h : idle;
            init_h: ns = (cnt_in == 5'd30) ? rst_cnt1 : init_h;
            rst_cnt1: ns = n0_7_h_c1;
            n0_7_h_c1: ns = n0_7_h_c2;
            n0_7_h_c2: ns = (cnt_in == 5'd8) ? save_0_7 : n0_7_h_c1;
            save_0_7: ns = rst_cnt2;
            rst_cnt2: ns = n8_15_h_c1;
            n8_15_h_c1: ns = n8_15_h_c2;
            n8_15_h_c2: ns = (cnt_in == 5'd8) ? save_8_15 : n8_15_h_c1;
            save_8_15: ns = rst_cnt3;
            rst_cnt3: ns = n16_23_h_c1;
            n16_23_h_c1: ns = n16_23_h_c2;
            n16_23_h_c2: ns = (cnt_in == 5'd8) ? save_16_23 : n16_23_h_c1;
            save_16_23: ns = rst_cnt4;
            rst_cnt4: ns = n24_30_h_c1;
            n24_30_h_c1: ns = n24_30_h_c2;
            n24_30_h_c2: ns = (cnt_in == 5'd8) ? save_24_30 : n24_30_h_c1;
            save_24_30: ns = rst_cnt5;
            rst_cnt5: ns = init_o;
            init_o: ns = (cnt_in == 5'd9) ? rst_cnt6 : init_o;
            rst_cnt6: ns = n0_7_o_c1;
            n0_7_o_c1: ns = n0_7_o_c2;
            n0_7_o_c2: ns = (cnt_in == 5'd8) ? save_o1 : n0_7_o_c1;
            save_o1: ns = rst_cnt7;
            rst_cnt7: ns = n8_9_o_c1;
            n8_9_o_c1: ns = n8_9_o_c2;
            n8_9_o_c2: ns = (cnt_in == 5'd8) ? save_o2 : n8_9_o_c1;
            save_o2: ns = get_max;
            get_max: ns = idle;
        endcase
    end
    always @(ps or onehot) begin
        {mem_read, ld_x, sel_h_o, acc, ld_add, ld_mult, cnt, addr1, addr2, addr3,
        rst_cnt, rst_dp, sel_64bit, sel_reg, ld, ld_out_h, ld_out_o, done} = 105'd0;
        case (ps)
            idle: {rst_dp, rst_cnt} = 2'b11;
            rst_cnt1: {rst_cnt} = {1'b1};
            rst_cnt2: {sel_reg, rst_cnt} = {3'd0, 1'b1};
            rst_cnt3: {sel_reg, rst_cnt} = {3'd1, 1'b1};
            rst_cnt4: {sel_reg, rst_cnt} = {3'd2, 1'b1};
            rst_cnt5: {sel_reg, rst_cnt} = {3'd3, 1'b1};
            rst_cnt6: {sel_reg, rst_cnt} = {3'd0, 1'b1};
            rst_cnt7: {sel_reg, rst_cnt} = {3'd0, 1'b1};
            init_h: {addr3, mem_read, addr1, ld, ld_x, cnt} = {test_num, 1'b1, cnt_in, onehot, 1'b1, 1'b1};
            n0_7_h_c1: {sel_reg, sel_64bit, cnt, ld_mult} = {3'd0, cnt_in[2:0], 1'b1, 1'b1};
            n0_7_h_c2: {sel_reg, sel_64bit, acc} = {3'd0, cnt_in[2:0], 1'b1};
            save_0_7: {sel_reg, ld_out_h} = {3'd0, 30'd255};
            n8_15_h_c1: {sel_reg, sel_64bit, cnt, ld_mult} = {3'd1, cnt_in[2:0], 1'b1, 1'b1};
            n8_15_h_c2: {sel_reg, sel_64bit, acc} = {3'd1, cnt_in[2:0], 1'b1};
            save_8_15: {sel_reg, ld_out_h} = {3'd1, 30'd65280};
            n16_23_h_c1: {sel_reg, sel_64bit, cnt, ld_mult} = {3'd2, cnt_in[2:0], 1'b1, 1'b1};
            n16_23_h_c2: {sel_reg, sel_64bit, acc} = {3'd2, cnt_in[2:0], 1'b1};
            save_16_23: {sel_reg, ld_out_h} = {3'd2, 30'd16711680};
            n24_30_h_c1: {sel_reg, sel_64bit, cnt, ld_mult} = {3'd3, cnt_in[2:0], 1'b1, 1'b1};
            n24_30_h_c2: {sel_reg, sel_64bit, acc} = {3'd3, cnt_in[2:0], 1'b1};
            save_24_30: {sel_reg, ld_out_h} = {3'd3, 30'd1056964608};
            init_o: {sel_h_o, addr2, mem_read, ld, ld_x, cnt} = {1'b1, cnt_in[3:0], 1'b1, onehot, 1'b1, 1'b1};
            n0_7_o_c1: {sel_h_o, sel_reg, sel_64bit, cnt, ld_mult} = {1'b1, 3'd0, cnt_in[2:0], 1'b1, 1'b1};
            n0_7_o_c2: {sel_h_o, sel_reg, sel_64bit, acc} = {1'b1, 3'd0, cnt_in[2:0], 1'b1};
            save_o1: {sel_reg, ld_out_o} = {3'd0, 10'd255};
            n8_9_o_c1: {sel_h_o, sel_reg, sel_64bit, cnt, ld_mult} = {1'b1, 3'd1, cnt_in[2:0], 1'b1, 1'b1};
            n8_9_o_c2: {sel_h_o, sel_reg, sel_64bit, acc} = {1'b1, 3'd1, cnt_in[2:0], 1'b1};
            save_o2: {sel_reg, ld_out_o} = {3'd1, 10'd768};
            get_max: done = 1'b1;
        endcase
    end
endmodule
