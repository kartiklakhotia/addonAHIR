`timescale 1ns/1ns

module chnl_tester #(
	parameter C_PCI_DATA_WIDTH = 9'd32,
	parameter C_NUM_CHNL = 4'd1
//// parameter values for tx data length on different pipes will be assigned at instantiation ////
)
(
	input CLK,
	input down_clk,
	input RST,
///////////////// ALL CHANNELS /////////////////
	//////// Rx PORT //////

	output [C_NUM_CHNL-1:0] CHNL_RX_CLK, 
	input [C_NUM_CHNL-1:0] CHNL_RX, 
	output [C_NUM_CHNL-1:0] CHNL_RX_ACK, 
	input [C_NUM_CHNL-1:0] CHNL_RX_LAST, 
	input [(C_NUM_CHNL*32)-1:0] CHNL_RX_LEN, 
	input [(C_NUM_CHNL*31)-1:0] CHNL_RX_OFF, 
	input [(C_PCI_DATA_WIDTH*C_NUM_CHNL)-1:0] CHNL_RX_DATA, 
	input [C_NUM_CHNL-1:0] CHNL_RX_DATA_VALID, 
	output [C_NUM_CHNL-1:0] CHNL_RX_DATA_REN,
	
	//////// Tx PORT //////

	output [C_NUM_CHNL-1:0] CHNL_TX_CLK, 
	output [C_NUM_CHNL-1:0] CHNL_TX, 
	input [C_NUM_CHNL-1:0] CHNL_TX_ACK, 
	output [C_NUM_CHNL-1:0] CHNL_TX_LAST, 
	output [(C_NUM_CHNL*32)-1:0] CHNL_TX_LEN, 
	output [(C_NUM_CHNL*31)-1:0] CHNL_TX_OFF, 
	output [(C_PCI_DATA_WIDTH*C_NUM_CHNL)-1:0] CHNL_TX_DATA, 
	output [C_NUM_CHNL-1:0] CHNL_TX_DATA_VALID, 
	input [C_NUM_CHNL-1:0] CHNL_TX_DATA_REN
);


wire [(C_PCI_DATA_WIDTH*C_NUM_CHNL)-1:0] rData;
wire [(C_PCI_DATA_WIDTH*C_NUM_CHNL)-1:0] tData;


////// AHIR SYSTEM SIGNALS //////

wire [C_NUM_CHNL-1:0] in_data_pipe_write_ack; 
wire [C_NUM_CHNL-1:0] in_data_pipe_write_req; 
wire [C_NUM_CHNL-1:0] out_data_pipe_read_req; 
wire [C_NUM_CHNL-1:0] out_data_pipe_read_ack; 


genvar loop0_index;
generate
	for (loop0_index = 0; loop0_index < C_NUM_CHNL; loop0_index = loop0_index + 1) begin : loop0
		assign CHNL_RX_CLK[loop0_index] = down_clk;
		assign CHNL_TX_CLK[loop0_index] = down_clk;
		assign CHNL_TX_LAST[loop0_index] = 1;
		assign CHNL_TX_OFF[31*loop0_index +:31] = 0;
	end
endgenerate;


riffa2ahir_slave #(
.C_PCI_DATA_WIDTH(C_PCI_DATA_WIDTH),
.TX_DATA_LEN(32'd2)
) interface0 (
	.CLK(down_clk),
	.RST(RST),
	.CHNL_RX(CHNL_RX),
	.CHNL_RX_ACK(CHNL_RX_ACK),
	.CHNL_RX_LEN(CHNL_RX_LEN),
	.CHNL_RX_DATA(CHNL_RX_DATA),
	.CHNL_RX_DATA_VALID(CHNL_RX_DATA_VALID),
	.CHNL_RX_DATA_REN(CHNL_RX_DATA_REN),
	.CHNL_TX(CHNL_TX),
	.CHNL_TX_ACK(CHNL_TX_ACK),
	.CHNL_TX_LEN(CHNL_TX_LEN),
	.CHNL_TX_DATA(CHNL_TX_DATA),
	.CHNL_TX_DATA_VALID(CHNL_TX_DATA_VALID),
	.CHNL_TX_DATA_REN(CHNL_TX_DATA_REN),
	.in_data_pipe_write_data(rData),
	.in_data_pipe_write_req(in_data_pipe_write_req),
	.in_data_pipe_write_ack(in_data_pipe_write_ack),
	.out_data_pipe_read_data(tData),
	.out_data_pipe_read_req(out_data_pipe_read_req),
	.out_data_pipe_read_ack(out_data_pipe_read_ack)
);	

ahir_system logic_block(
    .clk(down_clk), 
    .reset(RST),
    .det_input_pipe_pipe_write_data(rData),
    .det_input_pipe_pipe_write_req(in_data_pipe_write_req), 
    .det_input_pipe_pipe_write_ack(in_data_pipe_write_ack), 
    .det_output_pipe_pipe_read_data(tData),
    .det_output_pipe_pipe_read_req(out_data_pipe_read_req), 
    .det_output_pipe_pipe_read_ack(out_data_pipe_read_ack) 
);


endmodule
