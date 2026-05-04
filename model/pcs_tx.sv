`ifndef PCS_TX_SV
`define PCS_TX_SV

/*
    omitted due to project scope:
    RX_CLK, RXD, RX_DV, RX_ER, rem_*, CRS, COL, PMA_UNITDATA.indication, PMA_UNITDATA.request
*/

module pcs_tx #(
    parameter logic [32:0] SCR_SEED = 33'h1
) (
    input  logic               clk,
    input  logic               rst,

    input  logic [7:0]         TXD,
    input  logic               tx_enable,
    input  logic               tx_error,
    input  logic               tx_mode,     // send_z==1, otherwise 0
    input  logic               config_i,    // master==1, slave==0
    input  logic               loc_rcvr_status, // ok==1, otherwise 0
    input  logic               loc_lpi_req,
    input  logic               loc_update_done,

    output logic signed [2:0]  A_n, B_n, C_n, D_n
);

    logic [4:0]               tx_enable_n;  // [4] = tx_enable_{n-4}, ... [0] = tx_enable_n
    logic [3:0]               tx_error_n;   // [3] = tx_error_{n-3},  ... [0] = tx_error_n
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_enable_n <= '0;
            tx_error_n  <= '0;
        end else begin
            tx_enable_n <= {tx_enable_n[3:0], tx_enable};
            tx_error_n  <= {tx_error_n[2:0],  tx_error};
        end
    end

    // 40.3.1.3.{1,2} scrambler/S{y,x,g}_n gen
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

    // 40.3.1.3.3 Sc_n
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

    // 40.3.1.3.4 Sd_n
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

    // 40.3.1.3.5 table
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

    // 40.3.1.3.6 sign reversal / final symbols
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

`endif
