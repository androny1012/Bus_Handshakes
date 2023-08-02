`timescale 1ns / 1ns

module Handshake_Type3(
    input           clk,
    input           rst_n,

    input 			valid_pre_i,    //from pre-stage
    input   [7:0]   data_pre_i,  	//from pre-stage
    output 		    ready_pre_o,    //to   pre-stage

    output 			valid_post_o,   //to   post-stage
    output  [7:0]   data_post_o,  	//to   post-stage
    input 			ready_post_i    //from post-stage
);

    reg  		    ready_post_i_r;
    reg  		    valid_buf;
    reg     [7:0]   data_buf;
    wire            ready_miss;
    assign ready_miss = valid_pre_i && ready_pre_o && !ready_post_i;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_buf <= 1'b0;
        end else if(ready_miss) begin
            valid_buf <= #1 1'b1;
        end else if(ready_post_i) begin // 发生了ready_miss说明slave not ready，等到其ready后就可以把buffer中的数据送出，恢复正常
            valid_buf <= #1 1'b0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_buf <= 'b0;
        end else if(ready_miss) begin
            data_buf <= #1 data_pre_i;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            ready_post_i_r <= 1'b0;
        end else
            ready_post_i_r <= #1 ready_post_i;
    end

    assign ready_pre_o  = ready_post_i_r;
    assign valid_post_o = (valid_pre_i && ready_pre_o) | valid_buf;
    // 如果输入数据是握手获得的，直接透传
    // 如果buffer中有，则用buffer中的数
    assign data_post_o  = valid_buf ? data_buf : data_pre_i;
endmodule