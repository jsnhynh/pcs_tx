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
        compare_if_ready();
    endfunction

    function void write_exp(seq_item t);
        seq_item cpy;
        cpy = seq_item::type_id::create("cpy");
        cpy.copy(t);
        exp_q.push_back(cpy);
        compare_if_ready();
    endfunction

    function void compare_if_ready();
        seq_item in_t;
        seq_item act_t;
        seq_item exp_t;

        while ((act_q.size() > 0) && (exp_q.size() > 0)) begin
            if (in_q.size() > 0) begin
                in_t = in_q.pop_front();
            end else begin
                in_t = null;
            end

            act_t = act_q.pop_front();
            exp_t = exp_q.pop_front();

            if ((exp_t.A_n !== act_t.A_n) ||
                (exp_t.B_n !== act_t.B_n) ||
                (exp_t.C_n !== act_t.C_n) ||
                (exp_t.D_n !== act_t.D_n))
            begin
                if (in_t != null) begin
                    `uvm_error("SCOREBOARD",
                        $sformatf(
                            {"FAIL :\n",
                            "IN : TXD=0x%0h tx_enable=%0b tx_error=%0b tx_mode=%0b config_i=%0b loc_rcvr_status=%0b loc_lpi_req=%0b loc_update_done=%0b\n",
                            "EXP: A=%0d B=%0d C=%0d D=%0d\n",
                            "ACT: A=%0d B=%0d C=%0d D=%0d"},
                            in_t.TXD,
                            in_t.tx_enable,
                            in_t.tx_error,
                            in_t.tx_mode,
                            in_t.config_i,
                            in_t.loc_rcvr_status,
                            in_t.loc_lpi_req,
                            in_t.loc_update_done,
                            exp_t.A_n, exp_t.B_n, exp_t.C_n, exp_t.D_n,
                            act_t.A_n, act_t.B_n, act_t.C_n, act_t.D_n
                        )
                    );
                end else begin
                    `uvm_error("SCOREBOARD",
                        $sformatf(
                            {"FAIL :\n",
                            "EXP: A=%0d B=%0d C=%0d D=%0d\n",
                            "ACT: A=%0d B=%0d C=%0d D=%0d"},
                            exp_t.A_n, exp_t.B_n, exp_t.C_n, exp_t.D_n,
                            act_t.A_n, act_t.B_n, act_t.C_n, act_t.D_n
                        )
                    );
                end
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        if ((act_q.size() != 0) || (exp_q.size() != 0)) begin
            `uvm_error("SCOREBOARD",
                $sformatf(
                    "Unmatched transactions remain: actual=%0d expected=%0d",
                    act_q.size(),
                    exp_q.size()
                )
            );
        end
    endfunction

endclass

`endif
