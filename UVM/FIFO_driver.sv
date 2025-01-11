package FIFO_driver_pkg;
    import FIFO_sequence_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_driver extends uvm_driver #(FIFO_sequence_item);
        `uvm_component_utils(FIFO_driver)
        virtual FIFO_interface FIFO_if;
        FIFO_sequence_item seq_item;
        function new(string name = "FIFO_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase); 
            forever begin
                super.run_phase(phase);
                seq_item = FIFO_sequence_item::type_id::create("seq_item");
                seq_item_port.get_next_item(seq_item);
                
                //input
                FIFO_if.data_in = seq_item.data_in;
                FIFO_if.rst_n   = seq_item.rst_n; 
                FIFO_if.wr_en   = seq_item.wr_en; 
                FIFO_if.rd_en   = seq_item.rd_en; 

                @(negedge FIFO_if.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase", seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage