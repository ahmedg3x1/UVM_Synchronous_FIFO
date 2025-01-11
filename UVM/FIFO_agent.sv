package FIFO_agent_pkg;
    import FIFO_config_obj_pkg::*;
    import FIFO_sequence_item_pkg::*;
    import FIFO_sequencer_pkg::*;
    import FIFO_monitor_pkg::*;
    import FIFO_driver_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_agent extends uvm_agent;
        `uvm_component_utils(FIFO_agent)

        FIFO_config_obj config_obj;
        FIFO_monitor monitor ;
        FIFO_sequencer sequencer;
        FIFO_driver driver;

        uvm_analysis_port #(FIFO_sequence_item) agt_ap;

        FIFO_sequence_item seq_item;
        function new(string name = "FIFO_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
                config_obj = FIFO_config_obj::type_id::create("config_obj");
                monitor = FIFO_monitor::type_id::create("monitor", this);
                sequencer = FIFO_sequencer::type_id::create("sequencer", this);
                driver = FIFO_driver::type_id::create("driver", this);
                if(!uvm_config_db #(FIFO_config_obj)::get(this, "", "FIFO_CONFIG_OBJ_TEST", config_obj))
                    `uvm_fatal("agent_build_phase", "can not get the iterface");

                agt_ap = new("agt_ap", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            monitor.FIFO_if = config_obj.FIFO_if;
            driver.FIFO_if = config_obj.FIFO_if;

            driver.seq_item_port.connect(sequencer.seq_item_export);
            monitor.mon_ap.connect(agt_ap);
        endfunction
        
    endclass
endpackage