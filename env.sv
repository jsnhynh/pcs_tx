`ifndef ENV_SV
`define ENV_SV

class env extends uvm_env;
    `uvm_component_utils(env)

    agent           agt;
    mon_pcs_tx_out  mon_out_gm;
    mon_pcs_tx_out  mon_out_dut;
    scoreboard      scb;

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agt          = agent::type_id::create("agt", this);
        mon_out_gm   = mon_pcs_tx_out::type_id::create("mon_out_gm", this);
        mon_out_dut  = mon_pcs_tx_out::type_id::create("mon_out_dut", this);
        scb          = scoreboard::type_id::create("scb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agt.mon.ap.connect(scb.ap_in);
        mon_out_gm.ap.connect(scb.ap_exp);
        mon_out_dut.ap.connect(scb.ap_act);
    endfunction

endclass

`endif
