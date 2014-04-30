`timescale 1ns/1ns
module chnl_tester #(
	parameter C_PCI_DATA_WIDTH = 9'd32,
// local or lower level module parameters //
	parameter FIT_COEFFS_LEN = 32'd12,
	parameter BEST_SIGMA_LEN = 32'd2

)
(
	input CLK,
	input down_clk,
	input RST,
///////////////// CHANNEL 0 /////////////////
	//////// Rx PORT //////
	output CHNL0_RX_CLK, 
	input CHNL0_RX, 
	output CHNL0_RX_ACK, 
	input CHNL0_RX_LAST, 
	input [31:0] CHNL0_RX_LEN, 
	input [30:0] CHNL0_RX_OFF, 
	input [C_PCI_DATA_WIDTH-1:0] CHNL0_RX_DATA, 
	input CHNL0_RX_DATA_VALID, 
	output CHNL0_RX_DATA_REN,
	/////// Tx PORT //////	
	output CHNL0_TX_CLK, 
	output CHNL0_TX, 
	input CHNL0_TX_ACK, 
	output CHNL0_TX_LAST, 
	output [31:0] CHNL0_TX_LEN, 
	output [30:0] CHNL0_TX_OFF, 
	output [C_PCI_DATA_WIDTH-1:0] CHNL0_TX_DATA, 
	output CHNL0_TX_DATA_VALID, 
	input CHNL0_TX_DATA_REN,


///////////// CHANNEL 1 ///////////////////
	//////// Rx PORT //////
	output CHNL1_RX_CLK, 
	input CHNL1_RX, 
	output CHNL1_RX_ACK, 
	input CHNL1_RX_LAST, 
	input [31:0] CHNL1_RX_LEN, 
	input [30:0] CHNL1_RX_OFF, 
	input [C_PCI_DATA_WIDTH-1:0] CHNL1_RX_DATA, 
	input CHNL1_RX_DATA_VALID, 
	output CHNL1_RX_DATA_REN,
	/////// Tx PORT //////	
	output CHNL1_TX_CLK, 
	output CHNL1_TX, 
	input CHNL1_TX_ACK, 
	output CHNL1_TX_LAST, 
	output [31:0] CHNL1_TX_LEN, 
	output [30:0] CHNL1_TX_OFF, 
	output [C_PCI_DATA_WIDTH-1:0] CHNL1_TX_DATA, 
	output CHNL1_TX_DATA_VALID, 
	input CHNL1_TX_DATA_REN
);


/////// GLOBAL STORAGE INITIALIZER ////


wire [C_PCI_DATA_WIDTH-1:0] r0Data;
wire [C_PCI_DATA_WIDTH-1:0] t0Data;

wire [C_PCI_DATA_WIDTH-1:0] r1Data;
wire [C_PCI_DATA_WIDTH-1:0] t1Data;

////// AHIR SYSTEM SIGNALS //////

wire in0_data_pipe_write_ack; 
wire in0_data_pipe_write_req; 
wire out0_data_pipe_read_req; 
wire out0_data_pipe_read_ack; 

wire in1_data_pipe_write_ack; 
wire in1_data_pipe_write_req; 
wire out1_data_pipe_read_req; 
wire out1_data_pipe_read_ack; 


assign CHNL0_RX_CLK = down_clk;
assign CHNL0_TX_CLK = down_clk;
assign CHNL0_TX_LAST = 1'd1;
assign CHNL0_TX_OFF = 0;

assign CHNL1_RX_CLK = down_clk;
assign CHNL1_TX_CLK = down_clk;
assign CHNL1_TX_LAST = 1'd1;
assign CHNL1_TX_OFF = 0;


riffa2ahir_master #(
.C_PCI_DATA_WIDTH(C_PCI_DATA_WIDTH),
.TX_DATA_LEN(BEST_SIGMA_LEN)
) interface1 (
	.CLK(down_clk),
	.RST(RST),
	.CHNL_RX(CHNL0_RX),
	.CHNL_RX_ACK(CHNL0_RX_ACK),
	.CHNL_RX_LEN(CHNL0_RX_LEN),
	.CHNL_RX_DATA(CHNL0_RX_DATA),
	.CHNL_RX_DATA_VALID(CHNL0_RX_DATA_VALID),
	.CHNL_RX_DATA_REN(CHNL0_RX_DATA_REN),
	.CHNL_TX(CHNL0_TX),
	.CHNL_TX_ACK(CHNL0_TX_ACK),
	.CHNL_TX_LEN(CHNL0_TX_LEN),
	.CHNL_TX_DATA(CHNL0_TX_DATA),
	.CHNL_TX_DATA_VALID(CHNL0_TX_DATA_VALID),
	.CHNL_TX_DATA_REN(CHNL0_TX_DATA_REN),
	.in_data_pipe_write_data(r0Data),
	.in_data_pipe_write_req(in0_data_pipe_write_req),
	.in_data_pipe_write_ack(in0_data_pipe_write_ack),
	.out_data_pipe_read_data(t0Data),
	.out_data_pipe_read_req(out0_data_pipe_read_req),
	.out_data_pipe_read_ack(out0_data_pipe_read_ack)
);	

riffa2ahir_slave #(
.C_PCI_DATA_WIDTH(C_PCI_DATA_WIDTH),
.TX_DATA_LEN(FIT_COEFFS_LEN)
) interface2 (
	.CLK(down_clk),
	.RST(RST),
	.CHNL_RX(CHNL1_RX),
	.CHNL_RX_ACK(CHNL1_RX_ACK),
	.CHNL_RX_LEN(CHNL1_RX_LEN),
	.CHNL_RX_DATA(CHNL1_RX_DATA),
	.CHNL_RX_DATA_VALID(CHNL1_RX_DATA_VALID),
	.CHNL_RX_DATA_REN(CHNL1_RX_DATA_REN),
	.CHNL_TX(CHNL1_TX),
	.CHNL_TX_ACK(CHNL1_TX_ACK),
	.CHNL_TX_LEN(CHNL1_TX_LEN),
	.CHNL_TX_DATA(CHNL1_TX_DATA),
	.CHNL_TX_DATA_VALID(CHNL1_TX_DATA_VALID),
	.CHNL_TX_DATA_REN(CHNL1_TX_DATA_REN),
	.in_data_pipe_write_data(r1Data),
	.in_data_pipe_write_req(in1_data_pipe_write_req),
	.in_data_pipe_write_ack(in1_data_pipe_write_ack),
	.out_data_pipe_read_data(t1Data),
	.out_data_pipe_read_req(out1_data_pipe_read_req),
	.out_data_pipe_read_ack(out1_data_pipe_read_ack)
);	

ahir_system logic_block(
    .clk(down_clk), 
    .reset(RST),
    .in0_data_pipe_write_data(r0Data),
    .in0_data_pipe_write_req(in0_data_pipe_write_req), 
    .in0_data_pipe_write_ack(in0_data_pipe_write_ack), 
    .in1_data_pipe_write_data(r1Data),
    .in1_data_pipe_write_req(in1_data_pipe_write_req), 
    .in1_data_pipe_write_ack(in1_data_pipe_write_ack), 
    .out0_data_pipe_read_data(t0Data),
    .out0_data_pipe_read_req(out0_data_pipe_read_req), 
    .out0_data_pipe_read_ack(out0_data_pipe_read_ack), 
    .out1_data_pipe_read_data(t1Data),
    .out1_data_pipe_read_req(out1_data_pipe_read_req), 
    .out1_data_pipe_read_ack(out1_data_pipe_read_ack) 
);


endmodule
