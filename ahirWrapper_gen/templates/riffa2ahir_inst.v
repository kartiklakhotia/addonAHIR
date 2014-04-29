riffa2ahir_slave #(
.C_PCI_DATA_WIDTH(C_PCI_DATA_WIDTH),
.TX_DATA_LEN(OUT_CHNL_INDEX_DATA_LEN),
) interface_CHNL_INDEX (
	.CLK(down_clk),
	.RST(RST),
	.CHNL_RX(CHNL_RX[CHNL_INDEX]),
	.CHNL_RX_ACK(CHNL_RX_ACK[CHNL_INDEX]),			
	.CHNL_RX_LEN(CHNL_RX_LEN[32*CHNL_INDEX +:31]),
	.CHNL_RX_DATA(CHNL_RX_DATA[C_PCI_WIDTH*CHNL_INDEX +:C_PCI_WIDTH]),
	.CHNL_RX_DATA_VALID(CHNL_RX_DATA_VALID[CHNL_INDEX]),
	.CHNL_RX_DATA_REN(CHNL_RX_DATA_REN[CHNL_INDEX]),
	.CHNL_TX(CHNL_TX[CHNL_INDEX]),
	.CHNL_TX_ACK(CHNL_TX_ACK[CHNL_INDEX]),
	.CHNL_TX_LEN(CHNL_TX_LEN[32*CHNL_INDEX +:31]),
	.CHNL_TX_DATA(CHNL_TX_DATA[C_PCI_WIDTH*CHNL_INDEX +:C_PCI_WIDTH]),
	.CHNL_TX_DATA_VALID(CHNL_TX_DATA_VALID[CHNL_INDEX]),
	.CHNL_TX_DATA_REN(CHNL_TX_DATA_REN[CHNL_INDEX]),
	.in_data_pipe_write_data(rData[C_PCI_WIDTH*CHNL_INDEX +:C_PCI_WIDTH]),
	.in_data_pipe_write_req(in_data_pipe_write_req[CHNL_INDEX]),
	.in_data_pipe_write_ack(in_data_pipe_write_ack[CHNL_INDEX]),
	.out_data_pipe_read_data(tData[C_PCI_WIDTH*CHNL_INDEX +:C_PCI_WIDTH]),
	.out_data_pipe_read_req(out_data_pipe_read_req[CHNL_INDEX]),
	.out_data_pipe_read_ack(out_data_pipe_read_ack[CHNL_INDEX])
);

