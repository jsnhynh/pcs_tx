`ifndef AGENT_SV
`define AGENT_SV

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    sequencer      sqr;
    driver         drv;
    monitor_in  mon;

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon = monitor_in::type_id::create("mon", this);

        if (get_is_active()) begin
            sqr = sequencer::type_id::create("sqr", this);
            drv = driver::type_id::create("drv", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active()) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction

endclass

`endif
