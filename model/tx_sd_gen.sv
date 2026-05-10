`ifndef TX_SD_GEN_SV
`define TX_SD_GEN_SV

module tx_sd_gen (
    input  logic        clk,
    input  logic        rst,

    input  logic [2:0]  tx_enable_n,
    input  logic        tx_error,
    input  logic [7:0]  TXD,
    input  logic        tx_mode,
    input  logic        loc_rcvr_status,
    input  logic        loc_lpi_req,
    input  logic        loc_update_done,

    input  logic [7:0]  Sc_n,

    output logic [8:0]  Sd_n
);
    logic [2:0] cs_prev;
    logic [2:0] cs_next;

    logic       csreset_n;
    logic       cext_n;
    logic       cext_err_n;

    always_comb begin
        csreset_n  = tx_enable_n[2] & ~tx_enable_n[0];
        cext_n     = (!tx_enable_n[0] && (TXD == 8'h0F)) ? tx_error : 1'b0;
        cext_err_n = (!tx_enable_n[0] && (TXD != 8'h0F) && !loc_lpi_req) ? tx_error : 1'b0;

        cs_next[0] = cs_prev[2];
        Sd_n[8]    = cs_next[0];

        if (!csreset_n && tx_enable_n[2]) Sd_n[7] = Sc_n[7] ^ TXD[7];
        else if (csreset_n)               Sd_n[7] = cs_prev[1];
        else                              Sd_n[7] = Sc_n[7];

        if (!csreset_n && tx_enable_n[2]) Sd_n[6] = Sc_n[6] ^ TXD[6];
        else if (csreset_n)               Sd_n[6] = cs_prev[0];
        else                              Sd_n[6] = Sc_n[6];

        if (tx_enable_n[2]) Sd_n[5:4] = Sc_n[5:4] ^ TXD[5:4];
        else                Sd_n[5:4] = Sc_n[5:4];

        if (tx_enable_n[2])              Sd_n[3] = Sc_n[3] ^ TXD[3];
        else if (loc_lpi_req && !tx_mode) Sd_n[3] = Sc_n[3] ^ 1'b1;
        else                             Sd_n[3] = Sc_n[3];

        if (tx_enable_n[2])                    Sd_n[2] = Sc_n[2] ^ TXD[2];
        else if (loc_rcvr_status && !tx_mode)  Sd_n[2] = Sc_n[2] ^ 1'b1;
        else                                   Sd_n[2] = Sc_n[2];

        if (tx_enable_n[2])                    Sd_n[1] = Sc_n[1] ^ TXD[1];
        else if (loc_update_done && !tx_mode)  Sd_n[1] = Sc_n[1] ^ 1'b1;
        else                                   Sd_n[1] = Sc_n[1] ^ cext_err_n;

        if (tx_enable_n[2]) Sd_n[0] = Sc_n[0] ^ TXD[0];
        else                Sd_n[0] = Sc_n[0] ^ cext_n;

        if (tx_enable_n[2]) cs_next[1] = Sd_n[6] ^ cs_prev[0];
        else                cs_next[1] = '0;

        if (tx_enable_n[2]) cs_next[2] = Sd_n[7] ^ cs_prev[1];
        else                cs_next[2] = '0;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) cs_prev <= '0;
        else     cs_prev <= cs_next;
    end

endmodule

`endif
