package FIFO_cover_pkg;
    import FIFO_sequence_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_cover extends uvm_component;
        `uvm_component_utils(FIFO_cover)


        uvm_analysis_export #(FIFO_sequence_item) cov_aexport;
        uvm_tlm_analysis_fifo #(FIFO_sequence_item) cov_fifo;

        FIFO_sequence_item seq_item;
        
        covergroup cvr;
           wr_ack      : cross seq_item.wr_en, seq_item.rd_en, seq_item.wr_ack;
           full        : cross seq_item.wr_en, seq_item.rd_en, seq_item.full;
           overflow    : cross seq_item.wr_en, seq_item.rd_en, seq_item.overflow;
           empty       : cross seq_item.wr_en, seq_item.rd_en, seq_item.empty;
           almostfull  : cross seq_item.wr_en, seq_item.rd_en, seq_item.almostfull;
           almostempty : cross seq_item.wr_en, seq_item.rd_en, seq_item.almostempty;
           underflow   : cross seq_item.wr_en, seq_item.rd_en, seq_item.underflow;
        endgroup

        function new(string name = "FIFO_cover", uvm_component parent = null);
            super.new(name, parent);
            cvr = new;
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
                cov_aexport = new("cov_aexport", this);
                cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_aexport.connect(cov_fifo.analysis_export);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item);
                cvr.sample();
            end
        endtask

    endclass
endpackage