`ifndef SEQUENCE_SV
`define SEQUENCE_SV

import pcs_tx_cmd_pkg::*;

class my_sequence extends uvm_sequence #(seq_item);
    `uvm_object_utils(my_sequence)

    localparam int unsigned SCN_IDLE            = 0;
    localparam int unsigned SCN_DATA_PASS       = 1;
    localparam int unsigned SCN_RANDOM_RUN      = 2;
    localparam int unsigned SCN_TX_MODE         = 3;
    localparam int unsigned SCN_SPECIAL_ROWS    = 4;
    localparam int unsigned SCN_ERROR_INJECTION = 5;
    localparam int unsigned SCN_CORNER_CASES    = 6;
    localparam int unsigned SCN_RANDOM_STRESS1  = 7;
    localparam int unsigned SCN_RANDOM_STRESS2  = 8;

    int unsigned current_scenario_id = SCN_IDLE;

    function new(string name = "my_sequence");
        super.new(name);
    endfunction

    task send(input logic [8:0] val);
        seq_item item;
        item = seq_item::type_id::create("item");
        start_item(item);
        item.enc_in = val;
        item.scenario_id = current_scenario_id;
        finish_item(item);
    endtask

    task send_rand();
        logic [8:0] val;
        logic [7:0] rand_byte = $urandom_range(0, 255);
        randcase
            80: val = {1'b0, rand_byte};
            12: val = {1'b1, PCS_TX_CMD_IDLE};
            5:  val = {1'b1, PCS_TX_CMD_TX_ERROR};
            3:  val = {1'b1, PCS_TX_CMD_CARRIER_EXT};
        endcase
        send(val);
    endtask

    task body();
        data_pass();
        random_run(500);
        tx_mode_tests();
        special_rows();
        error_injection();
        corner_cases();
        random_stress1(2000);
        random_stress2(2000);
    endtask

    task data_pass();
        current_scenario_id = SCN_DATA_PASS;
        for (int i = 0; i < 256; i++)
            send({1'b0, i[7:0]});
    endtask

    task random_run(int n);
        current_scenario_id = SCN_RANDOM_RUN;
        repeat (n) send_rand();
    endtask

    task tx_mode_tests();
        current_scenario_id = SCN_TX_MODE;
        repeat (64) send_rand();
        repeat (3) send({1'b1, PCS_TX_CMD_IDLE});
        send({1'b0, 8'hAA});
        send({1'b0, 8'hBB});
        send({1'b1, PCS_TX_CMD_IDLE});
        send({1'b0, 8'hCC});
        send({1'b0, 8'hDD});
    endtask

    task special_rows();
        current_scenario_id = SCN_SPECIAL_ROWS;
        // XMT_ERR: data, data, error
        send({1'b0, 8'h00});
        send({1'b0, 8'h00});
        send({1'b1, PCS_TX_CMD_TX_ERROR});

        // CSRESET: data, data, idle
        send({1'b0, 8'h00});
        send({1'b0, 8'h00});
        send({1'b1, PCS_TX_CMD_IDLE});

        // CSEXTEND: data, data, carrier_ext
        send({1'b0, 8'h00});
        send({1'b0, 8'h00});
        send({1'b1, PCS_TX_CMD_CARRIER_EXT});

        // SSD1, SSD2: first data after flush
        send({1'b0, 8'h00});
        send({1'b0, 8'h55});

        // ESD1: data, 4 idles
        send({1'b0, 8'h00});
        repeat (4) send({1'b1, PCS_TX_CMD_IDLE});

        // ESD2_EXT0: data, 4 idles
        send({1'b0, 8'h00});
        repeat (4) send({1'b1, PCS_TX_CMD_IDLE});

        // ESD2_EXT1: data, 3 errors, idle
        send({1'b0, 8'h00});
        repeat (3) send({1'b1, PCS_TX_CMD_TX_ERROR});
        send({1'b1, PCS_TX_CMD_IDLE});

        // ESD2_EXT2: data, 3 errors, carrier_ext
        send({1'b0, 8'h00});
        repeat (3) send({1'b1, PCS_TX_CMD_TX_ERROR});
        send({1'b1, PCS_TX_CMD_CARRIER_EXT});

        repeat (5) send({1'b1, PCS_TX_CMD_IDLE});
    endtask

    task error_injection();
        current_scenario_id = SCN_ERROR_INJECTION;
        send({1'b1, PCS_TX_CMD_TX_ERROR});
        send({1'b0, 8'h00});
        send({1'b1, PCS_TX_CMD_TX_ERROR});
        send({1'b0, 8'h22});
        send({1'b0, 8'h33});
        send({1'b1, PCS_TX_CMD_TX_ERROR});

        repeat (3) send({1'b1, PCS_TX_CMD_TX_ERROR});

        send({1'b0, 8'h00});
        send({1'b0, 8'h00});
        send({1'b1, PCS_TX_CMD_CARRIER_EXT});

        repeat (3) send({1'b1, PCS_TX_CMD_IDLE});
    endtask

    task corner_cases();
        current_scenario_id = SCN_CORNER_CASES;
        send({1'b0, 8'h00});
        send({1'b0, 8'hFF});
        send({1'b0, 8'h0F});

        for (int b = 0; b < 8; b++) begin
            send({1'b0, 8'b1 << b});
            if (b[0])
                send({1'b1, PCS_TX_CMD_TX_ERROR});
            else
                send({1'b0, ~(8'b1 << b)});
        end

        send({1'b1, PCS_TX_CMD_CARRIER_EXT});

        for (int i = 0; i < 16; i++) begin
            if (i[0])
                send({1'b0, 8'h00 + i[7:0]});
            else
                send({1'b1, PCS_TX_CMD_IDLE});
        end
    endtask

    task random_stress1(int n);
        current_scenario_id = SCN_RANDOM_STRESS1;
        repeat (n) send_rand();
    endtask

    task random_stress2(int n);
        current_scenario_id = SCN_RANDOM_STRESS2;
        repeat (n) send_rand();
    endtask

endclass

`endif
