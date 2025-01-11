package FIFO_sequence_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    parameter FIFO_WIDTH = 16;
    class FIFO_sequence_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_sequence_item)
        //input
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;

        //output
        logic [FIFO_WIDTH-1:0] data_out; 
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        int RD_EN_ON_DIST = 30;
        int WR_EN_ON_DIST = 70;

        constraint c_rset {
            rst_n dist {0:/2, 1:/98};
        }

        constraint c_wr_en {
            wr_en dist {0:/(100-WR_EN_ON_DIST), 1:/WR_EN_ON_DIST};
        }

        constraint c_rd_en {
            rd_en dist {0:/(100-RD_EN_ON_DIST), 1:/RD_EN_ON_DIST};
        }
        
        function new(string name = "FIFO_sequence_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s  data_in = %0d, rst_n = %0d, wr_en = %0d, rd_en = %0d, data_out = %0d, wr_ack = %0d, overflow = %0d, full = %0d, empty = %0d, almostfull = %0d, almostempty = %0d, underflow = %0d",
            super.convert2string(), data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
        endfunction
    
        function string convert2string_stimulus();
            return $sformatf("data_in = %0d, rst_n = %0d, wr_en = %0d, rd_en = %0d", data_in, rst_n, wr_en, rd_en);
        endfunction
    endclass
endpackage