`ifndef INTERFACE_SV
`define INTERFACE_SV

interface encoder_if (input logic clk);

    logic        rst_n;
    logic [7:0]  Din;
    logic        TX_EN;
    int unsigned scenario_id;
    logic [3:0][2:0] Dout_ref;
    logic [3:0][2:0] Dout;

    clocking drv_cb @(posedge clk);
        default input #1step output #1step;
        output rst_n;
        output Din;
        output TX_EN;
        output scenario_id;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        input rst_n;
        input Din;
        input TX_EN;
        input scenario_id;
        input Dout_ref;
        input Dout;
    endclocking

    modport DUT (
        input  clk,
        input  rst_n,
        input  Din,
        input  TX_EN,
        output Dout
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
