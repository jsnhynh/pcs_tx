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
    int lane_fail_count[4];
    int max_mismatch_log = 20;
    int seq_compare_count[int unsigned];
    int seq_match_count[int unsigned];
    int seq_fail_count[int unsigned];
    int seq_lane_a_fail[int unsigned];
    int seq_lane_b_fail[int unsigned];
    int seq_lane_c_fail[int unsigned];
    int seq_lane_d_fail[int unsigned];

    function new(string name, uvm_component par);
        super.new(name, par);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_in  = new("ap_in",  this);
        ap_act = new("ap_act", this);
        ap_exp = new("ap_exp", this);
        void'($value$plusargs("SCB_MAX_MISMATCH_LOG=%d", max_mismatch_log));
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
        return $sformatf("seq=%s TXD=0x%02h tx_en=%0b tx_err=%0b tx_mode=%0b cfg=%0b lrs=%0b lpi=%0b upd=%0b",
                         scenario_name(t.scenario_id), t.TXD, t.tx_enable, t.tx_error, t.tx_mode, t.config_i,
                         t.loc_rcvr_status, t.loc_lpi_req, t.loc_update_done);
    endfunction

    function string scenario_name(int unsigned scenario_id);
        case (scenario_id)
            1:  return "normal_data_cfg1";
            2:  return "normal_data_cfg0";
            3:  return "random_run_cfg1";
            4:  return "tx_mode_tests";
            5:  return "special_rows";
            6:  return "sideband_perms";
            7:  return "error_injection";
            8:  return "corner_cases";
            9:  return "random_stress_cfg1";
            10: return "random_stress_cfg0";
            default: return "idle_or_unlabeled";
        endcase
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

    function void count_lane_mismatches(seq_item exp_t, seq_item act_t);
        if (exp_t.A_n !== act_t.A_n) lane_fail_count[0]++;
        if (exp_t.B_n !== act_t.B_n) lane_fail_count[1]++;
        if (exp_t.C_n !== act_t.C_n) lane_fail_count[2]++;
        if (exp_t.D_n !== act_t.D_n) lane_fail_count[3]++;
    endfunction

    function void count_seq_lane_mismatches(int unsigned scenario_id, seq_item exp_t, seq_item act_t);
        if (exp_t.A_n !== act_t.A_n) seq_lane_a_fail[scenario_id]++;
        if (exp_t.B_n !== act_t.B_n) seq_lane_b_fail[scenario_id]++;
        if (exp_t.C_n !== act_t.C_n) seq_lane_c_fail[scenario_id]++;
        if (exp_t.D_n !== act_t.D_n) seq_lane_d_fail[scenario_id]++;
    endfunction

    function void compare_if_ready();
        seq_item in_t, act_t, exp_t;

        while ((in_q.size() > 0) && (act_q.size() > 0) && (exp_q.size() > 0)) begin
            in_t = in_q.pop_front();
            act_t = act_q.pop_front();
            exp_t = exp_q.pop_front();
            compare_count++;
            seq_compare_count[in_t.scenario_id]++;

            if ((exp_t.A_n !== act_t.A_n) ||
                (exp_t.B_n !== act_t.B_n) ||
                (exp_t.C_n !== act_t.C_n) ||
                (exp_t.D_n !== act_t.D_n))
            begin
                fail_count++;
                seq_fail_count[in_t.scenario_id]++;
                count_lane_mismatches(exp_t, act_t);
                count_seq_lane_mismatches(in_t.scenario_id, exp_t, act_t);
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
                seq_match_count[in_t.scenario_id]++;
            end
        end
    endfunction

    function void report_sequence_summary();
        foreach (seq_compare_count[scenario_id]) begin
            string status;
            status = (seq_fail_count[scenario_id] == 0) ? "PASS" : "FAIL";
            `uvm_info("SCB_SEQ", $sformatf("%s: seq=%s compared=%0d pass=%0d fail=%0d lane_fail={A:%0d B:%0d C:%0d D:%0d}",
                status,
                scenario_name(scenario_id),
                seq_compare_count[scenario_id],
                seq_match_count[scenario_id],
                seq_fail_count[scenario_id],
                seq_lane_a_fail[scenario_id],
                seq_lane_b_fail[scenario_id],
                seq_lane_c_fail[scenario_id],
                seq_lane_d_fail[scenario_id]), UVM_NONE)
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
            `uvm_error("SCB", $sformatf("FAIL: %0d mismatches; PASS: %0d matched  lane mismatches: A=%0d B=%0d C=%0d D=%0d",
                fail_count, match_count,
                lane_fail_count[0], lane_fail_count[1], lane_fail_count[2], lane_fail_count[3]))

        if ((in_q.size() != 0) || (act_q.size() != 0) || (exp_q.size() != 0))
            `uvm_error("SCB", $sformatf("leftover items: in=%0d act=%0d exp=%0d", in_q.size(), act_q.size(), exp_q.size()))

        report_sequence_summary();
    endfunction

endclass

`endif
