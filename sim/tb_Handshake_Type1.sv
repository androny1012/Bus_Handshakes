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
logic [7:0]     data_ref     ;

logic           valid_pre_random_stall;
logic           ready_post_random_stall;
integer         i;
integer         err;
integer         cycle_cnt;

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

parameter clk_period = 10;  

always begin
    #(clk_period/2) clk = ~clk;  
end

initial begin
    clk = 1'b1;
    rst_n = 1'b0;
    cycle_cnt = 0;

    #(clk_period*5);
    @(negedge clk); rst_n = 1'b1;
end


initial begin
    data_ref = 'b1;
    err = 0;
    while(1) begin
        @(posedge clk) begin
            if(valid_post && ready_post) begin
                data_ref <= #1 data_ref + 1'b1;
                if(data_post != data_ref) begin
                    err <= err + 1;
                    $display("data_post: %d, data_ref: %d", data_post, data_ref);
                end
            end
        end
    end
end


initial begin
    $display("*********** tb_Handshake_Type1 *****************");
    i = 0;
    valid_pre_random_stall = 0;
    ready_post_random_stall = 0;
    @(posedge rst_n);
    // #(clk_period*5);
    // #(clk_period);
    // valid_pre_random_stall  = 1; 
    // ready_post_random_stall = 0; 

    // #(clk_period);
    // valid_pre_random_stall  = 1; 
    // ready_post_random_stall = 1; 

    // #(clk_period);
    // valid_pre_random_stall  = 0; 
    // ready_post_random_stall = 1; 

    // #(clk_period);
    // valid_pre_random_stall  = 0; 
    // ready_post_random_stall = 1; 

    // #(clk_period);
    // valid_pre_random_stall  = 1; 
    // ready_post_random_stall = 1; 

    // #(clk_period);
    // valid_pre_random_stall  = 1; 
    // ready_post_random_stall = 1; 

    // #(clk_period);
    // valid_pre_random_stall  = 0; 
    // ready_post_random_stall = 1; 
    
    // #(clk_period);
    // valid_pre_random_stall  = 0; 
    // ready_post_random_stall = 1;

    // #(clk_period);
    // valid_pre_random_stall  = 1; 
    // ready_post_random_stall = 1; 

    // #(clk_period);
    // valid_pre_random_stall  = 1; 
    // ready_post_random_stall = 1;    

    // #(clk_period*5);  

    // for(i = 0; i< 150 ; i = i + 1) begin
    while(data_ref <= 8'd200) begin
        // valid_pre_random_stall  = 1; 
        // ready_post_random_stall = 1; 
        valid_pre_random_stall  = $random(); 
        ready_post_random_stall = $random(); 
        #(clk_period);
        cycle_cnt = cycle_cnt + 1;
    end
    #(clk_period*5);  
    // #300
    $display("cycle_cnt: %d", cycle_cnt);
    if(err == 0)
        $display("*****************PASSED*************************");
    else
        $display("******************ERROR*************************");    
    $finish;
end

endmodule

