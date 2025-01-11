package FIFO_test_pkg;
    import FIFO_env_pkg::*;
    import FIFO_write_read_sequence_pkg::*;
    import FIFO_write_only_sequence_pkg::*;
    import FIFO_read_only_sequence_pkg::*;

    import FIFO_config_obj_pkg::*;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)
        FIFO_config_obj config_obj;
        FIFO_env env;
        FIFO_write_only_sequence wr_only_seq;
        FIFO_read_only_sequence rd_only_seq;
        FIFO_write_read_sequence wr_rd_seq;
        function new(string name = "FIFO_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
        
            super.build_phase(phase);
                config_obj = FIFO_config_obj::type_id::create("config_obj");
                env = FIFO_env::type_id::create("env", this);
                wr_only_seq = FIFO_write_only_sequence::type_id::create("wr_only_seq");
                rd_only_seq = FIFO_read_only_sequence::type_id::create("rd_only_seq");
                wr_rd_seq = FIFO_write_read_sequence::type_id::create("wr_rd_seq");
                
                if(!uvm_config_db #(virtual FIFO_interface)::get(this, "", "FIFO_VIF", config_obj.FIFO_if))
                    `uvm_fatal("test_build_phase", "can not get the iterface");
                
                uvm_config_db #(FIFO_config_obj)::set(this, "*", "FIFO_CONFIG_OBJ_TEST", config_obj);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            `uvm_info("run_phase", "stimulus generation for wr_only_seq start", UVM_LOW);
            wr_only_seq.start(env.agt.sequencer);
            `uvm_info("run_phase", "stimulus generation for wr_only_seq end", UVM_LOW);

            `uvm_info("run_phase", "stimulus generation for rd_only_seq start", UVM_LOW);
            rd_only_seq.start(env.agt.sequencer);
            `uvm_info("run_phase", "stimulus generation for rd_only_seq end", UVM_LOW);

            `uvm_info("run_phase", "stimulus generation for wr_rd_seq start", UVM_LOW);
            wr_rd_seq.start(env.agt.sequencer);
            `uvm_info("run_phase", "stimulus generation for wr_rd_seq end", UVM_LOW);
            phase.drop_objection(this);
        endtask
        
    endclass
endpackage