`ifndef TX_SC_GEN_SV
`define TX_SC_GEN_SV

module tx_sc_gen (
    input  logic        clk,
    input  logic        rst,

    // dut inputs
    input  logic [2:0]  tx_enable_n,  // [2] = tx_enable_{n-2}, [1] = tx_enable_{n-1}, [0] = tx_enable_{n}
    input  logic        tx_mode,

    // internal inputs
    input  logic [3:0]  Sy_n,
    input  logic [3:0]  Sx_n,

    output logic [7:0]  Sc_n
);
    logic [3:0]  Sy_prev;
    logic        sc_even_phase;

    always_comb begin
        // Sc_n[7:4]
        if (tx_enable_n[2])         Sc_n[7:4] = Sx_n[3:0];
        else                        Sc_n[7:4] = '0;

        // Sc_n[3:1]
        if (tx_mode)                Sc_n[3:1] = '0;
        else if (sc_even_phase)     Sc_n[3:1] = Sy_n[3:1];
        else                        Sc_n[3:1] = Sy_prev[3:1] ^ 3'b111;

        // Sc_n[0]
        if (tx_mode)                Sc_n[0] = '0;
        else                        Sc_n[0] = Sy_n[0];
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            Sy_prev             <= '0;
            sc_even_phase       <= 1'b1;
        end else begin
            Sy_prev             <= Sy_n;
            sc_even_phase       <= ~sc_even_phase;
        end
    end

endmodule

`endif
