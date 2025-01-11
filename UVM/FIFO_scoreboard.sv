package FIFO_scoreboard_pkg;
    import FIFO_sequence_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    parameter FIFO_DEPTH = 8;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);
    class FIFO_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(FIFO_scoreboard)

        uvm_analysis_export #(FIFO_sequence_item) sb_aexport;
        uvm_tlm_analysis_fifo #(FIFO_sequence_item) sb_fifo;

        FIFO_sequence_item seq_item;
        int error_count, correct_count;
        function new(string name = "FIFO_cover", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
                sb_aexport = new("sb_aexport", this);
                sb_fifo = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_aexport.connect(sb_fifo.analysis_export);
        endfunction

        logic [FIFO_WIDTH-1:0] data_out_ref; 
        logic wr_ack_ref, overflow_ref;

        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

        logic [FIFO_WIDTH-1:0] mem_ref [FIFO_DEPTH-1:0];
        logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
        logic [max_fifo_addr:0] count;  

        function void ref_model(FIFO_sequence_item seq_item);
            if (!seq_item.rst_n) begin
                rd_ptr = 0;
                underflow_ref = 0;
            end
            else begin
                if (seq_item.rd_en && count != 0) begin  
                    data_out_ref = mem_ref[rd_ptr];
                    rd_ptr = rd_ptr + 1;
                end 
                
                if (empty_ref & seq_item.rd_en)
                    underflow_ref = 1;
                else
                    underflow_ref = 0;
            end

            if (!seq_item.rst_n) begin
                wr_ptr = 0;
                wr_ack_ref = 0; 
                overflow_ref = 0;
            end
            else begin
                if (seq_item.wr_en && count < FIFO_DEPTH) begin
                    mem_ref[wr_ptr] = seq_item.data_in;
                    wr_ack_ref = 1;
                    wr_ptr = wr_ptr + 1;
                end
                else  
                    wr_ack_ref = 0; 

                if (full_ref & seq_item.wr_en)
                    overflow_ref = 1;
                else
                    overflow_ref = 0;
            end
            
            if (!seq_item.rst_n) begin
                count = 0;
            end
            else begin
                if	( ({seq_item.wr_en, seq_item.rd_en} == 2'b10) && !full_ref) 
                    count = count + 1;
                else if ( ({seq_item.wr_en, seq_item.rd_en} == 2'b01) && !empty_ref)
                    count = count - 1;
                else if ( ({seq_item.wr_en, seq_item.rd_en} == 2'b11) && empty_ref)
                    count = count + 1;
                else if ( ({seq_item.wr_en, seq_item.rd_en} == 2'b11) && full_ref)
                    count = count - 1;
            end
            

            full_ref = (count == FIFO_DEPTH)? 1 : 0;
            empty_ref = (count == 0)? 1 : 0;
            almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
            almostempty_ref = (count == 1)? 1 : 0;

        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item);
                ref_model(seq_item);

                if(seq_item.data_out != data_out_ref || seq_item.wr_ack != wr_ack_ref || seq_item.overflow != overflow_ref ||
                seq_item.full != full_ref || seq_item.empty != empty_ref || seq_item.almostfull != almostfull_ref ||
                seq_item.almostempty != almostempty_ref || seq_item.underflow != underflow_ref) 
                begin
                    $display(":: Error at time = %0t ::", $time);
                    $display("data_out    = %0h, expected = %0h", seq_item.data_out, data_out_ref); 
                    $display("wr_ack      = %0d, expected = %0d", seq_item.wr_ack, wr_ack_ref);
                    $display("overflow    = %0d, expected = %0d", seq_item.overflow, overflow_ref);
                    $display("full        = %0d, expected = %0d", seq_item.full, full_ref);
                    $display("empty       = %0d, expected = %0d", seq_item.empty, empty_ref);
                    $display("almostfull  = %0d, expected = %0d", seq_item.almostfull, almostfull_ref);
                    $display("almostempty = %0d, expected = %0d", seq_item.almostempty, almostempty_ref);
                    $display("underflow   = %0d, expected = %0d", seq_item.underflow, underflow_ref);
                    `uvm_error("sb_run_phase", $sformatf("comparsion faild :: %s, data_out_ref = %0h, wr_ack_ref = %0d, overflow_ref= %0d, full_ref= %0d, empty_ref= %0d, almostfull_ref= %0d,  almostempty_ref= %0d, underflow_ref= %0d",
                     seq_item.convert2string(), data_out_ref, wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref,  almostempty_ref, underflow_ref))

                    error_count++;
                end 
                    else
                        correct_count++;
                end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("sb_report_phase", $sformatf("correct_count = %0d", correct_count), UVM_MEDIUM);
            `uvm_info("sb_report_phase", $sformatf("error_count = %0d", error_count), UVM_MEDIUM);
        endfunction
    endclass
endpackage