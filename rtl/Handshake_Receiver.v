`timescale 1ns / 1ns

module Handshake_Receiver(
    input               clk,
    input               rst_n,
    input               random_stall,
    input               valid_i,    //from post-stage
    input  [7:0]        data_i,     //from post-stage
    output              ready_o     //to post-stage

);
    reg ready_o_r;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            ready_o_r <= 1'b0;
        end else begin
            ready_o_r <= #1 random_stall; //模拟随机的source ready
        end
    end
    assign ready_o = ready_o_r;
endmodule