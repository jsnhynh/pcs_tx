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
    int act_rcv_count;
    int exp_rcv_count;

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

    function void compare_if_ready();
        seq_item in_t, act_t, exp_t;

        while ((act_q.size() > 0) && (exp_q.size() > 0)) begin
            in_t = (in_q.size() > 0) ? in_q.pop_front() : null;
            act_t = act_q.pop_front();
            exp_t = exp_q.pop_front();

            if ((exp_t.A_n !== act_t.A_n) ||
                (exp_t.B_n !== act_t.B_n) ||
                (exp_t.C_n !== act_t.C_n) ||
                (exp_t.D_n !== act_t.D_n))
            begin
                fail_count++;
                `uvm_error("SCB",
                    $sformatf("FAIL: exp={%0d,%0d,%0d,%0d} act={%0d,%0d,%0d,%0d}",
                              exp_t.A_n, exp_t.B_n, exp_t.C_n, exp_t.D_n,
                              act_t.A_n, act_t.B_n, act_t.C_n, act_t.D_n))
            end else begin
                match_count++;
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("SCB", $sformatf("received: act=%0d exp=%0d  compared: match=%0d fail=%0d  leftover: act_q=%0d exp_q=%0d",
            act_rcv_count, exp_rcv_count, match_count, fail_count, act_q.size(), exp_q.size()), UVM_NONE)

        if (fail_count == 0 && match_count > 0)
            `uvm_info("SCB", $sformatf("PASS: %0d items matched", match_count), UVM_NONE)
        else if (fail_count > 0)
            `uvm_error("SCB", $sformatf("FAIL: %0d mismatches, %0d matched", fail_count, match_count))

        if ((act_q.size() != 0) || (exp_q.size() != 0))
            `uvm_error("SCB", $sformatf("leftover items: act=%0d exp=%0d", act_q.size(), exp_q.size()))
    endfunction

endclass

`endif
