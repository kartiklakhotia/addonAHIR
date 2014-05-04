`timescale 1ns/1ns

module chnl_tester #(
	parameter C_PCI_DATA_WIDTH = 9'd32,
	parameter C_NUM_CHNL = 4'd1,
// local or lower level module parameters //
// declare this parameter for multiple values of CHNL_INDEX //
	parameter CHNL0_OUT_DATA_LEN = 32'd2
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



wire [(C_PCI_DATA_WIDTH-1*C_NUM_CHNL):0] rData;
wire [(C_PCI_DATA_WIDTH-1*C_NUM_CHNL):0] tData;


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

// create multiple instantiation in a fashion similar as below //
// in each instance, replace CHNL_INDEX with the chnl no.//
// CHNL_INDEX is zero indexed //
riffa2ahir_slave #(
.C_PCI_DATA_WIDTH(C_PCI_DATA_WIDTH),
.TX_DATA_LEN(CHNL0_OUT_DATA_LEN)
) interface0 (
	.CLK(down_clk),
	.RST(RST),
	.CHNL_RX(CHNL_RX[0]),
	.CHNL_RX_ACK(CHNL_RX_ACK[0]),			
	.CHNL_RX_LEN(CHNL_RX_LEN[32*0 +:31]),
	.CHNL_RX_DATA(CHNL_RX_DATA[C_PCI_DATA_WIDTH*0 +:C_PCI_DATA_WIDTH]),
	.CHNL_RX_DATA_VALID(CHNL_RX_DATA_VALID[0]),
	.CHNL_RX_DATA_REN(CHNL_RX_DATA_REN[0]),
	.CHNL_TX(CHNL_TX[0]),
	.CHNL_TX_ACK(CHNL_TX_ACK[0]),
	.CHNL_TX_LEN(CHNL_TX_LEN[32*0 +:31]),
	.CHNL_TX_DATA(CHNL_TX_DATA[C_PCI_DATA_WIDTH*0 +:C_PCI_DATA_WIDTH]),
	.CHNL_TX_DATA_VALID(CHNL_TX_DATA_VALID[0]),
	.CHNL_TX_DATA_REN(CHNL_TX_DATA_REN[0]),
	.in_data_pipe_write_data(rData[C_PCI_DATA_WIDTH*0 +:C_PCI_DATA_WIDTH]),
	.in_data_pipe_write_req(in_data_pipe_write_req[0]),
	.in_data_pipe_write_ack(in_data_pipe_write_ack[0]),
	.out_data_pipe_read_data(tData[C_PCI_DATA_WIDTH*0 +:C_PCI_DATA_WIDTH]),
	.out_data_pipe_read_req(out_data_pipe_read_req[0]),
	.out_data_pipe_read_ack(out_data_pipe_read_ack[0])
);


//replace in_pipe_name with different input_pipe_names
//replace out_pipe_name with different output_pipe_names
//repeat instantiation of single data/req/ack pair for both rx and tx with different chnl_index numbers
ahir_system logic_block(
	.clk(down_clk),
	.reset(RST),
	// pipe_signals_start
	.det_input_pipe_pipe_write_data(rData[C_PCI_DATA_WIDTH*0 +:C_PCI_DATA_WIDTH]),
	.det_input_pipe_pipe_write_req(in_data_pipe_write_req[0]), 
	.det_input_pipe_pipe_write_ack(in_data_pipe_write_ack[0]), 
	.det_output_pipe_pipe_read_data(tData[C_PCI_DATA_WIDTH*0 +:C_PCI_DATA_WIDTH]),
	.det_output_pipe_pipe_read_req(out_data_pipe_read_req[0]), 
	.det_output_pipe_pipe_read_ack(out_data_pipe_read_ack[0]) 
	// pipe_signals_end
);	

endmodule
