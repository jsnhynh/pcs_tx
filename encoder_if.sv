interface encoder_if(input logic clk);

  // ------------------------------------------------------------
  // DUT signals
  // ------------------------------------------------------------
  logic        rst_n;

  // Project input:
  //   tx_in[8]   = 1   //command/control
  //   tx_in[8]   = 0   //data
  //   tx_in[7:0]       //payload or command code
  logic [8:0]  tx_in;

  // Project output:
  logic [11:0] tx_out;  //12-bit encoded output from DUT

  // ------------------------------------------------------------
  // Clocking blocks
  // ------------------------------------------------------------
  clocking drv_cb @(posedge clk);
    default input #1step output #1step;
    output rst_n;
    output tx_in;
    input  tx_out;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1step output #1step;
    input rst_n;
    input tx_in;
    input tx_out;
  endclocking

  // ------------------------------------------------------------
  // Modports
  // ------------------------------------------------------------
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
