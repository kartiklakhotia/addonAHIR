ahir_system logic_block(
	.clk(down_clk),
	.reset(RST),
// pipe_signals_start
	.in_pipe_name_pipe_write_data(rData[C_PCI_WIDTH*CHNL_INDEX +:C_PCI_WIDTH]),
	.in_pipe_name_pipe_write_req(in_data_pipe_write_req[CHNL_INDEX]), 
	.in_pipe_name_pipe_write_ack(in_data_pipe_write_ack[CHNL_INDEX]), 
	.out_pipe_name_pipe_read_data(tData[C_PCI_WIDTH*CHNL_INDEX +:C_PCI_WIDTH]),
	.out_pipe_name_pipe_read_req(out_data_pipe_read_req[CHNL_INDEX]), 
	.out_pipe_name_pipe_read_ack(out_data_pipe_read_ack[CHNL_INDEX]) 
// pipe_signals_end
);	
