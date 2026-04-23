module pcs_tx #(
    parameter logic [32:0] SCR_SEED = 33'h1
) (
    input  logic               clk,
    input  logic               rst,
    input  logic               scrambler_reset,

    input  logic               master_mode,
    input  logic               tx_enable,
    input  logic [7:0]         TXD_n,
    input  logic               tx_mode_send_z,
    input  logic               loc_rcvr_status_ok,
    input  logic               loc_lpi_req,
    input  logic               loc_update_done,
    input  logic               tx_error,

    output logic signed [2:0]  A_n,
    output logic signed [2:0]  B_n,
    output logic signed [2:0]  C_n,
    output logic signed [2:0]  D_n
);
    logic [4:0]               tx_enable_n;  // [4] = tx_enable_{n-4}, ... [0] = tx_enable_n
    logic [3:0]               tx_error_n;   // [3] = tx_error_{n-3},  ... [0] = tx_error_n
    logic [3:0]               Sy_n;
    logic [3:0]               Sx_n;
    logic [3:0]               Sg_n;
    logic [7:0]               Sc_n;
    logic [8:0]               Sd_n;
    logic signed [2:0]        TA_n;
    logic signed [2:0]        TB_n;
    logic signed [2:0]        TC_n;
    logic signed [2:0]        TD_n;
    logic                     Srev_n;

    // 40.3.1.3.{1.2} scrambler/S{x,y,g}_n gen
    // 40.3.1.3.3 Sc_n
    // 40.3.1.3.4 Sd_n
    // 40.3.1.3.5 table 
    // 40.3.1.3.6 sign reversal / final symbols

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_enable_n <= '0;
            tx_error_n  <= '0;
        end else begin
            tx_enable_n <= {tx_enable_n[3:0], tx_enable};
            tx_error_n  <= {tx_error_n[2:0],  tx_error};
        end
    end

    tx_scrambler #(
        .SCR_SEED(SCR_SEED)
    ) u_tx_scrambler (
        .clk             (clk),
        .rst             (rst),
        .scrambler_reset (scrambler_reset),
        .master_mode     (master_mode),
        .Sy_n            (Sy_n),
        .Sx_n            (Sx_n),
        .Sg_n            (Sg_n)
    );

    tx_sc_gen u_tx_sc_gen (
        .clk             (clk),
        .rst             (rst),
        .scrambler_reset (scrambler_reset),
        .tx_enable_n     (tx_enable_n[2:0]),
        .tx_mode_send_z  (tx_mode_send_z),
        .Sy_n            (Sy_n),
        .Sx_n            (Sx_n),
        .Sc_n            (Sc_n)
    );

    tx_sd_gen u_tx_sd_gen (
        .clk                (clk),
        .rst                (rst),
        .tx_enable_n        (tx_enable_n[2:0]),
        .TXD_n              (TXD_n),
        .tx_mode_send_z     (tx_mode_send_z),
        .loc_rcvr_status_ok (loc_rcvr_status_ok),
        .loc_lpi_req        (loc_lpi_req),
        .loc_update_done    (loc_update_done),
        .tx_error_n         (tx_error_n[0]),
        .Sc_n               (Sc_n),
        .Sd_n               (Sd_n)
    );

    tx_table u_tx_table (
        .tx_enable_n    (tx_enable_n),
        .tx_error_n     (tx_error_n),
        .TXD_n          (TXD_n),
        .Sd_n           (Sd_n),
        .TA_n           (TA_n),
        .TB_n           (TB_n),
        .TC_n           (TC_n),
        .TD_n           (TD_n)
    );

    tx_sign_rev u_tx_sign_rev (
        .tx_enable_n    (tx_enable_n),
        .Sg_n           (Sg_n),
        .TA_n           (TA_n),
        .TB_n           (TB_n),
        .TC_n           (TC_n),
        .TD_n           (TD_n),
        .Srev_n         (Srev_n),
        .A_n            (A_n),
        .B_n            (B_n),
        .C_n            (C_n),
        .D_n            (D_n)
    );

endmodule
