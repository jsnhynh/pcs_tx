`ifndef DRIVER_SV
`define DRIVER_SV

class driver extends uvm_driver #(seq_item);
    `uvm_component_utils(driver)

    virtual encoder_if vif;

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual encoder_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "virtual interface not set for driver")
        end
    endfunction

    // drives seq_item fields onto the interface via clocking block
    task run_phase(uvm_phase phase);
        seq_item item;

        forever begin
            seq_item_port.get_next_item(item);

            @(vif.drv_cb);
            vif.drv_cb.tx_in       <= item.enc_in;
            vif.drv_cb.scenario_id <= item.scenario_id;

            seq_item_port.item_done();
        end
    endtask

endclass

`endif
