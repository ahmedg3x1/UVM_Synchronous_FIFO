////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////

module FIFO(FIFO_interface.DUT FIFO_if);

localparam max_fifo_addr = $clog2(FIFO_if.FIFO_DEPTH);

reg [FIFO_if.FIFO_WIDTH-1:0] mem [FIFO_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		wr_ptr <= 0;
		FIFO_if.wr_ack <= 0;   // reset wr_ack flag
		FIFO_if.overflow <= 0; // reset overflow flag
	end 
	else begin
		if (FIFO_if.wr_en && count < FIFO_if.FIFO_DEPTH) begin
			mem[wr_ptr] <= FIFO_if.data_in;
			FIFO_if.wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
		end
		else  
			FIFO_if.wr_ack <= 0; 

		if (FIFO_if.full & FIFO_if.wr_en) // move the overflow flag outside the else branch
			FIFO_if.overflow <= 1;
		else
			FIFO_if.overflow <= 0;
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		rd_ptr <= 0;
		FIFO_if.underflow <= 0; // reset underflow flag
	end 
	else begin
		if (FIFO_if.rd_en && count != 0) begin
			FIFO_if.data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
		end
		
		if (FIFO_if.empty & FIFO_if.rd_en) //changing underflow flag from comb. to seq.
			FIFO_if.underflow <= 1;
		else
			FIFO_if.underflow <= 0;
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b10) && !FIFO_if.full) 
			count <= count + 1;
		else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b01) && !FIFO_if.empty)
			count <= count - 1;
		else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.empty) //add mising cases
			count <= count + 1;
		else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.full)
			count <= count - 1;
	end
end

assign FIFO_if.full = (count == FIFO_if.FIFO_DEPTH)? 1 : 0;
assign FIFO_if.empty = (count == 0)? 1 : 0;
assign FIFO_if.almostfull = (count == FIFO_if.FIFO_DEPTH-1)? 1 : 0; //changing FIFO_DEPTH-2 to FIFO_DEPTH-1
assign FIFO_if.almostempty = (count == 1)? 1 : 0;

endmodule