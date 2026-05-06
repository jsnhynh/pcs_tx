`ifndef SEQ_ITEM_SV
`define SEQ_ITEM_SV

class seq_item extends uvm_sequence_item;
    `uvm_object_utils(seq_item)

    // input fields
    rand logic [8:0] enc_in;
    int unsigned     scenario_id;

    // output fields
    logic [11:0]     enc_out;

    function new(string name = "seq_item");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("enc_in", enc_in, 9, UVM_HEX);
        printer.print_field_int("scenario_id", scenario_id, 32, UVM_DEC);
        printer.print_field("enc_out", enc_out, 12, UVM_HEX);
    endfunction

    function void do_copy(uvm_object rhs);
        seq_item rhs_;
        if (!$cast(rhs_, rhs)) begin
            `uvm_fatal("TYPE", "do_copy: type mismatch")
        end
        super.do_copy(rhs);
        enc_in           = rhs_.enc_in;
        scenario_id      = rhs_.scenario_id;
        enc_out          = rhs_.enc_out;
    endfunction

    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        seq_item rhs_;
        if (!$cast(rhs_, rhs)) return 0;
        return (super.do_compare(rhs, comparer) &&
                (enc_in          === rhs_.enc_in)          &&
                (scenario_id     ==  rhs_.scenario_id)     &&
                (enc_out         === rhs_.enc_out));
    endfunction

endclass

`endif
