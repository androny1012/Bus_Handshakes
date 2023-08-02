`timescale 1ns / 1ns

module Handshake_Type1(
    input           clk,
    input           rst_n,

    input 			valid_pre_i,    //from pre-stage
    input   [7:0]   data_pre_i,  	//from pre-stage
    output 		    ready_pre_o,    //to pre-stage

    output 			valid_post_o,    //to post-stage
    output  [7:0]   data_post_o,  	//to post-stage
    input 			ready_post_i     //from post-stage
);

    reg 		    valid_post_o_r;
    reg  		    ready_pre_o_r;
    reg   	[7:0]   data_r;
    reg 	[7:0]   dout;

    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n) begin
    //         valid_post_o_r   <= 1'b0;
    //         data_r           <= 0;
    //     end else if(valid_pre_i && ready_pre_o) begin
    //         valid_post_o_r <= 1'b1;
    //         data_r  <= data_pre_i;
    //     end else
    //         valid_post_o_r <= 1'b0;
    // end

    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n) begin
    //         dout 	        <= 0;
    //     end
    //     else if(valid_post_o_r && ready_post_i) begin
    //         dout <= data_r;
    //     end
    // end

    assign ready_pre_o  = ready_post_i;
    assign valid_post_o = (valid_pre_i && ready_pre_o);
    assign data_post_o  = (valid_post_o && ready_post_i) ? data_pre_i : 'b0;
endmodule