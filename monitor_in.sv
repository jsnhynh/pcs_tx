`ifndef MON_PCS_TX_IN_SV
`define MON_PCS_TX_IN_SV

class monitor_in extends uvm_monitor;
    `uvm_component_utils(monitor_in)

    virtual encoder_if vif;

    uvm_analysis_port #(seq_item) ap;

    function new(string name = "monitor_in", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap = new("ap", this);

        if (!uvm_config_db #(virtual encoder_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "virtual interface not set for monitor_in")
        end
    endfunction

    // captures input-side transactions (enc_in, scenario_id) every cycle
    // sampled through mon_cb clocking block; skips during reset (rst_n active-low)
    task run_phase(uvm_phase phase);
        seq_item txn;

        forever begin
            @(vif.mon_cb);
            if (!vif.mon_cb.rst_n) continue;

            txn = seq_item::type_id::create("txn");
            txn.enc_in      = vif.mon_cb.tx_in;
            txn.scenario_id = vif.mon_cb.scenario_id;

            ap.write(txn);
        end
    endtask

endclass

`endif
