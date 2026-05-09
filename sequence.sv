`ifndef SEQUENCE_SV
`define SEQUENCE_SV

class my_sequence extends uvm_sequence #(seq_item);
    `uvm_object_utils(my_sequence)

    localparam int unsigned SCN_IDLE             = 0;
    localparam int unsigned SCN_DATA_SWEEP       = 1;
    localparam int unsigned SCN_PACKET_BURSTS    = 2;
    localparam int unsigned SCN_DISABLE_PATTERNS = 3;
    localparam int unsigned SCN_TRANSITIONS      = 4;
    localparam int unsigned SCN_RANDOM           = 5;
    localparam int unsigned SCN_CORNER_CASES     = 6;

    int unsigned current_scenario_id = SCN_IDLE;

    function new(string name = "my_sequence");
        super.new(name);
    endfunction

    task send(input logic [7:0] din, input logic tx_en);
        seq_item item;
        item = seq_item::type_id::create("item");
        start_item(item);
        item.Din = din;
        item.TX_EN = tx_en;
        item.scenario_id = current_scenario_id;
        finish_item(item);
    endtask

    task body();
        int random_items;
        random_items = 100000;
        void'($value$plusargs("PCS_TX_RANDOM_ITEMS=%d", random_items));

        idle_train(16);
        data_sweep();
        packet_bursts();
        disable_patterns();
        transition_stress();
        corner_cases();
        random_run(random_items);
        idle_train(16);
    endtask

    task idle_train(int n);
        current_scenario_id = SCN_IDLE;
        repeat (n) send(8'h00, 1'b0);
    endtask

    task data_sweep();
        current_scenario_id = SCN_DATA_SWEEP;
        for (int i = 0; i < 256; i++) send(i[7:0], 1'b1);
    endtask

    task packet_bursts();
        current_scenario_id = SCN_PACKET_BURSTS;
        for (int len = 1; len <= 64; len++) send_packet(len, len[7:0]);
        send_packet(127, 8'h7D);
        send_packet(128, 8'h80);
        send_packet(255, 8'hA5);
        send_packet(256, 8'h5A);
    endtask

    task send_packet(input int len, input logic [7:0] seed);
        logic [7:0] data_byte;
        repeat (5) send(8'h00, 1'b0);
        for (int i = 0; i < len; i++) begin
            data_byte = seed + (i * 8'h25) + (i >> 1);
            send(data_byte, 1'b1);
        end
        repeat (8) send(8'h00, 1'b0);
    endtask

    task disable_patterns();
        current_scenario_id = SCN_DISABLE_PATTERNS;
        foreach_disabled_byte();
        repeat (8) send(8'h00, 1'b0);
        send(8'h0F, 1'b0);
        send(8'hF0, 1'b0);
        send(8'h55, 1'b0);
        send(8'hAA, 1'b0);
        repeat (8) send(8'h00, 1'b0);
    endtask

    task foreach_disabled_byte();
        for (int i = 0; i < 256; i++) send(i[7:0], 1'b0);
    endtask

    task transition_stress();
        current_scenario_id = SCN_TRANSITIONS;
        repeat (32) begin
            send(8'h00, 1'b0);
            send(8'h11, 1'b1);
            send(8'h22, 1'b0);
            send(8'h33, 1'b1);
            send(8'h44, 1'b1);
            send(8'h55, 1'b0);
        end
    endtask

    task random_run(int n);
        int sent;
        int gap_len;
        int packet_len;
        int tail_len;
        current_scenario_id = SCN_RANDOM;
        sent = 0;

        while (sent < n) begin
            gap_len = $urandom_range(1, 8);
            repeat (gap_len) begin
                if (sent >= n) break;
                send($urandom_range(0, 255), 1'b0);
                sent++;
            end

            packet_len = $urandom_range(1, 256);
            repeat (packet_len) begin
                if (sent >= n) break;
                send($urandom_range(0, 255), 1'b1);
                sent++;
            end

            tail_len = $urandom_range(6, 10);
            repeat (tail_len) begin
                if (sent >= n) break;
                send(8'h00, 1'b0);
                sent++;
            end
        end
    endtask

    task corner_cases();
        logic [7:0] walk;
        current_scenario_id = SCN_CORNER_CASES;
        send(8'h00, 1'b1);
        send(8'hFF, 1'b1);
        send(8'h0F, 1'b1);
        send(8'hF0, 1'b1);
        for (int b = 0; b < 8; b++) begin
            walk = 8'b1 << b;
            send(walk, 1'b1);
            send(~walk, 1'b1);
        end
        repeat (12) send(8'h00, 1'b0);

        for (int b = 0; b < 8; b++) begin
            walk = 8'b1 << b;
            send(walk, 1'b0);
            send(~walk, 1'b0);
        end
        repeat (12) send(8'h00, 1'b0);
    endtask

endclass

`endif
