`ifndef MON_PCS_TX_OUT_SV
`define MON_PCS_TX_OUT_SV

class monitor_out extends uvm_monitor;
    `uvm_component_utils(monitor_out)

    virtual encoder_if vif;
    bit use_dut_output;

    uvm_analysis_port #(seq_item) ap;

    function new(string name = "monitor_out", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap = new("ap", this);

        if (!uvm_config_db #(virtual encoder_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "virtual interface not set for monitor_out")
        end
        void'(uvm_config_db #(bit)::get(this, "", "use_dut_output", use_dut_output));
    endfunction

    // captures output-side transactions: golden reference (use_dut_output=0)
    // or DUT output (use_dut_output=1), determined by uvm_config_db
    task run_phase(uvm_phase phase);
        seq_item txn;

        forever begin
            @(vif.mon_cb);
            if (!vif.mon_cb.rst_n) continue;

            txn = seq_item::type_id::create("txn");
            txn.enc_out = use_dut_output ? vif.mon_cb.tx_out : vif.mon_cb.tx_out_ref;

            ap.write(txn);
        end
    endtask

endclass

`endif
