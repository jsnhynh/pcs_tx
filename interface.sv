`ifndef INTERFACE_SV
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

`endif
