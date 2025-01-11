import FIFO_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top;
    bit clk;
    initial begin
        forever
            #10 clk = ~clk;
    end
    
    FIFO_interface FIFO_if(clk);
    FIFO DUT(FIFO_if);
    bind FIFO FIFO_SVA FIFO_SVA_inst(FIFO_if);
    initial begin

        uvm_config_db #(virtual FIFO_interface)::set(null, "uvm_test_top", "FIFO_VIF", FIFO_if);
        run_test("FIFO_test");
    end
endmodule