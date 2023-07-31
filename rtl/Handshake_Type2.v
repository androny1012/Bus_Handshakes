module Handshake_Type2(
    input           clk,
    input           rst_n,

    input 			valid_pre_i,    //from pre-stage
    input   [7:0]   data_pre_i,  	//from pre-stage
    output 		    ready_pre_o,    //to pre-stage

    output 			valid_post_o,   //to post-stage
    output  [7:0]   data_post_o,    //to post-stage
    input 			ready_post_i    //from post-stage
);

    reg 		    valid_pre_i_r;
    reg  		    ready_pre_o_r;
    reg   	[7:0]   data_r;
    reg 	[7:0]   dout;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_pre_i_r   <= 1'b0;
            data_r          <= 'b0;
        end else begin
            valid_pre_i_r <= valid_pre_i;
            data_r        <= data_pre_i;
        end
    end

    assign ready_pre_o  = ready_post_i;
    assign valid_post_o = (valid_pre_i_r && ready_pre_o);
    assign data_post_o  = (valid_post_o && ready_post_i) ? data_r : 'b0;
endmodule