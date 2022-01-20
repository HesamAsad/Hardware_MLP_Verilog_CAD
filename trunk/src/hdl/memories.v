module wh_mem (
    input[4:0] addr,
    input mem_read,
    output reg[62*8-1:0] out
);
    
    reg[62*8-1:0] mem[0:29];
    initial $readmemh("w1_sm_reorganized.dat", mem);

    always @(*) begin
        if (mem_read == 1'b1)
            out <= mem[addr];
        else
            out <= out;
    end

endmodule

module bh_mem (
    input[4:0] addr,
    input mem_read,
    output reg[7:0] out
);
    
    reg[7:0] mem[0:29];
    initial $readmemh("b1_sm.dat", mem);

    always @(*) begin
        if (mem_read == 1'b1)
            out <= mem[addr];
        else
            out <= out;
    end

endmodule

module wo_mem (
    input[3:0] addr,
    input mem_read,
    output reg[30*8-1:0] out
);
    
    reg[30*8-1:0] mem[0:9];
    initial $readmemh("w2_sm_reorganized.dat", mem);

    always @(*) begin
        if (mem_read == 1'b1)
            out <= mem[addr];
        else
            out <= out;
    end

endmodule

module bo_mem (
    input[3:0] addr,
    input mem_read,
    output reg[7:0] out
);
    
    reg[7:0] mem[0:9];
    initial $readmemh("b2_sm.dat", mem);

    always @(*) begin
        if (mem_read == 1'b1)
            out <= mem[addr];
        else
            out <= out;
    end

endmodule

module data_mem(
    input[9:0] addr,
    input mem_read,
    output reg[62*8-1:0] out
);
    
    reg[62*8-1:0] mem[0:749];
    initial $readmemh("te_data_sm_reorganized.dat", mem);

    always @(*) begin
        if (mem_read == 1'b1)
            out <= mem[addr];
        else
            out <= out;
    end

endmodule

module label_mem(
    input[9:0] addr,
    input mem_read,
    output reg [3:0] out
);
    
    reg[3:0] mem[0:749];

    initial begin
		$readmemh("te_lable_sm.dat", mem);
	end

    always @(*) begin
        if (mem_read == 1'b1)
            out <= mem[addr];
        else
            out <= out;
    end

endmodule

module memory_test();
    reg[4:0] addr1 = 5'd0;
    reg[3:0] addr2 = 5'd0;
    reg[9:0] addr3 = 5'd0;
    reg mem_read = 1'b1;
    wire[62*8-1:0] out1, out5;
    wire[7:0] out2, out4;
    wire[30*8-1:0] out3;
    wire[3:0] out6;
    wh_mem u1(addr1, mem_read, out1);
    bh_mem u2(addr1, mem_read, out2);
    wo_mem u3(addr2, mem_read, out3);
    bo_mem u4(addr2, mem_read, out4);
    data_mem u5(addr3, mem_read, out5);
    label_mem u6(addr3, mem_read, out6);
    initial begin
        #50 addr1 = 5'd29;
        #50 $stop;
    end

endmodule
