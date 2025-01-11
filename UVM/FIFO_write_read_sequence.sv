package FIFO_write_read_sequence_pkg;
    import FIFO_sequence_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_write_read_sequence extends uvm_sequence #(FIFO_sequence_item);
        `uvm_object_utils(FIFO_write_read_sequence)
        FIFO_sequence_item seq_item;

        function new(string name = "FIFO_write_read_sequence");
            super.new(name);
        endfunction

        task body();
            repeat(6000) begin
                seq_item = FIFO_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage