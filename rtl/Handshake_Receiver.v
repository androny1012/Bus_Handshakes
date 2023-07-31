module Handshake_Receiver(
    input               clk,
    input               rst_n,
    input               random_stall,
    input               valid_i,    //from post-stage
    input  [7:0]        data_i,     //from post-stage
    output              ready_o     //to post-stage

);

    assign ready_o = random_stall;

endmodule