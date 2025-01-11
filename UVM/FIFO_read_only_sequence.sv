package FIFO_read_only_sequence_pkg;
    import FIFO_sequence_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_read_only_sequence extends uvm_sequence #(FIFO_sequence_item);
        `uvm_object_utils(FIFO_read_only_sequence)
        FIFO_sequence_item seq_item;

        function new(string name = "FIFO_read_only_sequence");
            super.new(name);
        endfunction

        task body();
            repeat(6000) begin
                seq_item = FIFO_sequence_item::type_id::create("seq_item");
                seq_item.wr_en.rand_mode(0);
                seq_item.wr_en = 0;
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage