module Handshake_Type4(
    input           clk,
    input           rst_n,

    input           valid_pre_i,    //from pre-stage
    input   [7:0]   data_pre_i,     //from pre-stage
    output          ready_pre_o,    //to pre-stage

    output          valid_post_o,   //to post-stage
    output  [7:0]   data_post_o,    //to post-stage
    input           ready_post_i    //from post-stage
);

    reg             valid_pre_i_r;
    reg     [7:0]   data_r;

    reg             valid_buf; 
    reg     [7:0]   data_buf;  //暂存后级not ready时的数据
    

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_pre_i_r <= 1'b0;
            data_r        <= 'b0;
        end else if(ready_pre_o) begin
            valid_pre_i_r <= valid_pre_i;       
            data_r        <= data_pre_i;
        end
    end

    assign ready_miss = ready_pre_o && !ready_post_i;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_buf <= 1'b0;
            data_buf <= 'b0;
        end else if(ready_miss) begin
            valid_buf <= valid_pre_i_r;
            data_buf <= data_r;
        end else if(ready_post_i) begin // 发生了ready_miss说明slave not ready，等到其ready后就可以把buffer中的数据送出，恢复正常
            valid_buf <= 1'b0;
            data_buf <= 'b0;
        end
    end


    assign ready_pre_o  = !valid_buf; // 只要buf中的数为空，就可以enq
    // assign valid_post_o = valid_pre_i_r | valid_buf;
    assign valid_post_o = valid_buf ? valid_buf: valid_pre_i_r; // 只要寄存器或buf中有数就可以deq
    assign data_post_o  = valid_buf ? data_buf : data_r;
    // 过多路选择器的输出还是寄存器输出吗
endmodule