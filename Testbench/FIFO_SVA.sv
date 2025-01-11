module FIFO_SVA(FIFO_interface.DUT FIFO_if);
	
	always_comb begin
		if(!FIFO_if.rst_n) begin
			wr_ack_reset_assertion 	  : assert final (!FIFO_if.wr_ack);
			overflow_reset_assertion  : assert final (!FIFO_if.overflow);
			underflow_reset_assertion : assert final (!FIFO_if.underflow);
			wr_ptr_reset_assertion	  : assert final (!DUT.wr_ptr);
			rd_ptr_reset_assertion	  : assert final (!DUT.rd_ptr);
			count_reset_assertion 	  : assert final (!DUT.count);
		end		
	end

	//WRITE_1
	always_comb begin
		if(DUT.count == FIFO_if.FIFO_DEPTH)
			full_assertion : assert (FIFO_if.full);
	end

	//WRITE_3
	always_comb begin
		if(DUT.count == FIFO_if.FIFO_DEPTH-1)
			almostfull_assertion : assert (FIFO_if.almostfull);
	end

	//READ_1
	always_comb begin
		if(!DUT.count)
			empty_assertion : assert (FIFO_if.empty);
	end

	//READ_3
	always_comb begin
		if(DUT.count == 1)
			almostempty_assertion : assert (FIFO_if.almostempty);
	end

	//WRITE_1
	property wr_ack_pr;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && !FIFO_if.full) |=> FIFO_if.wr_ack;
	endproperty

	//WRITE_2
	property overflow_pr;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && FIFO_if.full) |=> FIFO_if.overflow;
	endproperty

	//READ_2
	property underflow_pr;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.rd_en && FIFO_if.empty) |=> FIFO_if.underflow;
	endproperty

	//internal signal assertions//

	//WRITE_READ_1
	property count_up_pr;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) ((FIFO_if.wr_en  && !FIFO_if.full) && (!FIFO_if.rd_en || FIFO_if.empty)) |=> DUT.count == ($past(DUT.count) + 1);
	endproperty

	//WRITE_READ_2
	property count_down_pr;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) ((FIFO_if.rd_en && !FIFO_if.empty) && (!FIFO_if.wr_en || FIFO_if.full)) |=> DUT.count == ($past(DUT.count) - 1);
	endproperty

	//WRITE_READ_3
	property count_same_pr;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && FIFO_if.rd_en && !FIFO_if.full && !FIFO_if.empty) |=> DUT.count == $past(DUT.count);
	endproperty


	property wr_ptr_pr;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && !FIFO_if.full) |=> DUT.wr_ptr == ($past(DUT.wr_ptr) + 1);
	endproperty

	property rd_ptr_pr;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.rd_en && !FIFO_if.empty) |=> DUT.rd_ptr == ($past(DUT.rd_ptr) + 1);
	endproperty

	overflow_assertion:		 assert property(overflow_pr);
	underflow_assertion: 	 assert property(underflow_pr);
	wr_ack_assertion: 		 assert property(wr_ack_pr);
	count_up_pr_assertion: 	 assert property(count_up_pr);
	count_down_pr_assertion: assert property(count_down_pr);
	count_same_pr_assertion: assert property(count_same_pr);

	overflow_cover: 	 cover property(overflow_pr);
	underflow_cover: 	 cover property(underflow_pr);
	wr_ack_cover: 		 cover property(wr_ack_pr);
	count_up_pr_cover: 	 cover property(count_up_pr);
	count_down_pr_cover: cover property(count_down_pr);
	count_same_pr_cover: cover property(count_same_pr);
endmodule