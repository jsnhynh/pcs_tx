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
    localparam int MAX_STALL_DEPTH = 200;

    int seq_compare_count[int unsigned];
    int seq_match_count[int unsigned];
    int seq_fail_count[int unsigned];
    int seq_lane_a_fail[int unsigned];
    int seq_lane_b_fail[int unsigned];
    int seq_lane_c_fail[int unsigned];
    int seq_lane_d_fail[int unsigned];

    bit seen_en_data[256];
    bit seen_dis_data[256];
    bit prev_valid;
    bit prev_tx_en;
    int tx_en_transition_count[4];
    int enabled_sample_count;
    int disabled_sample_count;

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

    function void update_input_coverage(seq_item t);
        if (t.TX_EN) begin
            seen_en_data[t.Din] = 1'b1;
            enabled_sample_count++;
        end else begin
            seen_dis_data[t.Din] = 1'b1;
            disabled_sample_count++;
        end

        if (prev_valid)
            tx_en_transition_count[{prev_tx_en, t.TX_EN}]++;

        prev_tx_en = t.TX_EN;
        prev_valid = 1'b1;
    endfunction

    function void check_stall();
        if (in_q.size() > MAX_STALL_DEPTH)
            `uvm_warning("SCB_STALL", $sformatf("in_q stalled at %0d", in_q.size()))
        if (act_q.size() > MAX_STALL_DEPTH)
            `uvm_warning("SCB_STALL", $sformatf("act_q stalled at %0d", act_q.size()))
        if (exp_q.size() > MAX_STALL_DEPTH)
            `uvm_warning("SCB_STALL", $sformatf("exp_q stalled at %0d", exp_q.size()))
    endfunction

    function void write_in(seq_item t);
        seq_item cpy;
        cpy = seq_item::type_id::create("cpy");
        cpy.copy(t);
        in_q.push_back(cpy);
        in_rcv_count++;
        update_input_coverage(cpy);
        compare_if_ready();
        check_stall();
    endfunction

    function void write_act(seq_item t);
        seq_item cpy;
        cpy = seq_item::type_id::create("cpy");
        cpy.copy(t);
        act_q.push_back(cpy);
        act_rcv_count++;
        compare_if_ready();
        check_stall();
    endfunction

    function void write_exp(seq_item t);
        seq_item cpy;
        cpy = seq_item::type_id::create("cpy");
        cpy.copy(t);
        exp_q.push_back(cpy);
        exp_rcv_count++;
        compare_if_ready();
        check_stall();
    endfunction

    function string fmt_out(seq_item t);
        if (t == null) return "<none>";
        return $sformatf("{A:%0d B:%0d C:%0d D:%0d}",
                         $signed(t.Dout[3]), $signed(t.Dout[2]),
                         $signed(t.Dout[1]), $signed(t.Dout[0]));
    endfunction

    function string fmt_in(seq_item t);
        if (t == null) return "<input not captured>";
        return $sformatf("seq=%s Din=0x%02h TX_EN=%0b",
                         scenario_name(t.scenario_id), t.Din, t.TX_EN);
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

    function string check_lanes(seq_item exp_t, seq_item act_t, int unsigned scn);
        string diff = "";
        if (exp_t.Dout[3] !== act_t.Dout[3]) begin
            diff = {diff, " A"}; lane_fail_count[0]++; seq_lane_a_fail[scn]++;
        end
        if (exp_t.Dout[2] !== act_t.Dout[2]) begin
            diff = {diff, " B"}; lane_fail_count[1]++; seq_lane_b_fail[scn]++;
        end
        if (exp_t.Dout[1] !== act_t.Dout[1]) begin
            diff = {diff, " C"}; lane_fail_count[2]++; seq_lane_c_fail[scn]++;
        end
        if (exp_t.Dout[0] !== act_t.Dout[0]) begin
            diff = {diff, " D"}; lane_fail_count[3]++; seq_lane_d_fail[scn]++;
        end
        return diff;
    endfunction

    function void check_dut_range(seq_item act_t);
        for (int lane = 0; lane < 4; lane++) begin
            logic signed [2:0] v;
            v = $signed(act_t.Dout[lane]);
            if ($isunknown(act_t.Dout[lane]))
                `uvm_error("SCB_RANGE", $sformatf("DUT lane %0d contains X", lane))
            else if (v < -3'sd2 || v > 3'sd2)
                `uvm_error("SCB_RANGE", $sformatf("DUT lane %0d out of range: %0d", lane, v))
        end
    endfunction

    function void compare_if_ready();
        seq_item in_t, act_t, exp_t;
        string mismatch_fields;

        while ((in_q.size() > 0) && (act_q.size() > 0) && (exp_q.size() > 0)) begin
            in_t = in_q.pop_front();
            act_t = act_q.pop_front();
            exp_t = exp_q.pop_front();
            compare_count++;
            seq_compare_count[in_t.scenario_id]++;

            check_dut_range(act_t);

            if (exp_t.Dout !== act_t.Dout) begin
                fail_count++;
                seq_fail_count[in_t.scenario_id]++;
                mismatch_fields = check_lanes(exp_t, act_t, in_t.scenario_id);
                if (fail_count <= max_mismatch_log) begin
                    `uvm_error("SCB_MISMATCH",
                        $sformatf("compare[%0d] mismatched fields:%s input={%s} exp=%s act=%s",
                                  compare_count, mismatch_fields,
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

    function int count_seen(bit seen[256]);
        int total = 0;
        foreach (seen[i]) if (seen[i]) total++;
        return total;
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

    function void report_coverage_summary();
        int en_cov;
        int dis_cov;
        en_cov = count_seen(seen_en_data);
        dis_cov = count_seen(seen_dis_data);
        `uvm_info("SCB_COV", $sformatf(
            "input coverage: TX_EN=1 Din=%0d/256 samples=%0d, TX_EN=0 Din=%0d/256 samples=%0d, transitions 00=%0d 01=%0d 10=%0d 11=%0d",
            en_cov, enabled_sample_count, dis_cov, disabled_sample_count,
            tx_en_transition_count[0], tx_en_transition_count[1],
            tx_en_transition_count[2], tx_en_transition_count[3]), UVM_NONE)
        if (en_cov != 256)
            `uvm_error("SCB_COV", $sformatf("missing enabled Din values: %0d", 256 - en_cov))
        if (dis_cov != 256)
            `uvm_error("SCB_COV", $sformatf("missing disabled Din values: %0d", 256 - dis_cov))
        foreach (tx_en_transition_count[i])
            if (tx_en_transition_count[i] == 0)
                `uvm_error("SCB_COV", $sformatf("missing TX_EN transition bin %0d", i))
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("SCB", $sformatf(
            "received: in=%0d act=%0d exp=%0d compared=%0d match=%0d fail=%0d leftover: in_q=%0d act_q=%0d exp_q=%0d",
            in_rcv_count, act_rcv_count, exp_rcv_count, compare_count, match_count, fail_count,
            in_q.size(), act_q.size(), exp_q.size()), UVM_NONE)

        if (compare_count == 0)
            `uvm_error("SCB", "FAIL: no output samples were compared")
        else if (fail_count == 0)
            `uvm_info("SCB", $sformatf("PASS: %0d items matched", match_count), UVM_NONE)
        else
            `uvm_error("SCB", $sformatf(
                "FAIL: %0d mismatches; PASS: %0d matched lane mismatches: A=%0d B=%0d C=%0d D=%0d",
                fail_count, match_count,
                lane_fail_count[0], lane_fail_count[1], lane_fail_count[2], lane_fail_count[3]))

        if ((in_q.size() != 0) || (act_q.size() != 0) || (exp_q.size() != 0))
            `uvm_error("SCB", $sformatf("leftover items: in=%0d act=%0d exp=%0d", in_q.size(), act_q.size(), exp_q.size()))

        report_sequence_summary();
        report_coverage_summary();
    endfunction

endclass

`endif
