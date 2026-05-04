`ifndef SEQUENCE_SV
`define SEQUENCE_SV

class base_sequence extends uvm_sequence #(seq_item);
    `uvm_object_utils(base_sequence)

    function new(string name = "base_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item item;

        item = seq_item::type_id::create("item");
        start_item(item);
        item.TXD              = 8'h55;
        item.tx_enable        = 1'b1;
        item.tx_error         = 1'b0;
        item.tx_mode          = 1'b0;
        item.config_i         = 1'b1;
        item.loc_rcvr_status  = 1'b0;
        item.loc_lpi_req      = 1'b0;
        item.loc_update_done  = 1'b0;
        finish_item(item);
    endtask
endclass

`endif
