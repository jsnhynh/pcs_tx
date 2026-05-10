`ifndef PCS_TX_DUT_REF_SV
`define PCS_TX_DUT_REF_SV

// Archived reference model aligned to DUTS26_0.sv behavior.
// Use this only if DUTS26_0.sv is later judged to be the valid assignment reference.
// For a spec-derived golden model, use pcs_tx.sv.

module tx_sc_gen_dut_ref (
    input  logic        clk,
    input  logic        rst,
    input  logic [2:0]  tx_enable_n,
    input  logic [3:0]  Sy_n,
    input  logic [3:0]  Sx_n,
    output logic [7:0]  Sc_n
);
    logic [3:0] Sy_prev;
    logic       sc_even_phase;

    always_comb begin
        if (tx_enable_n[2]) Sc_n[7:4] = Sx_n[3:0];
        else                Sc_n[7:4] = '0;

        if (sc_even_phase) Sc_n[3:1] = Sy_n[3:1];
        else               Sc_n[3:1] = Sy_prev[3:1] ^ 3'b111;

        Sc_n[0] = Sy_n[0];
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            Sy_prev       <= '0;
            sc_even_phase <= 1'b0;
        end else begin
            Sy_prev       <= Sy_n;
            sc_even_phase <= ~sc_even_phase;
        end
    end

endmodule

module tx_sd_gen_dut_ref (
    input  logic        clk,
    input  logic        rst,
    input  logic [2:0]  tx_enable_n,
    input  logic [7:0]  TXD,
    input  logic        csreset,
    input  logic [7:0]  Sc_n,
    output logic [8:0]  Sd_n
);
    logic [2:0] cs_prev;
    logic [2:0] cs_next;

    always_comb begin
        cs_next[0] = cs_prev[2];
        Sd_n[8] = cs_next[0];

        if (!csreset && tx_enable_n[2]) Sd_n[7] = Sc_n[7] ^ TXD[7];
        else if (csreset)               Sd_n[7] = cs_prev[1];
        else                            Sd_n[7] = Sc_n[7];

        if (!csreset && tx_enable_n[2]) Sd_n[6] = Sc_n[6] ^ TXD[6];
        else if (csreset)               Sd_n[6] = cs_prev[1];
        else                            Sd_n[6] = Sc_n[6];

        if (tx_enable_n[2]) Sd_n[5:4] = Sc_n[5:4] ^ TXD[5:4];
        else                Sd_n[5:4] = Sc_n[5:4];

        if (tx_enable_n[2]) Sd_n[3] = Sc_n[3] ^ TXD[3];
        else                Sd_n[3] = Sc_n[3];

        if (tx_enable_n[2]) Sd_n[2] = Sc_n[2] ^ TXD[2];
        else                Sd_n[2] = Sc_n[2];

        if (tx_enable_n[2]) Sd_n[1] = Sc_n[1] ^ TXD[1];
        else                Sd_n[1] = Sc_n[1] ^ 1'b1;

        Sd_n[0] = (Sc_n[0] ^ tx_enable_n[2]) ? TXD[0] : 1'b0;

        if (tx_enable_n[2]) cs_next[1] = Sd_n[6] ^ cs_prev[1];
        else                cs_next[1] = '0;

        if (tx_enable_n[2]) cs_next[2] = Sd_n[7] ^ TXD[7];
        else                cs_next[2] = '0;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) cs_prev <= '0;
        else     cs_prev <= cs_next;
    end

endmodule

module tx_table_dut_ref (
    input  logic [2:0]         tx_state,
    input  logic               TX_EN,
    input  logic [8:0]         Sd_n,
    output logic signed [2:0]  TA_n,
    output logic signed [2:0]  TB_n,
    output logic signed [2:0]  TC_n,
    output logic signed [2:0]  TD_n
);
    import pcs_tx_pkg::*;

    localparam logic [3:0] ROW_CSRESET    = 4'd2;
    localparam logic [3:0] ROW_SSD1       = 4'd5;
    localparam logic [3:0] ROW_SSD2       = 4'd6;
    localparam logic [3:0] ROW_ESD1       = 4'd7;
    localparam logic [3:0] ROW_ESD2_EXT_0 = 4'd8;

    localparam logic [2:0] ST_RESET = 3'd0;
    localparam logic [2:0] ST_IDLE  = 3'd1;
    localparam logic [2:0] ST_SDD2  = 3'd2;
    localparam logic [2:0] ST_DATA  = 3'd3;
    localparam logic [2:0] ST_CSR2  = 3'd4;
    localparam logic [2:0] ST_ESD1  = 3'd5;
    localparam logic [2:0] ST_ESD2  = 3'd6;

    logic [1:0]      subset_col;
    logic            subset_is_odd;
    tx_table_entry_t table_entry;

    always_comb begin
        subset_col    = {Sd_n[6], Sd_n[7]};
        subset_is_odd = Sd_n[8];

        unique case (tx_state)
            ST_IDLE: if (TX_EN) table_entry = TX_TABLE_SPECIAL_EVEN[ROW_SSD1][2'd0];
                     else       table_entry = TX_TABLE_NORMAL_EVEN[2'd0][Sd_n[5:0]];
            ST_SDD2:            table_entry = TX_TABLE_SPECIAL_EVEN[ROW_SSD2][2'd0];
            ST_DATA: if (TX_EN) table_entry = subset_is_odd ? TX_TABLE_NORMAL_ODD[subset_col][Sd_n[5:0]] :
                                                              TX_TABLE_NORMAL_EVEN[subset_col][Sd_n[5:0]];
                     else       table_entry = subset_is_odd ? TX_TABLE_SPECIAL_ODD[ROW_CSRESET][subset_col] :
                                                              TX_TABLE_SPECIAL_EVEN[ROW_CSRESET][subset_col];
            ST_CSR2:            table_entry = subset_is_odd ? TX_TABLE_SPECIAL_ODD[ROW_CSRESET][subset_col] :
                                                              TX_TABLE_SPECIAL_EVEN[ROW_CSRESET][subset_col];
            ST_ESD1:            table_entry = TX_TABLE_SPECIAL_EVEN[ROW_ESD1][2'd0];
            ST_ESD2:            table_entry = TX_TABLE_SPECIAL_EVEN[ROW_ESD2_EXT_0][2'd0];
            default:            table_entry = TX_TABLE_NORMAL_EVEN[2'd0][Sd_n[5:0]];
        endcase

        TA_n = table_entry.TA_n;
        TB_n = table_entry.TB_n;
        TC_n = table_entry.TC_n;
        TD_n = table_entry.TD_n;
    end

endmodule

module pcs_tx_dut_ref #(
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

    tx_sc_gen_dut_ref u_tx_sc_gen (
        .clk         (clk),
        .rst         (rst),
        .tx_enable_n (tx_enable_n[2:0]),
        .Sy_n        (Sy_n),
        .Sx_n        (Sx_n),
        .Sc_n        (Sc_n)
    );

    logic [8:0] Sd_n;

    tx_sd_gen_dut_ref u_tx_sd_gen (
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
            ST_DATA:    if (!TX_EN) {next_state, csreset} = {ST_CSR2, 1'b1};
            ST_CSR2:                {next_state, csreset} = {ST_ESD1, 1'b1};
            ST_ESD1:                next_state = ST_ESD2;
            ST_ESD2:                next_state = ST_IDLE;
            default:                next_state = ST_IDLE;
        endcase
    end

    logic signed [2:0] TA_n;
    logic signed [2:0] TB_n;
    logic signed [2:0] TC_n;
    logic signed [2:0] TD_n;

    tx_table_dut_ref u_tx_table (
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
