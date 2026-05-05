`ifndef SEQUENCE_SV
`define SEQUENCE_SV

class comprehensive_sequence extends uvm_sequence #(seq_item);
    `uvm_object_utils(comprehensive_sequence)

    localparam int unsigned SCN_IDLE              = 0;
    localparam int unsigned SCN_NORMAL_CFG1       = 1;
    localparam int unsigned SCN_NORMAL_CFG0       = 2;
    localparam int unsigned SCN_RANDOM_RUN_CFG1   = 3;
    localparam int unsigned SCN_TX_MODE           = 4;
    localparam int unsigned SCN_SPECIAL_ROWS      = 5;
    localparam int unsigned SCN_SIDEBAND_PERMS    = 6;
    localparam int unsigned SCN_ERROR_INJECTION   = 7;
    localparam int unsigned SCN_CORNER_CASES      = 8;
    localparam int unsigned SCN_RANDOM_STRESS_CFG1 = 9;
    localparam int unsigned SCN_RANDOM_STRESS_CFG0 = 10;

    int unsigned current_scenario_id = SCN_IDLE;

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
        item.scenario_id      = current_scenario_id;
        finish_item(item);
    endtask

    // send one random item
    task send_rand(input logic cfg_i);
        seq_item item;
        item = seq_item::type_id::create("item");
        start_item(item);
        item.config_i = cfg_i;
        item.scenario_id = current_scenario_id;
        if (!item.randomize()) begin
            `uvm_error(get_type_name(), "randomize failed")
        end
        finish_item(item);
    endtask

    task body();
        normal_data(1'b1);
        normal_data(1'b0);
        random_run(1'b1, 500);
        tx_mode_tests();
        special_rows();
        sideband_perms();
        error_injection();
        corner_cases();
        random_stress(1'b1, 2000);
        random_stress(1'b0, 2000);
    endtask

    // all 256 txd values, enable on
    task normal_data(input logic cfg);
        current_scenario_id = cfg ? SCN_NORMAL_CFG1 : SCN_NORMAL_CFG0;
        for (int i = 0; i < 256; i++)
            send(i[7:0], 1'b1, 1'b0, 1'b0, cfg, 1'b0, 1'b0, 1'b0);
    endtask

    task random_run(input logic cfg, int n);
        current_scenario_id = SCN_RANDOM_RUN_CFG1;
        repeat (n) send_rand(cfg);
    endtask

    task tx_mode_tests();
        current_scenario_id = SCN_TX_MODE;
        // tx_mode=1, enable=1, random sidebands
        for (int i = 0; i < 64; i++) begin
            seq_item item;
            item = seq_item::type_id::create("item");
            start_item(item);
            item.tx_enable = 1'b1;
            item.tx_mode   = 1'b1;
            item.config_i  = 1'b1;
            item.scenario_id = current_scenario_id;
            if (!item.randomize()) `uvm_error(get_type_name(), "randomize failed")
            finish_item(item);
        end

        // tx_mode=1, enable=0
        send(8'h00, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        send(8'h00, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1);

        // toggle tx_mode
        send(8'hAA, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hBB, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hCC, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hDD, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
    endtask

    // hit every special row in table 40-1 / 40-2
    task special_rows();
        current_scenario_id = SCN_SPECIAL_ROWS;
        // xmt_err: te_n[0]=1, te_n[2]=1, terr_n[0]=1
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hAA, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // csreset: te_n[2]=1, te_n[0]=0, terr_n[0]=0
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // csextend: csreset + terr_n[0]=1 + txd=0x0f
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h0F, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // csextend_err: csreset + terr_n[0]=1 + txd!=0x0f
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h55, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // ssd1: te_n[0]=1, te_n[1]=0, te_n[2]=0 (first cycle after reset)
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // ssd2: te_n[0]=1, te_n[1]=1, te_n[2]=0
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // esd1: te_n[2]=0, te_n[3]=1
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // esd2_ext0: te_n[3]=0, te_n[4]=1, terr clean
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // esd2_ext1: te_n[3]=0, te_n[4]=1, terr[0]=0, terr[1:3]=1
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // esd2_ext2: te_n[3]=0, te_n[4]=1, terr all 1, txd=0x0f
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h0F, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // esd_ext_err: esd_n=1 + err pattern + txd!=0x0f
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hAA, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // flush history
        repeat (5) send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    endtask

    // all 8 sideband combos, enable on/off
    task sideband_perms();
        current_scenario_id = SCN_SIDEBAND_PERMS;
        for (int en = 0; en < 2; en++) begin
            for (int lrs = 0; lrs < 2; lrs++)
            for (int llr = 0; llr < 2; llr++)
            for (int lud = 0; lud < 2; lud++)
                send(8'h00, en[0], 1'b0, 1'b0, 1'b1,
                     lrs[0], llr[0], lud[0]);
        end

        // sweep each sideband independently
        send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h11, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        send(8'h22, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        send(8'h33, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1);
        send(8'h44, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
        send(8'h55, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
        send(8'h66, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0);
        send(8'h77, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    endtask

    task error_injection();
        current_scenario_id = SCN_ERROR_INJECTION;
        // single error pulses across history depths
        send(8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h11, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h22, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h33, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h44, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // 3-cycle error burst
        send(8'hFF, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hEE, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hDD, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // error during csreset -> hits csextend_err
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h99, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        repeat (3) send(8'h00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    endtask

    task corner_cases();
        current_scenario_id = SCN_CORNER_CASES;
        send(8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'hFF, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        send(8'h0F, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // walking ones
        for (int b = 0; b < 8; b++) begin
            send(8'b1 << b, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
            send(~(8'b1 << b), 1'b1, b[0], 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end

        // everything on
        send(8'h0F, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);

        // rapid enable toggle
        for (int i = 0; i < 16; i++)
            send(8'h00 + i[7:0], i[0], 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    endtask

    task random_stress(input logic cfg, int n);
        current_scenario_id = cfg ? SCN_RANDOM_STRESS_CFG1 : SCN_RANDOM_STRESS_CFG0;
        repeat (n) send_rand(cfg);
    endtask

endclass

`endif
