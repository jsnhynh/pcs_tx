/*`ifndef INTERFACE_SV
`define INTERFACE_SV

interface encoder_if(input logic clk);
    logic        rst_n;

    logic [8:0]  tx_in;
    int unsigned scenario_id;
    logic [11:0] tx_out_ref;
    logic [11:0] tx_out;

    clocking drv_cb @(posedge clk);
        default input #1step output #1step;
        output rst_n;
        output tx_in;
        output scenario_id;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        input rst_n;
        input tx_in;
        input scenario_id;
        input tx_out_ref;
        input tx_out;
    endclocking

    modport DUT (
        input  clk,
        input  rst_n,
        input  tx_in,
        output tx_out
    );

    modport DRV (
        clocking drv_cb,
        input clk
    );

    modport MON (
        clocking mon_cb,
        input clk
    );

endinterface

`endif*/




`ifndef INTERFACE_SV
`define INTERFACE_SV

// =============================================================================
// FILE   : interface.sv
// =============================================================================

interface encoder_if (input logic clk);

    // ------------------------------------------------------------------
    // Signals
    // ------------------------------------------------------------------
    logic        rst_n;          // active-LOW reset
                                 
    logic [8:0]  tx_in;          // 9-bit packed encoder input to both DUTs
    int unsigned scenario_id;    // test scenario tag for scoreboard reporting
    logic [11:0] tx_out_ref;     // reference output  (pcs_tx,  always running)
    logic [11:0] tx_out;         // DUT output        (pcs_tx_broken or wrapper)

    // ------------------------------------------------------------------
    // Driver clocking block
    //   output: driven #1step after posedge  (no race with DUT sampling)
    //   input : sampled #1step before posedge
    // ------------------------------------------------------------------
    clocking drv_cb @(posedge clk);
        default input #1step output #1step;
        output rst_n;
        output tx_in;
        output scenario_id;
    endclocking

    // ------------------------------------------------------------------
    // Monitor clocking block  (input side + both outputs)
    //   input only
    // ------------------------------------------------------------------
    clocking mon_cb @(posedge clk);
        default input #1step;
        input rst_n;
        input tx_in;
        input scenario_id;
        input tx_out_ref;   // monitor_out reads this when use_dut_output=0
        input tx_out;       // monitor_out reads this when use_dut_output=1
    endclocking

    // ------------------------------------------------------------------
    // Modports
    // ------------------------------------------------------------------

    // Used by pcs_tx, pcs_tx_broken, and dut26_0_wrapper
    modport DUT (
        input  clk,
        input  rst_n,
        input  tx_in,
        output tx_out
    );

    modport DRV (
        clocking drv_cb,
        input clk
    );

    modport MON (
        clocking mon_cb,
        input clk
    );

endinterface

`endif // INTERFACE_SV


// =============================================================================
// FILE   : dut26_0_wrapper.sv
// =============================================================================

`ifndef DUT26_0_WRAPPER_SV
`define DUT26_0_WRAPPER_SV

module dut26_0_wrapper (
    input  logic        clk,
    input  logic        rst,        // active HIGH  (tb_top: dut_rst = ~dif.rst_n)
    input  logic [8:0]  enc_in,     // from encoder_if.tx_in
    output logic [11:0] enc_out     // to   encoder_if.tx_out
);

    import pcs_tx_cmd_pkg::*;

    // Internal signals going to DUTS26_0
    logic [7:0]      Din;
    logic            TX_EN;
    logic [3:0][2:0] Dout;

    // ------------------------------------------------------------------
    // Decode enc_in[8:0]  →  Din[7:0] + TX_EN
    // ------------------------------------------------------------------
    always_comb 
        begin
        // safe defaults
        Din   = 8'h00;
        TX_EN = 1'b0;

        if (!enc_in[8]) 
            begin
            // data byte: passing through so need to assert TX_EN 
            Din   = enc_in[7:0];
            TX_EN = 1'b1;

            end 
        else 
            begin
            unique case (enc_in[7:0])

                PCS_TX_CMD_IDLE: 
                    begin
                    // normal idle  ---  TX_EN=0, Din=0x00
                    Din   = 8'h00;
                    TX_EN = 1'b0;
                    end

                PCS_TX_CMD_TX_ERROR: 
                    begin
                    // DUTS26_0 has no tx_error pin  ---  treat as idle
                    Din   = 8'h00;
                    TX_EN = 1'b0;
                    end

                PCS_TX_CMD_CARRIER_EXT:
                    begin
                    // carrier extend ---  TX_EN=0, Din=0x0F
                    Din   = 8'h0F;
                    TX_EN = 1'b0;
                    end

                default: 
                    begin
                    Din   = 8'h00;
                    TX_EN = 1'b0;
                    end

            endcase
            end
    end

    // ------------------------------------------------------------------
    // Repack Dout[3:0][2:0]  to  enc_out[11:0]
    //
    //   Dout[3] = A_n  -  enc_out[11:9]
    //   Dout[2] = B_n  -  enc_out[ 8:6]
    //   Dout[1] = C_n  -  enc_out[ 5:3]
    //   Dout[0] = D_n  -  enc_out[ 2:0]
    // ------------------------------------------------------------------
    assign enc_out = { Dout[3], Dout[2], Dout[1], Dout[0] };

    // ------------------------------------------------------------------
    // DUT26_0
    // ------------------------------------------------------------------
    DUTS26_0 u_dut26_0 (
        .Clk   (clk),
        .Reset (rst),
        .Din   (Din),
        .TX_EN (TX_EN),
        .Dout  (Dout)
    );

endmodule

`endif // DUT26_0_WRAPPER_SV

