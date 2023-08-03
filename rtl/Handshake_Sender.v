`timescale 1ns / 1ns

module Handshake_Sender(
    input               clk,
    input               rst_n,
    input               random_stall,
    input               ready_i,    //from post-stage
    output              valid_o,    //to post-stage
    output  [7:0]       data_o      //to post-stage
);

    reg             valid_o_r;
    reg     [7:0]   cnt;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt  <= 'b1;
        end else if(valid_o && ready_i) begin //本级确认握手才送下一个数
            cnt  <= cnt + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_o_r <= 1'b0;
        end else begin
            valid_o_r <= random_stall; //模拟随机的source valid
        end
    end

    assign valid_o = valid_o_r;
    assign data_o  = valid_o_r ? cnt : 'b0;
endmodule