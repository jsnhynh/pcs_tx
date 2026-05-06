`ifndef SEQUENCE_SV
`define SEQUENCE_SV

class my_sequence extends uvm_sequence #(seq_item);
    `uvm_object_utils(my_sequence)

    localparam int unsigned SCN_IDLE            = 0;
    localparam int unsigned SCN_DATA_PASS       = 1;
    localparam int unsigned SCN_RANDOM          = 2;
    localparam int unsigned SCN_DATA_IDLE_MIX   = 3;
    localparam int unsigned SCN_SPECIAL_ROWS    = 4;
    localparam int unsigned SCN_ERROR_INJECTION = 5;
    localparam int unsigned SCN_CORNER_CASES    = 6;

    int unsigned current_scenario_id = SCN_IDLE;

    function new(string name = "my_sequence");
        super.new(name);
    endfunction

    // low-level send: encodes raw 9-bit enc_in into a seq_item transaction
    task send(input logic [8:0] val);
        seq_item item;
        item = seq_item::type_id::create("item");
        start_item(item);
        item.enc_in = val;
        item.scenario_id = current_scenario_id;
        finish_item(item);
    endtask

    // constrained random stimulus via item.randomize()
    // uses seq_item::enc_dist constraint: 80% data, 20% commands
    task send_rand();
        seq_item item;
        item = seq_item::type_id::create("item");
        start_item(item);
        if (!item.randomize()) `uvm_fatal("RAND", "randomization failed")
        item.scenario_id = current_scenario_id;
        finish_item(item);
    endtask

    // ordered: directed tests first, random stress last
    task body();
        data_pass();
        data_idle_mix();
        special_rows();
        error_injection();
        corner_cases();
        random_run(4500);
    endtask

    // sweep all 256 possible data byte values
    task data_pass();
        current_scenario_id = SCN_DATA_PASS;
        for (int i = 0; i < 256; i++)
            send({1'b0, i[7:0]});
    endtask

    task random_run(int n);
        current_scenario_id = SCN_RANDOM;
        repeat (n) send_rand();
    endtask

    // random data mixed with idle bursts and directed data bytes (AA, BB, CC, DD)
    task data_idle_mix();
        current_scenario_id = SCN_DATA_IDLE_MIX;
        repeat (64) send_rand();
        repeat (3) send({1'b1, PCS_TX_CMD_IDLE});
        send({1'b0, 8'hAA});
        send({1'b0, 8'hBB});
        send({1'b1, PCS_TX_CMD_IDLE});
        send({1'b0, 8'hCC});
        send({1'b0, 8'hDD});
    endtask

    // exercises row-table state transitions: data→error, data→idle,
    // data→carrier_extend, start/end-of-stream, error bursts
    // each section flushed with 5 idles for clean pipeline state
    task special_rows();
        current_scenario_id = SCN_SPECIAL_ROWS;

        // error after data stream
        send({1'b0, 8'h00});
        send({1'b0, 8'h00});
        send({1'b1, PCS_TX_CMD_TX_ERROR});
        repeat (5) send({1'b1, PCS_TX_CMD_IDLE});

        // idle after data stream
        send({1'b0, 8'h00});
        send({1'b0, 8'h00});
        send({1'b1, PCS_TX_CMD_IDLE});
        repeat (5) send({1'b1, PCS_TX_CMD_IDLE});

        // carrier_extend after data stream
        send({1'b0, 8'h00});
        send({1'b0, 8'h00});
        send({1'b1, PCS_TX_CMD_CARRIER_EXT});
        repeat (5) send({1'b1, PCS_TX_CMD_IDLE});

        // start-of-stream: first data bytes after idle
        send({1'b0, 8'h00});
        send({1'b0, 8'h55});
        repeat (5) send({1'b1, PCS_TX_CMD_IDLE});

        // end-of-stream: data then idle train
        send({1'b0, 8'hAA});
        repeat (5) send({1'b1, PCS_TX_CMD_IDLE});

        // error burst then idle
        send({1'b0, 8'h00});
        repeat (3) send({1'b1, PCS_TX_CMD_TX_ERROR});
        send({1'b1, PCS_TX_CMD_IDLE});
        repeat (5) send({1'b1, PCS_TX_CMD_IDLE});

        // error burst then carrier_extend
        send({1'b0, 8'h00});
        repeat (3) send({1'b1, PCS_TX_CMD_TX_ERROR});
        send({1'b1, PCS_TX_CMD_CARRIER_EXT});
        repeat (5) send({1'b1, PCS_TX_CMD_IDLE});
    endtask

    // single error pulses, 3-cycle error burst, error-during-csreset
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

    // boundary values (00, FF, 0F), walking-ones with alternating error,
    // rapid data/idle toggle
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

endclass

`endif
