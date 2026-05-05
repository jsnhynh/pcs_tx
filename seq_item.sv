`ifndef SEQ_ITEM_SV
`define SEQ_ITEM_SV

class seq_item extends uvm_sequence_item;
    `uvm_object_utils(seq_item)

    // input fields
    rand logic [7:0] TXD;
    rand logic       tx_enable;
    rand logic       tx_error;
    rand logic       tx_mode;
    logic            config_i;
    rand logic       loc_rcvr_status;
    rand logic       loc_lpi_req;
    rand logic       loc_update_done;
    int unsigned     scenario_id;

    // output fields
    logic signed [2:0] A_n;
    logic signed [2:0] B_n;
    logic signed [2:0] C_n;
    logic signed [2:0] D_n;

    constraint c_default {
        tx_error        dist { 0 := 80, 1 := 20 };
        tx_mode         dist { 0 := 85, 1 := 15 };
        loc_rcvr_status dist { 0 := 70, 1 := 30 };
        loc_lpi_req     dist { 0 := 80, 1 := 20 };
        loc_update_done dist { 0 := 70, 1 := 30 };
    }

    function new(string name = "seq_item");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("TXD",              TXD,              8, UVM_HEX);
        printer.print_field("tx_enable",        tx_enable,        1, UVM_BIN);
        printer.print_field("tx_error",         tx_error,         1, UVM_BIN);
        printer.print_field("tx_mode",          tx_mode,          1, UVM_BIN);
        printer.print_field("config_i",         config_i,         1, UVM_BIN);
        printer.print_field("loc_rcvr_status",  loc_rcvr_status,  1, UVM_BIN);
        printer.print_field("loc_lpi_req",      loc_lpi_req,      1, UVM_BIN);
        printer.print_field("loc_update_done",  loc_update_done,  1, UVM_BIN);
        printer.print_field_int("scenario_id", scenario_id, 32, UVM_DEC);
        printer.print_field_int("A_n", A_n, 3, UVM_DEC);
        printer.print_field_int("B_n", B_n, 3, UVM_DEC);
        printer.print_field_int("C_n", C_n, 3, UVM_DEC);
        printer.print_field_int("D_n", D_n, 3, UVM_DEC);
    endfunction

    function void do_copy(uvm_object rhs);
        seq_item rhs_;
        if (!$cast(rhs_, rhs)) begin
            `uvm_fatal("TYPE", "do_copy: type mismatch")
        end
        super.do_copy(rhs);
        TXD              = rhs_.TXD;
        tx_enable        = rhs_.tx_enable;
        tx_error         = rhs_.tx_error;
        tx_mode          = rhs_.tx_mode;
        config_i         = rhs_.config_i;
        loc_rcvr_status  = rhs_.loc_rcvr_status;
        loc_lpi_req      = rhs_.loc_lpi_req;
        loc_update_done  = rhs_.loc_update_done;
        scenario_id      = rhs_.scenario_id;
        A_n              = rhs_.A_n;
        B_n              = rhs_.B_n;
        C_n              = rhs_.C_n;
        D_n              = rhs_.D_n;
    endfunction

    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        seq_item rhs_;
        if (!$cast(rhs_, rhs)) return 0;
        return (super.do_compare(rhs, comparer) &&
                (TXD             === rhs_.TXD)             &&
                (tx_enable       === rhs_.tx_enable)       &&
                (tx_error        === rhs_.tx_error)        &&
                (tx_mode         === rhs_.tx_mode)         &&
                (config_i        === rhs_.config_i)        &&
                (loc_rcvr_status === rhs_.loc_rcvr_status) &&
                (loc_lpi_req     === rhs_.loc_lpi_req)     &&
                (loc_update_done === rhs_.loc_update_done) &&
                (scenario_id     ==  rhs_.scenario_id)     &&
                (A_n             === rhs_.A_n)             &&
                (B_n             === rhs_.B_n)             &&
                (C_n             === rhs_.C_n)             &&
                (D_n             === rhs_.D_n));
    endfunction

endclass

`endif
