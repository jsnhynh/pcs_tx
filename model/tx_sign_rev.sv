module tx_sign_rev (
    input  logic [4:0]         tx_enable_n,  // [4] = tx_enable_{n-4}, ... [0] = tx_enable_n
    input  logic [3:0]         Sg_n,

    input  logic signed [2:0]  TA_n,
    input  logic signed [2:0]  TB_n,
    input  logic signed [2:0]  TC_n,
    input  logic signed [2:0]  TD_n,

    output logic signed [2:0]  A_n,
    output logic signed [2:0]  B_n,
    output logic signed [2:0]  C_n,
    output logic signed [2:0]  D_n
);
    logic Srev_n;

    always_comb begin
        Srev_n = tx_enable_n[2] ^ tx_enable_n[4];

        A_n = (Sg_n[0] ^ Srev_n) ? -TA_n : TA_n;
        B_n = (Sg_n[1] ^ Srev_n) ? -TB_n : TB_n;
        C_n = (Sg_n[2] ^ Srev_n) ? -TC_n : TC_n;
        D_n = (Sg_n[3] ^ Srev_n) ? -TD_n : TD_n;
    end

endmodule
