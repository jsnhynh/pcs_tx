`ifndef TB_TOP_SV
`define TB_TOP_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "model/pcs_tx_cmd_pkg.sv"
`include "model/pcs_tx_pkg.sv"
import pcs_tx_cmd_pkg::*;

`include "interface.sv"
`include "DUTS26_0.sv"

`include "model/tx_scrambler.sv"
`include "model/tx_sc_gen.sv"
`include "model/tx_sd_gen.sv"
`include "model/tx_table.sv"
`include "model/tx_sign_rev.sv"
`include "model/pcs_tx.sv"

`include "seq_item.sv"
`include "sequencer.sv"
`include "sequence.sv"
`include "driver.sv"
`include "monitor_in.sv"
`include "monitor_out.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"

module tb_top;
    logic clk;
    logic dut_rst;

    encoder_if dif(clk);

    assign dut_rst = ~dif.rst_n;

    // PCS_TX golden model
    pcs_tx u_ref (
        .clk  (clk),
        .rst  (dut_rst),
        .Din  (dif.Din),
        .TX_EN(dif.TX_EN),
        .Dout (dif.Dout_ref)
    );

    // DUT
    DUTS26_0 u_dut (
        .Clk   (clk),
        .Reset (dut_rst),
        .Din   (dif.Din),
        .TX_EN (dif.TX_EN),
        .Dout  (dif.Dout)
    );


    always #5 clk <= ~clk;

    initial begin
        clk = 1'b0;

        dif.rst_n       = 1'b0;
        dif.Din         = 8'h00;
        dif.TX_EN       = 1'b0;
        dif.scenario_id = 0;

        uvm_config_db #(virtual encoder_if)::set(null, "uvm_test_top", "vif", dif);
        uvm_config_db #(virtual encoder_if)::set(null, "uvm_test_top.e.*", "vif", dif);
        uvm_config_db #(bit)::set(null, "uvm_test_top.e.mon_out_gm", "use_dut_output", 1'b0);
        uvm_config_db #(bit)::set(null, "uvm_test_top.e.mon_out_dut", "use_dut_output", 1'b1);

        run_test("test");
    end

endmodule

`endif
