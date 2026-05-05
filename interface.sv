`ifndef INTERFACE_SV
`define INTERFACE_SV

interface pcs_tx_mon_if(input logic clk);

    logic        rst;

    logic [7:0]  TXD;
    logic        tx_enable;
    logic        tx_error;
    logic        tx_mode;
    logic        config_i;
    logic        loc_rcvr_status;
    logic        loc_lpi_req;
    logic        loc_update_done;

    logic signed [2:0] A_n;
    logic signed [2:0] B_n;
    logic signed [2:0] C_n;
    logic signed [2:0] D_n;

    clocking drv_cb @(posedge clk);
        default input #1step output #1step;
        output rst;
        output TXD;
        output tx_enable;
        output tx_error;
        output tx_mode;
        output config_i;
        output loc_rcvr_status;
        output loc_lpi_req;
        output loc_update_done;
        input  A_n;
        input  B_n;
        input  C_n;
        input  D_n;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        input rst;
        input TXD;
        input tx_enable;
        input tx_error;
        input tx_mode;
        input config_i;
        input loc_rcvr_status;
        input loc_lpi_req;
        input loc_update_done;
        input A_n;
        input B_n;
        input C_n;
        input D_n;
    endclocking

    modport DUT (
        input  clk,
        input  rst,
        input  TXD,
        input  tx_enable,
        input  tx_error,
        input  tx_mode,
        input  config_i,
        input  loc_rcvr_status,
        input  loc_lpi_req,
        input  loc_update_done,
        output A_n,
        output B_n,
        output C_n,
        output D_n
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

interface pcs_tx_out_if(input logic clk);

    logic        rst;

    logic signed [2:0] A_n;
    logic signed [2:0] B_n;
    logic signed [2:0] C_n;
    logic signed [2:0] D_n;

    clocking mon_cb @(posedge clk);
        default input #1step;
        input rst;
        input A_n;
        input B_n;
        input C_n;
        input D_n;
    endclocking

    modport MON (
        clocking mon_cb,
        input clk
    );

endinterface

`endif
