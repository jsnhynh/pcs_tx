`ifndef TX_SCRAMBLER_SV
`define TX_SCRAMBLER_SV

module tx_scrambler #(
    parameter logic [32:0] SCR_SEED = 33'h1
) (
    input  logic         clk,
    input  logic         rst,
    input  logic         config_i,
    output logic [3:0]   Sy_n,
    output logic [3:0]   Sx_n,
    output logic [3:0]   Sg_n
);
    logic [32:0] Scr_n, Scr_next;

    always_comb begin
        // master lfsr: x13 + x33
        // slave lfsr: x20 + x33
        Scr_next = (config_i) ? {Scr_n[31:0], Scr_n[12] ^ Scr_n[32]} :
                                {Scr_n[31:0], Scr_n[19] ^ Scr_n[32]};

        // scramble bits
        Sy_n[0] = Scr_n[0];
        Sy_n[1] = Scr_n[3]  ^ Scr_n[8];
        Sy_n[2] = Scr_n[6]  ^ Scr_n[16];
        Sy_n[3] = Scr_n[9]  ^ Scr_n[14] ^ Scr_n[19] ^ Scr_n[24];

        Sx_n[0] = Scr_n[4]  ^ Scr_n[6];
        Sx_n[1] = Scr_n[7]  ^ Scr_n[9]  ^ Scr_n[12] ^ Scr_n[14];
        Sx_n[2] = Scr_n[10] ^ Scr_n[12] ^ Scr_n[20] ^ Scr_n[22];
        Sx_n[3] = Scr_n[13] ^ Scr_n[15] ^ Scr_n[18] ^ Scr_n[20]
                ^ Scr_n[23] ^ Scr_n[25] ^ Scr_n[28] ^ Scr_n[30];

        Sg_n[0] = Scr_n[1]  ^ Scr_n[5];
        Sg_n[1] = Scr_n[4]  ^ Scr_n[8]  ^ Scr_n[9]  ^ Scr_n[13];
        Sg_n[2] = Scr_n[7]  ^ Scr_n[11] ^ Scr_n[17] ^ Scr_n[21];
        Sg_n[3] = Scr_n[10] ^ Scr_n[14] ^ Scr_n[15] ^ Scr_n[19]
                ^ Scr_n[20] ^ Scr_n[24] ^ Scr_n[25] ^ Scr_n[29];
    end

    // lfsr shift
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Scr_n <= (SCR_SEED == '0) ? 33'h1 : SCR_SEED;
        else
            Scr_n <= Scr_next;
    end

endmodule

`endif
