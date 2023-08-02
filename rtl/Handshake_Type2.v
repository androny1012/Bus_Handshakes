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
    reg   	[7:0]   data_r;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_pre_i_r <= 1'b0;
        end else if(valid_pre_i) begin
            // 只要上一级握手，送进来的数就有效  x
            // 只要上一级给valid，就应该是valid √
            valid_pre_i_r <= #1 1'b1;       
        end else if(ready_post_i) begin 
            // 只要下一级握手，本级的数就送出去了，但应该先看同一周期是否有数送进来
            // 下一级准备好了，但上一级没数了，valid为无效
            valid_pre_i_r <= #1 1'b0;       
        // end else begin
        //     valid_pre_i_r <= #1 valid_pre_i;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_r <= 'b0;
        end else if(valid_pre_i && ready_pre_o) begin
            data_r <= #1 data_pre_i;
        // end else if(valid_post_o && ready_post_i) begin
        //     data_r <= #1 'b0;     
        // end else begin
        //     data_r <= #1 data_pre_i;           
        end
    end

    assign ready_pre_o  = !valid_post_o | ready_post_i; 
    //增加吞吐量，在下一级没ready的时候，只要本级没valid的数据，就可以从上一级收数据
    // assign ready_pre_o  = ready_post_i;
    assign valid_post_o = valid_pre_i_r;
    assign data_post_o  = data_r;
endmodule