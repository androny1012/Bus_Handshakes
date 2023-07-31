`timescale 1ns / 1ns

module tb_Handshake_Type1();

logic           clk     ;
logic           rst_n   ;
logic           ready_pre   ;
logic           valid_pre   ;
logic [7:0]     data_pre    ;
logic           ready_post   ;
logic           valid_post   ;
logic [7:0]     data_post    ;

logic           valid_pre_random_stall;
logic           ready_post_random_stall;
integer         i;

Handshake_Sender u_master(
    .clk(clk),
    .rst_n(rst_n),
    .random_stall(valid_pre_random_stall),
    .ready_i(ready_pre),
    .valid_o(valid_pre),
    .data_o(data_pre)  
);

Handshake_Type1 u_bridge(
    .clk(clk),
    .rst_n(rst_n),
    
    .ready_pre_o(ready_pre),
    .valid_pre_i(valid_pre),
    .data_pre_i(data_pre),

    .valid_post_o(valid_post),    //to post-stage
    .data_post_o(data_post),  	//to post-stage
    .ready_post_i(ready_post)     //from post-stage
);

Handshake_Receiver u_slave(
    .clk(clk),
    .rst_n(rst_n),
    .random_stall(ready_post_random_stall),
    .valid_i(valid_post),
    .data_i(data_post),
    .ready_o(ready_post) 
);



initial
begin            
    $dumpfile("tb_Handshake_Type1.vcd"); //生成的vcd文件名称
    $dumpvars(0, tb_Handshake_Type1);    //tb模块名称
end


always begin
    #1 clk = ~clk;  
end

initial begin
    clk = 1'b1;
    rst_n = 1'b0;

    #10;
    @(negedge clk); rst_n = 1'b1;
end


initial begin
    $display("***********tb_easy_shifter test*****************");
    i = 0;
    valid_pre_random_stall = 0;
    ready_post_random_stall = 0;
    for(i = 0; i< 150 ; i = i + 1) begin
        valid_pre_random_stall = $random(); 
        ready_post_random_stall = $random(); 
        #2;
    end
    // #300
    $finish;
end

endmodule