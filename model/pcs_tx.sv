`ifndef PCS_TX_SV
`define PCS_TX_SV

import pcs_tx_cmd_pkg::*;

module pcs_tx_core #(
    parameter logic [32:0] SCR_SEED = 33'h1
) (
    input  logic               clk,
    input  logic               rst,

    input  logic [7:0]         TXD,
    input  logic               tx_enable,
    input  logic               tx_error,
    input  logic               tx_mode,
    input  logic               config_i,
    input  logic               loc_rcvr_status,
    input  logic               loc_lpi_req,
    input  logic               loc_update_done,

    output logic signed [2:0]  A_n, B_n, C_n, D_n
);

    // 5-deep shift regs for enable and error
    logic [4:0]               tx_enable_n;
    logic [3:0]               tx_error_n;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_enable_n <= '0;
            tx_error_n  <= '0;
        end else begin
            tx_enable_n <= {tx_enable_n[3:0], tx_enable};
            tx_error_n  <= {tx_error_n[2:0],  tx_error};
        end
    end

    // scrambler + Sy Sx Sg
    logic [3:0] Sy_n, Sx_n, Sg_n;
    tx_scrambler #(
        .SCR_SEED(SCR_SEED)
    ) u_tx_scrambler (
        .clk             (clk),
        .rst             (rst),
        .config_i        (config_i),
        .Sy_n            (Sy_n),
        .Sx_n            (Sx_n),
        .Sg_n            (Sg_n)
    );

    // Sc_n
    logic [7:0] Sc_n;
    tx_sc_gen   u_tx_sc_gen (
        .clk             (clk),
        .rst             (rst),
        .tx_enable_n     (tx_enable_n[2:0]),
        .tx_mode         (tx_mode),

        .Sy_n            (Sy_n),
        .Sx_n            (Sx_n),
        .Sc_n            (Sc_n)
    );

    // Sd_n
    logic [8:0] Sd_n;
    tx_sd_gen   u_tx_sd_gen (
        .clk                (clk),
        .rst                (rst),
        .tx_enable_n        (tx_enable_n[2:0]),
        .TXD                (TXD),
        .tx_mode            (tx_mode),
        .loc_rcvr_status    (loc_rcvr_status),
        .loc_lpi_req        (loc_lpi_req),
        .loc_update_done    (loc_update_done),
        .tx_error           (tx_error_n[0]),
        .Sc_n               (Sc_n),

        .Sd_n               (Sd_n)
    );

    // table lookup
    logic signed [2:0]  TA_n, TB_n, TC_n, TD_n;
    tx_table u_tx_table (
        .tx_enable_n    (tx_enable_n),
        .tx_error_n     (tx_error_n),
        .TXD            (TXD),
        .Sd_n           (Sd_n),

        .TA_n           (TA_n),
        .TB_n           (TB_n),
        .TC_n           (TC_n),
        .TD_n           (TD_n)
    );

    // sign reversal → final output
    tx_sign_rev u_tx_sign_rev (
        .tx_enable_n    (tx_enable_n),
        .Sg_n           (Sg_n),
        .TA_n           (TA_n),
        .TB_n           (TB_n),
        .TC_n           (TC_n),
        .TD_n           (TD_n),

        .A_n            (A_n),
        .B_n            (B_n),
        .C_n            (C_n),
        .D_n            (D_n)
    );

endmodule

module pcs_tx #(
    parameter logic [32:0] SCR_SEED = 33'h1,
    parameter logic [7:0]  CMD_IDLE = PCS_TX_CMD_IDLE,
    parameter logic [7:0]  CMD_TX_ERROR = PCS_TX_CMD_TX_ERROR,
    parameter logic [7:0]  CMD_CARRIER_EXT = PCS_TX_CMD_CARRIER_EXT,
    parameter logic        DEFAULT_TX_MODE = 1'b0,
    parameter logic        DEFAULT_CONFIG = 1'b1,
    parameter logic        DEFAULT_LOC_RCVR_STATUS = 1'b0,
    parameter logic        DEFAULT_LOC_LPI_REQ = 1'b0,
    parameter logic        DEFAULT_LOC_UPDATE_DONE = 1'b0
) (
    input  logic        clk,
    input  logic        rst,
    input  logic [8:0]  enc_in,
    output logic [11:0] enc_out
);

    logic [7:0]        TXD;
    logic              tx_enable;
    logic              tx_error;
    logic signed [2:0] A_n;
    logic signed [2:0] B_n;
    logic signed [2:0] C_n;
    logic signed [2:0] D_n;

    always_comb begin
        TXD       = enc_in[7:0];
        tx_enable = 1'b0;
        tx_error  = 1'b0;

        if (!enc_in[8]) begin
            tx_enable = 1'b1;
        end else begin
            unique case (enc_in[7:0])
                CMD_IDLE: begin
                    TXD       = 8'h00;
                    tx_enable = 1'b0;
                    tx_error  = 1'b0;
                end
                CMD_TX_ERROR: begin
                    TXD       = 8'h00;
                    tx_enable = 1'b1;
                    tx_error  = 1'b1;
                end
                CMD_CARRIER_EXT: begin
                    TXD       = 8'h0F;
                    tx_enable = 1'b0;
                    tx_error  = 1'b1;
                end
                default: begin
                    TXD       = 8'h00;
                    tx_enable = 1'b0;
                    tx_error  = 1'b0;
                end
            endcase
        end
    end

    pcs_tx_core #(
        .SCR_SEED(SCR_SEED)
    ) u_core (
        .clk             (clk),
        .rst             (rst),
        .TXD             (TXD),
        .tx_enable       (tx_enable),
        .tx_error        (tx_error),
        .tx_mode         (DEFAULT_TX_MODE),
        .config_i        (DEFAULT_CONFIG),
        .loc_rcvr_status (DEFAULT_LOC_RCVR_STATUS),
        .loc_lpi_req     (DEFAULT_LOC_LPI_REQ),
        .loc_update_done (DEFAULT_LOC_UPDATE_DONE),
        .A_n             (A_n),
        .B_n             (B_n),
        .C_n             (C_n),
        .D_n             (D_n)
    );

    assign enc_out = {A_n[2:0], B_n[2:0], C_n[2:0], D_n[2:0]};

endmodule

`endif
