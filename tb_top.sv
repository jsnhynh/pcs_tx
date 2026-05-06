`ifndef TB_TOP_SV
`define TB_TOP_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "model/pcs_tx_cmd_pkg.sv"
`include "model/pcs_tx_pkg.sv"

`include "model/tx_scrambler.sv"
`include "model/tx_sc_gen.sv"
`include "model/tx_sd_gen.sv"
`include "model/tx_table.sv"
`include "model/tx_sign_rev.sv"
`include "model/pcs_tx.sv"
`include "model/pcs_tx_broken.sv"

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

    pcs_tx u_ref (
        .clk     (clk),
        .rst     (dut_rst),
        .enc_in  (dif.tx_in),
        .enc_out (dif.tx_out_ref)
    );

`ifdef DUT_IS_GOLDEN
    pcs_tx u_dut (
`else
    pcs_tx_broken u_dut (
`endif
        .clk     (clk),
        .rst     (dut_rst),
        .enc_in  (dif.tx_in),
        .enc_out (dif.tx_out)
    );

    always #5 clk <= ~clk;

    initial begin
        clk = 1'b0;

        dif.rst_n       = 1'b0;
        dif.tx_in       = {1'b1, PCS_TX_CMD_IDLE};
        dif.scenario_id = 0;

        uvm_config_db #(virtual encoder_if)::set(null, "uvm_test_top", "vif", dif);
        uvm_config_db #(virtual encoder_if)::set(null, "uvm_test_top.e.*", "vif", dif);
        uvm_config_db #(bit)::set(null, "uvm_test_top.e.mon_out_gm", "use_dut_output", 1'b0);
        uvm_config_db #(bit)::set(null, "uvm_test_top.e.mon_out_dut", "use_dut_output", 1'b1);

        run_test("test");
    end

endmodule

`endif
