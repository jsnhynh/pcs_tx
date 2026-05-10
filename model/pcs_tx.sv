`ifndef PCS_TX_SV
`define PCS_TX_SV

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

    output logic signed [2:0]  A_n,
    output logic signed [2:0]  B_n,
    output logic signed [2:0]  C_n,
    output logic signed [2:0]  D_n
);
    logic [4:0] tx_enable_n;
    logic [3:0] tx_error_n;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_enable_n <= '0;
            tx_error_n  <= '0;
        end else begin
            tx_enable_n <= {tx_enable_n[3:0], tx_enable};
            tx_error_n  <= {tx_error_n[2:0],  tx_error};
        end
    end

    logic [3:0] Sy_n;
    logic [3:0] Sx_n;
    logic [3:0] Sg_n;

    tx_scrambler #(
        .SCR_SEED(SCR_SEED)
    ) u_tx_scrambler (
        .clk      (clk),
        .rst      (rst),
        .config_i (config_i),
        .Sy_n     (Sy_n),
        .Sx_n     (Sx_n),
        .Sg_n     (Sg_n)
    );

    logic [7:0] Sc_n;

    tx_sc_gen u_tx_sc_gen (
        .clk         (clk),
        .rst         (rst),
        .tx_enable_n (tx_enable_n[2:0]),
        .tx_mode     (tx_mode),
        .Sy_n        (Sy_n),
        .Sx_n        (Sx_n),
        .Sc_n        (Sc_n)
    );

    logic [8:0] Sd_n;

    tx_sd_gen u_tx_sd_gen (
        .clk              (clk),
        .rst              (rst),
        .tx_enable_n      (tx_enable_n[2:0]),
        .tx_error         (tx_error_n[0]),
        .TXD              (TXD),
        .tx_mode          (tx_mode),
        .loc_rcvr_status  (loc_rcvr_status),
        .loc_lpi_req      (loc_lpi_req),
        .loc_update_done  (loc_update_done),
        .Sc_n             (Sc_n),
        .Sd_n             (Sd_n)
    );

    logic signed [2:0] TA_n;
    logic signed [2:0] TB_n;
    logic signed [2:0] TC_n;
    logic signed [2:0] TD_n;

    tx_table u_tx_table (
        .tx_enable_n (tx_enable_n),
        .tx_error_n  (tx_error_n),
        .TXD         (TXD),
        .Sd_n        (Sd_n),
        .TA_n        (TA_n),
        .TB_n        (TB_n),
        .TC_n        (TC_n),
        .TD_n        (TD_n)
    );

    tx_sign_rev u_tx_sign_rev (
        .tx_enable_n (tx_enable_n),
        .Sg_n        (Sg_n),
        .TA_n        (TA_n),
        .TB_n        (TB_n),
        .TC_n        (TC_n),
        .TD_n        (TD_n),
        .A_n         (A_n),
        .B_n         (B_n),
        .C_n         (C_n),
        .D_n         (D_n)
    );

endmodule

module pcs_tx #(
    parameter logic [32:0] SCR_SEED = 33'h1,
    parameter bit          REGISTER_OUTPUT = 1'b1
) (
    input  logic           clk,
    input  logic           rst,
    input  logic [7:0]     Din,
    input  logic           TX_EN,
    output logic [3:0][2:0] Dout
);
    logic signed [2:0] A_n;
    logic signed [2:0] B_n;
    logic signed [2:0] C_n;
    logic signed [2:0] D_n;
    logic [3:0][2:0]   Dout_core;

    pcs_tx_core #(
        .SCR_SEED(SCR_SEED)
    ) u_core (
        .clk             (clk),
        .rst             (rst),
        .TXD             (Din),
        .tx_enable       (TX_EN),
        .tx_error        (1'b0),
        .tx_mode         (1'b0),
        .config_i        (1'b1),
        .loc_rcvr_status (1'b0),
        .loc_lpi_req     (1'b0),
        .loc_update_done (1'b0),
        .A_n             (A_n),
        .B_n             (B_n),
        .C_n             (C_n),
        .D_n             (D_n)
    );

    assign Dout_core = {A_n[2:0], B_n[2:0], C_n[2:0], D_n[2:0]};

    generate
        if (REGISTER_OUTPUT) begin : gen_registered_output
            always_ff @(posedge clk or posedge rst) begin
                if (rst)
                    Dout <= '0;
                else
                    Dout <= Dout_core;
            end
        end else begin : gen_comb_output
            always_comb Dout = Dout_core;
        end
    endgenerate

endmodule

`endif
