`ifndef TX_SD_GEN_SV
`define TX_SD_GEN_SV

module tx_sd_gen (
    input  logic        clk,
    input  logic        rst,

    input  logic [2:0]  tx_enable_n,
    input  logic [7:0]  TXD,
    input  logic        csreset,

    // from sc gen
    input  logic [7:0]  Sc_n,

    output logic [8:0]  Sd_n
);
    // convolutional state
    logic [2:0]  cs_prev;
    logic [2:0]  cs_next;

    always_comb begin
        cs_next[0] = cs_prev[2];

        // sd bit 8
        Sd_n[8] = cs_next[0];

        // sd bit 7
        if (!csreset && tx_enable_n[2])     Sd_n[7] = Sc_n[7] ^ TXD[7];
        else if (csreset)                   Sd_n[7] = cs_prev[1];
        else                                Sd_n[7] = Sc_n[7];

        // sd bit 6
        if (!csreset && tx_enable_n[2])     Sd_n[6] = Sc_n[6] ^ TXD[6];
        else if (csreset)                   Sd_n[6] = cs_prev[1];
        else                                Sd_n[6] = Sc_n[6];

        // sd bits 5:4
        if (tx_enable_n[2])                 Sd_n[5:4] = Sc_n[5:4] ^ TXD[5:4];
        else                                Sd_n[5:4] = Sc_n[5:4];

        // sd bit 3
        if (tx_enable_n[2])                 Sd_n[3] = Sc_n[3] ^ TXD[3];
        else                                Sd_n[3] = Sc_n[3];

        // sd bit 2
        if (tx_enable_n[2])                 Sd_n[2] = Sc_n[2] ^ TXD[2];
        else                                Sd_n[2] = Sc_n[2];

        // sd bit 1
        if (tx_enable_n[2])                 Sd_n[1] = Sc_n[1] ^ TXD[1];
        else                                Sd_n[1] = Sc_n[1] ^ 1'b1;

        // sd bit 0
        Sd_n[0] = (Sc_n[0] ^ tx_enable_n[2]) ? TXD[0] : 1'b0;

        if (tx_enable_n[2])                 cs_next[1] = Sd_n[6] ^ cs_prev[1];
        else                                cs_next[1] = '0;

        if (tx_enable_n[2])                 cs_next[2] = Sd_n[7] ^ TXD[7];
        else                                cs_next[2] = '0;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cs_prev <= '0;
        end else begin
            cs_prev <= cs_next;
        end
    end

endmodule

`endif
