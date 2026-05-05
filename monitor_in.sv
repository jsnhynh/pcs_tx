`ifndef MON_PCS_TX_IN_SV
`define MON_PCS_TX_IN_SV

class mon_pcs_tx_in extends uvm_monitor;
    `uvm_component_utils(mon_pcs_tx_in)

    virtual pcs_tx_mon_if vif;

    uvm_analysis_port #(seq_item) ap;

    function new(string name = "mon_pcs_tx_in", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap = new("ap", this);

        if (!uvm_config_db #(virtual pcs_tx_mon_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "virtual interface not set for mon_pcs_tx_in")
        end
    endfunction

    task run_phase(uvm_phase phase);
        seq_item txn;

        forever begin
            @(vif.mon_cb);
            if (vif.mon_cb.rst) continue;

            txn = seq_item::type_id::create("txn");
            txn.TXD              = vif.mon_cb.TXD;
            txn.tx_enable        = vif.mon_cb.tx_enable;
            txn.tx_error         = vif.mon_cb.tx_error;
            txn.tx_mode          = vif.mon_cb.tx_mode;
            txn.config_i         = vif.mon_cb.config_i;
            txn.loc_rcvr_status  = vif.mon_cb.loc_rcvr_status;
            txn.loc_lpi_req      = vif.mon_cb.loc_lpi_req;
            txn.loc_update_done  = vif.mon_cb.loc_update_done;
            txn.scenario_id      = vif.mon_cb.scenario_id;

            ap.write(txn);
        end
    endtask

endclass

`endif
