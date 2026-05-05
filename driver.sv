`ifndef DRIVER_SV
`define DRIVER_SV

class driver extends uvm_driver #(seq_item);
    `uvm_component_utils(driver)

    virtual pcs_tx_mon_if vif;

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual pcs_tx_mon_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "virtual interface not set for driver")
        end
    endfunction

    task run_phase(uvm_phase phase);
        seq_item item;

        forever begin
            seq_item_port.get_next_item(item);

            @(vif.drv_cb);
            vif.drv_cb.TXD              <= item.TXD;
            vif.drv_cb.tx_enable        <= item.tx_enable;
            vif.drv_cb.tx_error         <= item.tx_error;
            vif.drv_cb.tx_mode          <= item.tx_mode;
            vif.drv_cb.config_i         <= item.config_i;
            vif.drv_cb.loc_rcvr_status  <= item.loc_rcvr_status;
            vif.drv_cb.loc_lpi_req      <= item.loc_lpi_req;
            vif.drv_cb.loc_update_done  <= item.loc_update_done;
            vif.drv_cb.scenario_id      <= item.scenario_id;

            seq_item_port.item_done();
        end
    endtask

endclass

`endif
