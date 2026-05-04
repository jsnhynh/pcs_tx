`ifndef SEQUENCE_SV
`define SEQUENCE_SV

class comprehensive_sequence extends uvm_sequence #(seq_item);
    `uvm_object_utils(comprehensive_sequence)

    function new(string name = "comprehensive_sequence");
        super.new(name);
    endfunction

    task send(
        input logic [7:0] TXD_i,
        input logic       te_i,
        input logic       terr_i,
        input logic       tm_i,
        input logic       cfg_i,
        input logic       lrs_i,
        input logic       llr_i,
        input logic       lud_i
    );
        seq_item item;
        item = seq_item::type_id::create("item");
        start_item(item);
        item.TXD              = TXD_i;
        item.tx_enable        = te_i;
        item.tx_error         = terr_i;
        item.tx_mode          = tm_i;
        item.config_i         = cfg_i;
        item.loc_rcvr_status  = lrs_i;
        item.loc_lpi_req      = llr_i;
        item.loc_update_done  = lud_i;
        finish_item(item);
    endtask

    task body();
        `uvm_info(get_type_name(), "=== A1: normal data master (256 items)", UVM_LOW)
        normal_data(1'b1);

        `uvm_info(get_type_name(), "=== A2: normal data slave (256 items)", UVM_LOW)
        normal_data(1'b0);

        `uvm_info(get_type_name(), "=== A3: random 500 master", UVM_LOW)
        random_run(1'b1, 500);

        `uvm_info(get_type_name(), "=== B: tx_mode tests", UVM_LOW)
        tx_mode_tests();

        `uvm_info(get_type_name(), "=== C: special rows", UVM_LOW)
        special_rows();

        `uvm_info(get_type_name(), "=== D: sideband permutations", UVM_LOW)
        sideband_perms();

        `uvm_info(get_type_name(), "=== E: error injection", UVM_LOW)
        error_injection();

        `uvm_info(get_type_name(), "=== G: corner cases", UVM_LOW)
        corner_cases();

        `uvm_info(get_type_name(), "=== H1: random stress 2000 uniform", UVM_LOW)
        random_stress(1'b1, 2000);

        `uvm_info(get_type_name(), "=== H2: random stress 2000 weighted", UVM_LOW)
        random_stress(1'b0, 2000);
    endtask

    // ----------------------------------------------------------------
    // A: normal data — all 256 TXD values in single-burst
    // ----------------------------------------------------------------
    task normal_data(input logic cfg);
        for (int i = 0; i < 256; i++)
            send(i[7:0], 1'b1, 1'b0, 1'b0, cfg, 1'b0, 1'b0, 1'b0);
    endtask

    task random_run(input logic cfg, int n);
        for (int i = 0; i < n; i++)
            send($urandom, 1'b1, i[0], 1'b0, cfg, 1'b0, 1'b0, 1'b0);
    endtask

    // ----------------------------------------------------------------
    // B: tx_mode (SEND_Z)
    // ----------------------------------------------------------------
    task tx_mode_tests();
        // B1: tx_mode=1 with tx_enable=1
        for (int i = 0; i < 64; i++)
            send($urandom, 1'b1, 1'b0, 1'b1, $urandom[0], $urandom[0], $urandom[0], $urandom[0]);

        // B2: tx_mode=1 with tx_enable=0, various sideband
        send(8'h00, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        send(8'h00, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1);

        // B3: toggle tx_mode mid-stream
        send(8'hAA, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hBB, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hCC, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hDD, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
    endtask

    // ----------------------------------------------------------------
    // C: special rows — one directed test per row
    // Row conditions use tx_enable_n[4:0] / tx_error_n[3:0] shift regs.
    // Preamble cycles build the required history.
    // ----------------------------------------------------------------
    task special_rows();
        // C1: xmt_err — terr_n[0]=1 && te_n[0]=1 && te_n[2]=1
        //   Preamble: 2 cycles te=1 → te_n[2]=1, then te=1 + terr=1
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hAA, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // C2: CSReset — te_n[2]=1 & ~te_n[0] & ~terr_n[0]
        //   Preamble: 2 cycles te=1, then te=0, terr=0
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // C3: CSExtend — CSReset + terr_n[0]=1 && TXD==0x0F
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h0F, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // C4: CSExtend_Err — CSReset + terr_n[0]=1 && TXD!=0x0F
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h55, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // C5: SSD1 — ssd_n && te_n[0] && !te_n[1]
        //   ssd_n = te_n[0] & ~te_n[2]. After reset (all 0),
        //   first cycle te=1: te_n[0]=1, te_n[1]=0, te_n[2]=0 → SSD1 hits.
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // C6: SSD2 — ssd_n && te_n[1] && !te_n[2]
        //   Preamble: te=1, te=1. Cycle 2: te_n[0]=1, te_n[1]=1, te_n[2]=0.
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // C7: ESD1 — !te_n[2] && te_n[3]
        //   Need te_n[3]=1 (te was 1 three cycles ago),
        //       te_n[2]=0 (te was 0 two cycles ago).
        //   Preamble: te=1, te=0, te=0, then target.
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // C8: ESD2_Ext_0 — !te_n[3] && te_n[4] && !terr_n[0] && !terr_n[1]
        //   Preamble: te=1, then 4 cycles te=0 with terr=0.
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // C9: ESD2_Ext_1 — !te_n[3] && te_n[4] && !terr_n[0] && terr_n[1:3] all 1
        //   Preamble: te=1, te=1 (with terr=1 for 3 cycles before target),
        //   then 3 cycles te=1 with terr=1, then target with terr=0.
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // C10: ESD2_Ext_2 — !te_n[3] && te_n[4] && terr_n[0:3] all 1 && TXD==0x0F
        //   Preamble: te=1, then 3 cycles te=1 with terr=1, target terr=1 + TXD=0x0F
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h0F, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // C11: ESD_Ext_Err — esd_n && esd_ext_err_n
        //   esd_n = ~te_n[2] & te_n[4]. esd_ext_err_n needs terr pattern + TXD!=0x0F.
        //   Preamble: te=1, then 3 cycles te=1 with terr=1 (builds terr_n[1:3]=1),
        //   target te=0 with terr=1 and TXD!=0x0F.
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hAA, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // extra cycles to flush history
        repeat (5) send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    endtask

    // ----------------------------------------------------------------
    // D: sideband permutations
    // ----------------------------------------------------------------
    task sideband_perms();
        for (int en = 0; en < 2; en++) begin
            for (int lrs = 0; lrs < 2; lrs++)
            for (int llr = 0; llr < 2; llr++)
            for (int lud = 0; lud < 2; lud++)
                send($urandom, en[0], 1'b0, 1'b0, 1'b1,
                     lrs[0], llr[0], lud[0]);
        end

        // toggle sweep
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h11, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        send(8'h22, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        send(8'h33, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1);
        send(8'h44, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
        send(8'h55, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
        send(8'h66, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0);
        send(8'h77, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    endtask

    // ----------------------------------------------------------------
    // E: error injection
    // ----------------------------------------------------------------
    task error_injection();
        // E1: single-cycle error pulses at different history depths
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h11, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h22, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h33, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h44, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // E2: error burst 3 cycles
        send(8'hFF, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hEE, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hDD, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // E3: error during CSReset condition
        //   2 cycles te=1, then te=0 with terr=1 + TXD!=0x0F → CSExtend_Err
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h99, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        repeat (3) send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    endtask

    // ----------------------------------------------------------------
    // G: corner cases
    // ----------------------------------------------------------------
    task corner_cases();
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hFF, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h0F, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // walking ones
        for (int b = 0; b < 8; b++) begin
            send(8'b1 << b, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
            send(~(8'b1 << b), 1'b1, $urandom[0], 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end

        // all sideband high + tx_mode=1 + terr=1 + TXD=0x0F
        send(8'h0F, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);

        // rapid enable toggle
        for (int i = 0; i < 16; i++)
            send($urandom, i[0], 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    endtask

    // ----------------------------------------------------------------
    // H: random stress
    // ----------------------------------------------------------------
    task random_stress(input logic cfg, int n);
        logic te, terr, tm, lrs, llr, lud;
        for (int i = 0; i < n; i++) begin
            te   = $urandom[0];
            terr = $urandom[0];
            tm   = $urandom[0];
            lrs  = $urandom[0];
            llr  = $urandom[0];
            lud  = $urandom[0];
            send($urandom, te, terr, tm, cfg, lrs, llr, lud);
        end
    endtask

endclass

`endif
