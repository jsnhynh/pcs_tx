`ifndef PCS_TX_CMD_PKG_SV
`define PCS_TX_CMD_PKG_SV

package pcs_tx_cmd_pkg;
    localparam logic [7:0] PCS_TX_CMD_IDLE        = 8'h00;
    localparam logic [7:0] PCS_TX_CMD_TX_ERROR    = 8'h01;
    localparam logic [7:0] PCS_TX_CMD_CARRIER_EXT = 8'h0F;
endpackage

`endif
