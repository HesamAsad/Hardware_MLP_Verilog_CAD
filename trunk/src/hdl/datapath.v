module datapath (
    input clk, rst, rst_cnt, mem_read, acc, ld_add, ld_mult, ld_x, sel_h_o, cnt,
    input[4:0] addr1, input[3:0] addr2, input[9:0] addr3, input[2:0] sel_64bit, 
    input[2:0] sel_reg, input[29:0] ld, input[29:0] ld_out_h, input[9:0] ld_out_o,
    output[3:0] out, output[4:0] cnt_out
);
    wire[7:0] regb_out[0:31];
    assign regb_out[30] = 8'd0;
    assign regb_out[31] = 8'd0;
    wire[7:0] bh, bo, _b_;
    wire[62*8-1:0] wh, xh, _w_, _x_;
    wire[62*8-1:0] regxh_out;
    wire[62*8-1:0] regw_out[0:31];
    assign regw_out[30] = 8'd0;
    assign regw_out[31] = 8'd0;
    wire[30*8-1:0] wo, xo;
    wire[7:0] reg_xhout[0:29], reg_xoout[0:9];
    wire[63:0] mux_w_bit[0:31], w_in[0:7];
    wire[63:0] x_in;
    wire[7:0] pu_out[0:7], PU_bias[0:29];
    assign xo = {reg_xhout[0],reg_xhout[1],reg_xhout[2],reg_xhout[3]
            ,reg_xhout[4],reg_xhout[5],reg_xhout[6],reg_xhout[7]
            ,reg_xhout[8],reg_xhout[9],reg_xhout[10],reg_xhout[11]
            ,reg_xhout[12],reg_xhout[13],reg_xhout[14],reg_xhout[15]
            ,reg_xhout[16],reg_xhout[17],reg_xhout[18],reg_xhout[19]
            ,reg_xhout[20],reg_xhout[21],reg_xhout[22],reg_xhout[23]
            ,reg_xhout[24],reg_xhout[25],reg_xhout[26],reg_xhout[27]
            ,reg_xhout[28],reg_xhout[29]};
    counter     cnt1(clk, rst_cnt, cnt, cnt_out);
    wh_mem      wh_(addr1, mem_read, wh);
    bh_mem      bh_(addr1, mem_read, bh);
    wo_mem      wo_(addr2, mem_read, wo);
    bo_mem      bo_(addr2, mem_read, bo);
    data_mem    x_(addr3, mem_read, xh);
    mux_2to1    mux_w(sel_h_o, wh, {wo, 256'd0}, _w_);
    mux_2to1    mux_x(sel_h_o, xh, {xo, 256'd0}, _x_);
    mux_2to1 #8 mux_b(sel_h_o, bh, bo, _b_);
    register #(62*8) reg_x(          //x register
        .clk(clk),
        .rst(rst),
        .ld(ld_x),
        .in(_x_),
        .out(regxh_out)
    );
    genvar i, j;
    generate                        //generating 30 registers for w
        for (i = 0; i < 30; i=i+1)
        begin
            register #(62*8) regi(
                .clk(clk),
                .rst(rst),
                .ld(ld[i]),
                .in(_w_),
                .out(regw_out[i])
            );
        end
    endgenerate
    generate                        //generating 30 registers for b
        for (i = 0; i < 30; i=i+1)
        begin
            register #(8) regi(
                .clk(clk),
                .rst(rst),
                .ld(ld[i]),
                .in(_b_),
                .out(regb_out[i])
            );
        end
    endgenerate
    generate                        //generating 30 registers for x_out_hidden
        for (i = 0; i < 30; i=i+1)
        begin
            register #(8) regi(
                .clk(clk),
                .rst(rst),
                .ld(ld_out_h[i]),
                .in(pu_out[i%8]),
                .out(reg_xhout[i])
            );
        end
    endgenerate
    mux_8to1 mux1(          //mux for selecting 8*8 bits from 62*8 bits of x
        .sel(sel_64bit),
        .in1(regxh_out[63:0]),
        .in2(regxh_out[127:64]),
        .in3(regxh_out[191:128]),
        .in4(regxh_out[255:192]),
        .in5(regxh_out[319:256]),
        .in6(regxh_out[383:320]),
        .in7(regxh_out[447:384]),
        .in8({16'd0, regxh_out[495:448]}), 
        .out(x_in)
    );

    generate
        for (i = 0; i < 8; i=i+1) begin
            for(j = 0; j < 4; j=j+1) begin
                mux_8to1 mux2(
                    .sel(sel_64bit),
                    .in1(regw_out[i*4+j][63:0]),
                    .in2(regw_out[i*4+j][127:64]),
                    .in3(regw_out[i*4+j][191:128]),
                    .in4(regw_out[i*4+j][255:192]),
                    .in5(regw_out[i*4+j][319:256]),
                    .in6(regw_out[i*4+j][383:320]),
                    .in7(regw_out[i*4+j][447:384]),
                    .in8({16'd0, regw_out[i*4+j][495:448]}), 
                    .out(mux_w_bit[i*4+j])
                );
            end
        end
    endgenerate

    generate
        for(i = 0; i < 8; i = i+1) begin
            mux_5to1 mux4(
                .sel(sel_reg),
                .in1(mux_w_bit[i]),
                .in2(mux_w_bit[i+8]),
                .in3(mux_w_bit[i+16]),
                .in4(mux_w_bit[i+24]),
                .out(w_in[i])
            );
        end
    endgenerate
    generate
        for(i = 0; i < 8; i = i+1) begin
            mux_5to1 #8 mux4(
                .sel(sel_reg),
                .in1(regb_out[i]),
                .in2(regb_out[i+8]),
                .in3(regb_out[i+16]),
                .in4(regb_out[i+24]),
                .out(PU_bias[i])
            );
        end
    endgenerate
    generate
        for (i = 0; i < 8; i=i+1)
        begin
            PU PUi(
                .clk(clk),
                .rst(rst_cnt),
                .ld_mult(ld_mult),
                .ld_add(ld_add),
                .acc(acc),
                .x(x_in),
                .w(w_in[i]),
                .bias(PU_bias[i]),
                .out(pu_out[i])
            );
        end
    endgenerate
    generate                       //generating 10 registers for x_out_o
        for (i = 0; i < 10; i=i+1)
        begin
            register #(8) regi(
                .clk(clk),
                .rst(rst),
                .ld(ld_out_o[i]),
                .in(pu_out[i%8]),
                .out(reg_xoout[i])
            );
        end
    endgenerate
    get_max argmax(reg_xoout[0],reg_xoout[1],reg_xoout[2],reg_xoout[3],
                    reg_xoout[4],reg_xoout[5],reg_xoout[6],reg_xoout[7],
                    reg_xoout[8],reg_xoout[9],out);
endmodule
