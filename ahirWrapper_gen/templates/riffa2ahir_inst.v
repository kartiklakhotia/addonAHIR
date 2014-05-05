riffa2ahir #(
.C_PCI_DATA_WIDTH(C_PCI_DATA_WIDTH),
.TX_DATA_LEN(CHNL__CHNL_INDEX___OUT_DATA_LEN)
) interface__CHNL_INDEX__ (
	.CLK(down_clk),
	.RST(RST),
	.CHNL_RX(CHNL_RX[__CHNL_INDEX__]),
	.CHNL_RX_ACK(CHNL_RX_ACK[__CHNL_INDEX__]),			
	.CHNL_RX_LEN(CHNL_RX_LEN[32*__CHNL_INDEX__ +:31]),
	.CHNL_RX_DATA(CHNL_RX_DATA[C_PCI_DATA_WIDTH*__CHNL_INDEX__ +:C_PCI_DATA_WIDTH]),
	.CHNL_RX_DATA_VALID(CHNL_RX_DATA_VALID[__CHNL_INDEX__]),
	.CHNL_RX_DATA_REN(CHNL_RX_DATA_REN[__CHNL_INDEX__]),
	.CHNL_TX(CHNL_TX[__CHNL_INDEX__]),
	.CHNL_TX_ACK(CHNL_TX_ACK[__CHNL_INDEX__]),
	.CHNL_TX_LEN(CHNL_TX_LEN[32*__CHNL_INDEX__ +:31]),
	.CHNL_TX_DATA(CHNL_TX_DATA[C_PCI_DATA_WIDTH*__CHNL_INDEX__ +:C_PCI_DATA_WIDTH]),
	.CHNL_TX_DATA_VALID(CHNL_TX_DATA_VALID[__CHNL_INDEX__]),
	.CHNL_TX_DATA_REN(CHNL_TX_DATA_REN[__CHNL_INDEX__]),
	.in_data_pipe_write_data(rData[C_PCI_DATA_WIDTH*__CHNL_INDEX__ +:C_PCI_DATA_WIDTH]),
	.in_data_pipe_write_req(in_data_pipe_write_req[__CHNL_INDEX__]),
	.in_data_pipe_write_ack(in_data_pipe_write_ack[__CHNL_INDEX__]),
	.out_data_pipe_read_data(tData[C_PCI_DATA_WIDTH*__CHNL_INDEX__ +:C_PCI_DATA_WIDTH]),
	.out_data_pipe_read_req(out_data_pipe_read_req[__CHNL_INDEX__]),
	.out_data_pipe_read_ack(out_data_pipe_read_ack[__CHNL_INDEX__])
);

