`timescale 1ns/1ns

module chnl_tester #(
	parameter C_PCI_DATA_WIDTH = 9'd32,
// local or lower level module parameters //
// declare this parameter for multiple values of CHNL_INDEX //
	parameter OUT_CHNL_INDEX_DATA_LEN = 32'd2
)
(
	input CLK,
	input down_clk,
	input RST,
///////////////// CHANNEL 0 /////////////////
	//////// Rx PORT //////

	output CHNL_RX_CLK, 
	input CHNL_RX, 
	output CHNL_RX_ACK, 
	input CHNL_RX_LAST, 
	input [31:0] CHNL_RX_LEN, 
	input [30:0] CHNL_RX_OFF, 
	input [C_PCI_DATA_WIDTH-1:0] CHNL_RX_DATA, 
	input CHNL_RX_DATA_VALID, 
	output CHNL_RX_DATA_REN,
	
	output CHNL_TX_CLK, 
	output CHNL_TX, 
	input CHNL_TX_ACK, 
	output CHNL_TX_LAST, 
	output [31:0] CHNL_TX_LEN, 
	output [30:0] CHNL_TX_OFF, 
	output [C_PCI_DATA_WIDTH-1:0] CHNL_TX_DATA, 
	output CHNL_TX_DATA_VALID, 
	input CHNL_TX_DATA_REN
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
__riffa2ahir_slave_instance

//replace in_pipe_name with different input_pipe_names
//replace out_pipe_name with different output_pipe_names
//repeat instantiation of single data/req/ack pair for both rx and tx with different chnl_index numbers
__ahir_system_instance

endmodule;
