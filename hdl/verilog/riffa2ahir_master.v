module riffa2ahir_master #(
	parameter C_PCI_DATA_WIDTH = 9'd32,
	//Local Parameters
	parameter numWords = C_PCI_DATA_WIDTH/32,
	parameter TX_DATA_LEN = 32'd120
)
(
	input CLK,
	input RST,
	input CHNL_RX,
	output CHNL_RX_ACK,
	input [31:0] CHNL_RX_LEN,
	input [C_PCI_DATA_WIDTH-1:0] CHNL_RX_DATA,
	input CHNL_RX_DATA_VALID,
	output CHNL_RX_DATA_REN,

	output CHNL_TX,
	input CHNL_TX_ACK,
	output [31:0] CHNL_TX_LEN,
	output [C_PCI_DATA_WIDTH-1:0] CHNL_TX_DATA,
	output CHNL_TX_DATA_VALID,
	input CHNL_TX_DATA_REN,


	output [C_PCI_DATA_WIDTH-1:0] in_data_pipe_write_data,
	output in_data_pipe_write_req,
	input in_data_pipe_write_ack,

	input [C_PCI_DATA_WIDTH-1:0] out_data_pipe_read_data,
	output out_data_pipe_read_req,
	input out_data_pipe_read_ack

);



reg [31:0] rLen=0;
reg [31:0] tLen=0;
reg [31:0] rCount=0;
reg rState=0;
reg tState=0;
reg [31:0] tCount=0;

assign CHNL_RX_DATA_REN = (in_data_pipe_write_ack & rState); 
assign out_data_pipe_read_req = (tState & CHNL_TX_DATA_REN);
assign in_data_pipe_write_req = (CHNL_RX_DATA_VALID & rState);
assign CHNL_TX_DATA_VALID = (out_data_pipe_read_ack & tState);
assign in_data_pipe_write_data = CHNL_RX_DATA;
assign CHNL_TX_DATA = out_data_pipe_read_data;


assign CHNL_RX_ACK = (rState == 1'd1);
assign CHNL_TX = (tState == 1'd1);
assign CHNL_TX_LEN = tLen; // in words



// Rx  and Tx state machine
always @(posedge CLK or posedge RST) begin
	if (RST) begin
		rLen <=  0;
		rCount <=  0;
		rState <=  0;
	end
	else begin
		case (rState)
		
		1'd0: begin // Wait for start of RX, save length
			if (CHNL_RX) begin
				rLen <=  CHNL_RX_LEN;
				rCount <=  0;
				rState <=  1'd1;
			end
		end
	
		1'd1 : begin // prepare for Rx. Store at first location
			if (rCount >= rLen)
				rState <=  1'd0;
			else if (CHNL_RX_DATA_VALID & in_data_pipe_write_ack)
				rCount <=  rCount + numWords;
		end
	

		endcase
	end
end


always @(posedge CLK or posedge RST) begin

	if (RST) begin
		tCount <=  0;
		tState <=  0;
	end
	else begin
		case (tState)
			1'd0: begin //Resting state
				tCount <=  0;
				if (rState) begin
					tState <=  1'd1;	
					tLen <= TX_DATA_LEN;
				end
			end
			
			1'd1: begin
				if (tCount >= tLen)
					tState <=  1'd0;
				else if (CHNL_TX_DATA_REN & out_data_pipe_read_ack)
					tCount <=  tCount + numWords;
			end	 
		endcase
	end
end	


endmodule
