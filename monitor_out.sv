`ifndef MON_PCS_TX_OUT_SV
`define MON_PCS_TX_OUT_SV

class mon_pcs_tx_out extends uvm_monitor;
    `uvm_component_utils(mon_pcs_tx_out)

    virtual pcs_tx_out_if vif;

    uvm_analysis_port #(seq_item) ap;

    function new(string name = "mon_pcs_tx_out", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap = new("ap", this);

        if (!uvm_config_db #(virtual pcs_tx_out_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "virtual interface not set for mon_pcs_tx_out")
        end
    endfunction

    task run_phase(uvm_phase phase);
        seq_item txn;

        forever begin
            @(vif.mon_cb);
            if (vif.mon_cb.rst) continue;

            txn = seq_item::type_id::create("txn");
            txn.A_n = vif.mon_cb.A_n;
            txn.B_n = vif.mon_cb.B_n;
            txn.C_n = vif.mon_cb.C_n;
            txn.D_n = vif.mon_cb.D_n;

            ap.write(txn);
        end
    endtask

endclass

`endif
