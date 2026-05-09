`ifndef PCS_TX_SV
`define PCS_TX_SV

module pcs_tx #(
    parameter logic [32:0] SCR_SEED = 33'h1
) (
    input  logic           clk,
    input  logic           rst,
    input  logic [7:0]     Din,
    input  logic           TX_EN,
    output logic [3:0][2:0] Dout
);

    logic [4:0] tx_enable_n;

    typedef enum logic [2:0] {
        ST_RESET,
        ST_IDLE,
        ST_SDD2,
        ST_DATA,
        ST_CSR2,
        ST_ESD1,
        ST_ESD2
    } tx_state_t;

    tx_state_t state;
    tx_state_t next_state;
    logic      csreset;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_enable_n <= '0;
            state       <= ST_RESET;
        end else begin
            tx_enable_n <= {tx_enable_n[3:0], TX_EN};
            state       <= next_state;
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
        .config_i (1'b1),
        .Sy_n     (Sy_n),
        .Sx_n     (Sx_n),
        .Sg_n     (Sg_n)
    );

    logic [7:0] Sc_n;

    tx_sc_gen u_tx_sc_gen (
        .clk         (clk),
        .rst         (rst),
        .tx_enable_n (tx_enable_n[2:0]),
        .Sy_n        (Sy_n),
        .Sx_n        (Sx_n),
        .Sc_n        (Sc_n)
    );

    logic [8:0] Sd_n;

    tx_sd_gen u_tx_sd_gen (
        .clk         (clk),
        .rst         (rst),
        .tx_enable_n (tx_enable_n[2:0]),
        .TXD         (Din),
        .csreset     (csreset),
        .Sc_n        (Sc_n),
        .Sd_n        (Sd_n)
    );

    always_comb begin
        next_state = state;
        csreset    = 1'b0;

        unique case (state)
            ST_RESET:               next_state = ST_IDLE;
            ST_IDLE:    if (TX_EN)  next_state = ST_SDD2;
            ST_SDD2:                next_state = ST_DATA;
            ST_DATA:    if (!TX_EN) next_state = ST_CSR2; csreset = 1'b1;
            ST_CSR2:                next_state = ST_ESD1; csreset    = 1'b1;
            ST_ESD1:                next_state = ST_ESD2;
            ST_ESD2:                next_state = ST_IDLE;
            default:                next_state = ST_IDLE;
        endcase
    end

    logic signed [2:0] TA_n;
    logic signed [2:0] TB_n;
    logic signed [2:0] TC_n;
    logic signed [2:0] TD_n;

    tx_table u_tx_table (
        .tx_state (state),
        .TX_EN    (TX_EN),
        .Sd_n     (Sd_n),
        .TA_n     (TA_n),
        .TB_n     (TB_n),
        .TC_n     (TC_n),
        .TD_n     (TD_n)
    );

    logic signed [2:0] A_n;
    logic signed [2:0] B_n;
    logic signed [2:0] C_n;
    logic signed [2:0] D_n;

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

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Dout <= '0;
        else
            Dout <= {A_n[2:0], B_n[2:0], C_n[2:0], D_n[2:0]};
    end

endmodule

`endif
