	.__in_pipe_name___pipe_write_data(rData[C_PCI_DATA_WIDTH*__CHNL_INDEX__ +:C_PCI_DATA_WIDTH]),
	.__in_pipe_name___pipe_write_req(in_data_pipe_write_req[__CHNL_INDEX__]), 
	.__in_pipe_name___pipe_write_ack(in_data_pipe_write_ack[__CHNL_INDEX__]), 
	.__out_pipe_name___pipe_read_data(tData[C_PCI_DATA_WIDTH*__CHNL_INDEX__ +:C_PCI_DATA_WIDTH]),
	.__out_pipe_name___pipe_read_req(out_data_pipe_read_req[__CHNL_INDEX__]), 
	.__out_pipe_name___pipe_read_ack(out_data_pipe_read_ack[__CHNL_INDEX__]) 
