`ifndef SEQ_ITEM_SV
`define SEQ_ITEM_SV

class seq_item extends uvm_sequence_item;
    `uvm_object_utils(seq_item)

    rand logic [7:0] Din;
    rand logic       TX_EN;
    int unsigned     scenario_id;

    logic [3:0][2:0] Dout;

    constraint dut_input_dist {
        TX_EN dist { 1 := 75, 0 := 25 };
    }

    function new(string name = "seq_item");
        super.new(name);
    endfunction

    // called by scoreboard's write_* functions for deep-copy into queues
    function void do_copy(uvm_object rhs);
        seq_item rhs_;
        if (!$cast(rhs_, rhs)) begin
            `uvm_fatal("TYPE", "do_copy: type mismatch")
        end
        super.do_copy(rhs);
        Din         = rhs_.Din;
        TX_EN       = rhs_.TX_EN;
        scenario_id = rhs_.scenario_id;
        Dout        = rhs_.Dout;
    endfunction

endclass

`endif
