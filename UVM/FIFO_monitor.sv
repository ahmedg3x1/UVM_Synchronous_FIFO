package FIFO_monitor_pkg;
    import FIFO_sequence_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_monitor extends uvm_monitor;
        `uvm_component_utils(FIFO_monitor)

        virtual FIFO_interface FIFO_if;
        uvm_analysis_port #(FIFO_sequence_item) mon_ap;

        FIFO_sequence_item seq_item;
        function new(string name = "FIFO_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase); 
            forever begin
                super.run_phase(phase);
                seq_item = FIFO_sequence_item::type_id::create("seq_item");
                @(negedge FIFO_if.clk);
                //input
                seq_item.data_in =  FIFO_if.data_in;
                seq_item.rst_n   =  FIFO_if.rst_n; 
                seq_item.wr_en   =  FIFO_if.wr_en; 
                seq_item.rd_en   =  FIFO_if.rd_en;

                //output
                seq_item.data_out    = FIFO_if.data_out;
                seq_item.wr_ack      = FIFO_if.wr_ack;
                seq_item.overflow    = FIFO_if.overflow;
                seq_item.full        = FIFO_if.full;
                seq_item.empty       = FIFO_if.empty;
                seq_item.almostfull  = FIFO_if.almostfull;
                seq_item.almostempty = FIFO_if.almostempty;
                seq_item.underflow   = FIFO_if.underflow;
                mon_ap.write(seq_item);
                `uvm_info("run_phase", seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage