`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_act)
`uvm_analysis_imp_decl(_exp)

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp_in  #(seq_item, scoreboard) ap_in;
    uvm_analysis_imp_act #(seq_item, scoreboard) ap_act;
    uvm_analysis_imp_exp #(seq_item, scoreboard) ap_exp;

    seq_item in_q[$];
    seq_item act_q[$];
    seq_item exp_q[$];

    int match_count;
    int fail_count;
    int compare_count;
    int in_rcv_count;
    int act_rcv_count;
    int exp_rcv_count;
    int max_mismatch_log = 20;

    function new(string name, uvm_component par);
        super.new(name, par);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_in  = new("ap_in",  this);
        ap_act = new("ap_act", this);
        ap_exp = new("ap_exp", this);
    endfunction

    function void write_in(seq_item t);
        seq_item cpy;
        cpy = seq_item::type_id::create("cpy");
        cpy.copy(t);
        in_q.push_back(cpy);
        in_rcv_count++;
        compare_if_ready();
    endfunction

    function void write_act(seq_item t);
        seq_item cpy;
        cpy = seq_item::type_id::create("cpy");
        cpy.copy(t);
        act_q.push_back(cpy);
        act_rcv_count++;
        compare_if_ready();
    endfunction

    function void write_exp(seq_item t);
        seq_item cpy;
        cpy = seq_item::type_id::create("cpy");
        cpy.copy(t);
        exp_q.push_back(cpy);
        exp_rcv_count++;
        compare_if_ready();
    endfunction

    function string fmt_out(seq_item t);
        if (t == null) return "<none>";
        return $sformatf("{A:%0d B:%0d C:%0d D:%0d}",
                         t.A_n, t.B_n, t.C_n, t.D_n);
    endfunction

    function string fmt_in(seq_item t);
        if (t == null) return "<input not captured>";
        return $sformatf("TXD=0x%02h tx_en=%0b tx_err=%0b tx_mode=%0b cfg=%0b lrs=%0b lpi=%0b upd=%0b",
                         t.TXD, t.tx_enable, t.tx_error, t.tx_mode, t.config_i,
                         t.loc_rcvr_status, t.loc_lpi_req, t.loc_update_done);
    endfunction

    function string diff_fields(seq_item exp_t, seq_item act_t);
        string fields;
        fields = "";
        if (exp_t.A_n !== act_t.A_n) fields = {fields, " A"};
        if (exp_t.B_n !== act_t.B_n) fields = {fields, " B"};
        if (exp_t.C_n !== act_t.C_n) fields = {fields, " C"};
        if (exp_t.D_n !== act_t.D_n) fields = {fields, " D"};
        return fields;
    endfunction

    function void compare_if_ready();
        seq_item in_t, act_t, exp_t;

        while ((in_q.size() > 0) && (act_q.size() > 0) && (exp_q.size() > 0)) begin
            in_t = in_q.pop_front();
            act_t = act_q.pop_front();
            exp_t = exp_q.pop_front();
            compare_count++;

            if ((exp_t.A_n !== act_t.A_n) ||
                (exp_t.B_n !== act_t.B_n) ||
                (exp_t.C_n !== act_t.C_n) ||
                (exp_t.D_n !== act_t.D_n))
            begin
                fail_count++;
                if (fail_count <= max_mismatch_log) begin
                    `uvm_error("SCB_MISMATCH",
                        $sformatf("compare[%0d] mismatched fields:%s  input={%s}  exp=%s act=%s",
                                  compare_count, diff_fields(exp_t, act_t),
                                  fmt_in(in_t), fmt_out(exp_t), fmt_out(act_t)))
                end else if (fail_count == (max_mismatch_log + 1)) begin
                    `uvm_error("SCB_MISMATCH",
                        $sformatf("more than %0d mismatches seen; suppressing per-item details until summary",
                                  max_mismatch_log))
                end
            end else begin
                match_count++;
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("SCB", $sformatf("received: in=%0d act=%0d exp=%0d  compared=%0d match=%0d fail=%0d  leftover: in_q=%0d act_q=%0d exp_q=%0d",
            in_rcv_count, act_rcv_count, exp_rcv_count, compare_count, match_count, fail_count,
            in_q.size(), act_q.size(), exp_q.size()), UVM_NONE)

        if (compare_count == 0)
            `uvm_error("SCB", "FAIL: no output samples were compared")
        else if (fail_count == 0)
            `uvm_info("SCB", $sformatf("PASS: %0d items matched", match_count), UVM_NONE)
        else if (fail_count > 0)
            `uvm_error("SCB", $sformatf("FAIL: %0d mismatches, %0d matched", fail_count, match_count))

        if ((in_q.size() != 0) || (act_q.size() != 0) || (exp_q.size() != 0))
            `uvm_error("SCB", $sformatf("leftover items: in=%0d act=%0d exp=%0d", in_q.size(), act_q.size(), exp_q.size()))
    endfunction

endclass

`endif
