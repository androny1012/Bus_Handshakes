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
            cnt  <= 'b0;
        end else if(valid_o) begin
            cnt  <= cnt + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_o_r <= 1'b0;
        end else if(!ready_i) begin
            valid_o_r <= 1'b0;
        end else begin
            valid_o_r <= random_stall; //模拟随机的source
        end
    end

    assign valid_o = valid_o_r;
    assign data_o  = cnt;
endmodule