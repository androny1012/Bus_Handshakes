// module Handshake_Type3(
//     input           clk,
//     input           rst_n,

//     input           valid_pre_i,    //from pre-stage
//     input   [7:0]   data_pre_i,     //from pre-stage
//     output          ready_pre_o,    //to pre-stage

//     output          valid_post_o,   //to post-stage
//     output  [7:0]   data_post_o,    //to post-stage
//     input           ready_post_i    //from post-stage
// );

    
//     reg             valid_buf;
//     reg     [7:0]   data_buf;
//     wire            ready_miss;
//     assign ready_miss = ready_pre_o && !ready_post_i;
//     always @(posedge clk or negedge rst_n) begin
//         if(!rst_n) begin
//             valid_buf <= 1'b0;
//             data_buf <= 'b0;
//         end else if(ready_miss) begin
//             valid_buf <= valid_pre_i;
//             data_buf <= data_pre_i;
//         end else if(ready_post_i) begin // 发生了ready_miss说明slave not ready，等到其ready后就可以把buffer中的数据送出，恢复正常
//             valid_buf <= 1'b0;
//             data_buf <= 'b0;
//         end
//     end

//     assign ready_pre_o  = !valid_buf; //挤掉气泡
//     assign valid_post_o = valid_pre_i | valid_buf;

//     // reg             ready_post_i_r;
//     // always @(posedge clk or negedge rst_n) begin
//     //     if(!rst_n) ready_post_i_r <= 1'b0;
//     //     else       ready_post_i_r <= ready_post_i;
//     // end
//     // assign ready_pre_o  = ready_post_i_r;
//     // assign valid_post_o = (valid_pre_i && ready_pre_o) | valid_buf;

//     // 如果输入数据是握手获得的，直接透传
//     // 如果buffer中有，则优先用buffer中的数
//     assign data_post_o  = valid_buf ? data_buf : data_pre_i;
// endmodule


//stall思路 (ok)

// module Handshake_Type3(
//     input           clk,
//     input           rst_n,

//     input           valid_pre_i,    //from pre-stage
//     input   [7:0]   data_pre_i,     //from pre-stage
//     output          ready_pre_o,    //to pre-stage

//     output          valid_post_o,   //to post-stage
//     output  [7:0]   data_post_o,    //to post-stage
//     input           ready_post_i    //from post-stage
// );

    
//     reg             ready_pre_o_r;
//     reg             valid_buf;
//     reg     [7:0]   data_buf;
//     wire            slave_stall;
//     wire            valid_req;
//     assign slave_stall = valid_post_o && !ready_post_i;
//     assign valid_req   = valid_pre_i  ||  valid_buf;
//     always @(posedge clk or negedge rst_n) begin
//         if(!rst_n) begin
//             valid_buf <= 1'b0;
//         end else if(slave_stall) begin
//             valid_buf <= 1'b1;
//         end else begin
//             valid_buf <= 1'b0;
//         end
//     end

//     always @(posedge clk or negedge rst_n) begin
//         if(slave_stall && !valid_buf) begin
//             data_buf <= data_pre_i;
//         end
//     end

//     always @(posedge clk or negedge rst_n) begin
//         if(!rst_n) begin
//             ready_pre_o_r <= 1'b1;
//         end else if(slave_stall) begin
//             ready_pre_o_r <= !valid_req;
//         end else begin
//             ready_pre_o_r <= 1'b1;
//         end
//     end

//     assign ready_pre_o  = ready_pre_o_r; //挤掉气泡
//     assign valid_post_o = valid_pre_i | valid_buf;
//     assign data_post_o  = valid_buf ? data_buf : data_pre_i;
    
// endmodule

module Handshake_Type3(
    input           clk,
    input           rst_n,

    input           valid_pre_i,    //from pre-stage
    input   [7:0]   data_pre_i,     //from pre-stage
    output          ready_pre_o,    //to pre-stage

    output          valid_post_o,   //to post-stage
    output  [7:0]   data_post_o,    //to post-stage
    input           ready_post_i    //from post-stage
);

    reg             valid_buf; 
    reg     [7:0]   data_buf;  //暂存后级not ready时的数据
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_buf <= 1'b0;
        end else if(ready_post_i) begin //如果后级ready,buf中的数据一定是空
            valid_buf <= 1'b0;
        end else if(ready_pre_o && !ready_post_i) begin
            valid_buf <= valid_pre_i;            
        end 
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_buf  <= 'b0;
        end else if(ready_pre_o && !ready_post_i) begin
            data_buf  <= data_pre_i;                
        end 
    end

    assign ready_pre_o  = !valid_buf; // 只要buf中的数为空，就可以enq
    assign valid_post_o = valid_buf ? valid_buf: valid_pre_i; // 只要寄存器或buf中有数就可以deq
    assign data_post_o  = valid_buf ? data_buf : data_pre_i;
endmodule