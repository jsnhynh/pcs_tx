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

    int in_rcv_count;
    int act_rcv_count;
    int exp_rcv_count;
    int compare_count;
    int match_count;
    int fail_count;
    int max_mismatch_log = 20;
    int seq_compare_count[int unsigned];
    int seq_match_count[int unsigned];
    int seq_fail_count[int unsigned];

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_in  = new("ap_in",  this);
        ap_act = new("ap_act", this);
        ap_exp = new("ap_exp", this);
        void'($value$plusargs("SCB_MAX_MISMATCH_LOG=%d", max_mismatch_log));
    endfunction

    function seq_item clone_item(seq_item t);
        seq_item cpy;
        cpy = seq_item::type_id::create("cpy");
        cpy.copy(t);
        return cpy;
    endfunction

    function void write_in(seq_item t);
        in_q.push_back(clone_item(t));
        in_rcv_count++;
        compare_if_ready();
    endfunction

    function void write_act(seq_item t);
        act_q.push_back(clone_item(t));
        act_rcv_count++;
        compare_if_ready();
    endfunction

    function void write_exp(seq_item t);
        exp_q.push_back(clone_item(t));
        exp_rcv_count++;
        compare_if_ready();
    endfunction

    function string fmt_out(seq_item t);
        return $sformatf("{A:%0d B:%0d C:%0d D:%0d}",
                         $signed(t.Dout[3]), $signed(t.Dout[2]),
                         $signed(t.Dout[1]), $signed(t.Dout[0]));
    endfunction

    function string scenario_name(int unsigned scenario_id);
        case (scenario_id)
            1: return "data_sweep";
            2: return "packet_bursts";
            3: return "disable_patterns";
            4: return "transitions";
            5: return "random";
            6: return "corner_cases";
            default: return "idle";
        endcase
    endfunction

    function string fmt_in(seq_item t);
        return $sformatf("seq=%s Din=0x%02h TX_EN=%0b",
                         scenario_name(t.scenario_id), t.Din, t.TX_EN);
    endfunction

    function string mismatch_lanes(seq_item exp_t, seq_item act_t);
        string lanes = "";
        if (exp_t.Dout[3] !== act_t.Dout[3]) lanes = {lanes, " A"};
        if (exp_t.Dout[2] !== act_t.Dout[2]) lanes = {lanes, " B"};
        if (exp_t.Dout[1] !== act_t.Dout[1]) lanes = {lanes, " C"};
        if (exp_t.Dout[0] !== act_t.Dout[0]) lanes = {lanes, " D"};
        return lanes;
    endfunction

    function void compare_if_ready();
        seq_item in_t;
        seq_item act_t;
        seq_item exp_t;

        while ((in_q.size() > 0) && (act_q.size() > 0) && (exp_q.size() > 0)) begin
            in_t = in_q.pop_front();
            act_t = act_q.pop_front();
            exp_t = exp_q.pop_front();
            compare_count++;
            seq_compare_count[in_t.scenario_id]++;

            if (exp_t.Dout !== act_t.Dout) begin
                fail_count++;
                seq_fail_count[in_t.scenario_id]++;
                if (fail_count <= max_mismatch_log) begin
                    `uvm_error("SCB_MISMATCH",
                        $sformatf("compare[%0d] mismatched fields:%s input={%s} exp=%s act=%s",
                                  compare_count, mismatch_lanes(exp_t, act_t),
                                  fmt_in(in_t), fmt_out(exp_t), fmt_out(act_t)))
                end else if (fail_count == (max_mismatch_log + 1)) begin
                    `uvm_error("SCB_MISMATCH",
                        $sformatf("more than %0d mismatches seen; suppressing per-item details",
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
            `uvm_info("SCB_SEQ", $sformatf("%s: seq=%s compared=%0d pass=%0d fail=%0d",
                status,
                scenario_name(scenario_id),
                seq_compare_count[scenario_id],
                seq_match_count[scenario_id],
                seq_fail_count[scenario_id]), UVM_NONE)
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("SCB", $sformatf(
            "received: in=%0d act=%0d exp=%0d compared=%0d match=%0d fail=%0d leftover: in_q=%0d act_q=%0d exp_q=%0d",
            in_rcv_count, act_rcv_count, exp_rcv_count, compare_count, match_count,
            fail_count, in_q.size(), act_q.size(), exp_q.size()), UVM_NONE)

        if (compare_count == 0)
            `uvm_error("SCB", "FAIL: no output samples were compared")
        else if (fail_count == 0)
            `uvm_info("SCB", $sformatf("PASS: %0d items matched", match_count), UVM_NONE)
        else
            `uvm_error("SCB", $sformatf("FAIL: %0d mismatches; PASS: %0d matched",
                                        fail_count, match_count))

        if ((in_q.size() != 0) || (act_q.size() != 0) || (exp_q.size() != 0))
            `uvm_error("SCB", $sformatf("leftover items: in=%0d act=%0d exp=%0d",
                                        in_q.size(), act_q.size(), exp_q.size()))

        report_sequence_summary();
    endfunction

endclass

`endif
