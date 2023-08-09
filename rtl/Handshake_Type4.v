// module Handshake_Type4(
//     input           clk,
//     input           rst_n,

//     input           valid_pre_i,    //from pre-stage
//     input   [7:0]   data_pre_i,     //from pre-stage
//     output          ready_pre_o,    //to pre-stage

//     output          valid_post_o,   //to post-stage
//     output  [7:0]   data_post_o,    //to post-stage
//     input           ready_post_i    //from post-stage
// );

//     reg             valid_pre_i_r;
//     reg     [7:0]   data_r;

//     reg             valid_buf; 
//     reg     [7:0]   data_buf;  //暂存后级not ready时的数据
    

//     always @(posedge clk or negedge rst_n) begin
//         if(!rst_n) begin
//             valid_pre_i_r <= 1'b0;
//             data_r        <= 'b0;
//         end else if(ready_pre_o) begin
//             valid_pre_i_r <= valid_pre_i;       
//             data_r        <= data_pre_i;
//         end
//     end

//     assign ready_miss = !valid_buf && !ready_post_i;
//     // assign ready_miss = ready_pre_o && !ready_post_i;
//     always @(posedge clk or negedge rst_n) begin
//         if(!rst_n) begin
//             valid_buf <= 1'b0;
//             data_buf <= 'b0;
//         end else if(ready_post_i) begin // 发生了ready_miss说明slave not ready，等到其ready后就可以把buffer中的数据送出，恢复正常
//             valid_buf <= 1'b0;
//         end else if(ready_miss) begin
//             valid_buf <= valid_pre_i_r;
//             data_buf <= data_r;
//         end
//     end


//     assign ready_pre_o  = !valid_buf | !valid_pre_i_r; // 深度为2，两个寄存器有一个是空的就可以送数
//     // assign valid_post_o = valid_pre_i_r | valid_buf;
//     assign valid_post_o = valid_buf ? valid_buf: valid_pre_i_r; // 只要寄存器或buf中有数就可以deq
//     assign data_post_o  = valid_buf ? data_buf : data_r;
//     // 过多路选择器的输出还是寄存器输出吗
// endmodule

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

    reg             valid_buf; 
    reg     [7:0]   data_buf;  //暂存后级not ready时的数据
    
    wire            ready_s;
    reg             valid_s_r;
    reg     [7:0]   data_s_r;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_buf <= 1'b0;
        end else if(ready_post_i) begin //如果后级ready,buf中的数据一定是空
            valid_buf <= 1'b0;
        end else if(ready_pre_o && !ready_s) begin
            valid_buf <= valid_pre_i;            
        end 
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_buf  <= 'b0;
        end else if(ready_pre_o && !ready_s) begin
            data_buf  <= data_pre_i;                
        end 
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_s_r <= 1'b0;
            data_s_r  <= 'b0;
        end else if(ready_s) begin
            valid_s_r <= valid_buf ? valid_buf: valid_pre_i;       
            data_s_r  <= valid_buf ? data_buf : data_pre_i;
        end
    end

    assign ready_s =!valid_s_r | ready_post_i; //valid打拍级是否能接收数据

    // 输出都为寄存器，仅一个反相器
    assign valid_post_o = valid_s_r;
    assign data_post_o  = data_s_r;
    assign ready_pre_o  = !valid_buf;

endmodule

// module Handshake_Type4(
//     input           clk,
//     input           rst_n,

//     input           valid_pre_i,    //from pre-stage
//     input   [7:0]   data_pre_i,     //from pre-stage
//     output          ready_pre_o,    //to pre-stage

//     output          valid_post_o,   //to post-stage
//     output  [7:0]   data_post_o,    //to post-stage
//     input           ready_post_i    //from post-stage
// );



//     wire        valid_s;
//     wire [7:0]  data_s;
//     wire        ready_s;

//     Handshake_Type2 u_bridge1(
//         .clk(clk),
//         .rst_n(rst_n),
        
//         .ready_pre_o(ready_pre_o),
//         .valid_pre_i(valid_pre_i),
//         .data_pre_i(data_pre_i),

//         .valid_post_o(valid_s),    //to post-stage
//         .data_post_o(data_s),  	//to post-stage
//         .ready_post_i(ready_s)     //from post-stage
//     );

//     Handshake_Type3 u_bridge2(
//         .clk(clk),
//         .rst_n(rst_n),
        
//         .ready_pre_o(ready_s),
//         .valid_pre_i(valid_s),
//         .data_pre_i(data_s),

//         .valid_post_o(valid_post_o),    //to post-stage
//         .data_post_o(data_post_o),  	//to post-stage
//         .ready_post_i(ready_post_i)     //from post-stage
//     );

// endmodule