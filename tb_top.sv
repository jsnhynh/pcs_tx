`ifndef TB_TOP_SV
`define TB_TOP_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
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

    pcs_tx_mon_if dif_ref(clk);
    pcs_tx_out_if ref_out(clk);
    pcs_tx_out_if dut_out(clk);

    assign ref_out.rst = dif_ref.rst;
    assign dut_out.rst = dif_ref.rst;

    pcs_tx u_ref (
        .clk             (clk),
        .rst             (dif_ref.rst),
        .TXD             (dif_ref.TXD),
        .tx_enable       (dif_ref.tx_enable),
        .tx_error        (dif_ref.tx_error),
        .tx_mode         (dif_ref.tx_mode),
        .config_i        (dif_ref.config_i),
        .loc_rcvr_status (dif_ref.loc_rcvr_status),
        .loc_lpi_req     (dif_ref.loc_lpi_req),
        .loc_update_done (dif_ref.loc_update_done),
        .A_n             (ref_out.A_n),
        .B_n             (ref_out.B_n),
        .C_n             (ref_out.C_n),
        .D_n             (ref_out.D_n)
    );

`ifdef DUT_IS_GOLDEN
    pcs_tx u_dut (
`else
    pcs_tx_broken u_dut (
`endif
        .clk             (clk),
        .rst             (dif_ref.rst),
        .TXD             (dif_ref.TXD),
        .tx_enable       (dif_ref.tx_enable),
        .tx_error        (dif_ref.tx_error),
        .tx_mode         (dif_ref.tx_mode),
        .config_i        (dif_ref.config_i),
        .loc_rcvr_status (dif_ref.loc_rcvr_status),
        .loc_lpi_req     (dif_ref.loc_lpi_req),
        .loc_update_done (dif_ref.loc_update_done),
        .A_n             (dut_out.A_n),
        .B_n             (dut_out.B_n),
        .C_n             (dut_out.C_n),
        .D_n             (dut_out.D_n)
    );

    always #5 clk <= ~clk;

    initial begin
        clk = 1'b0;

        dif_ref.rst              = 1'b1;
        dif_ref.config_i         = 1'b1;
        dif_ref.TXD              = 8'h00;
        dif_ref.tx_enable        = 1'b0;
        dif_ref.tx_error         = 1'b0;
        dif_ref.tx_mode          = 1'b0;
        dif_ref.loc_rcvr_status  = 1'b0;
        dif_ref.loc_lpi_req      = 1'b0;
        dif_ref.loc_update_done  = 1'b0;
        dif_ref.scenario_id      = 0;

        uvm_config_db #(virtual pcs_tx_mon_if)::set(null, "uvm_test_top",       "vif", dif_ref);
        uvm_config_db #(virtual pcs_tx_mon_if)::set(null, "uvm_test_top.e.agt.*","vif", dif_ref);
        uvm_config_db #(virtual pcs_tx_out_if)::set(null, "uvm_test_top.e.mon_out_gm", "vif", ref_out);
        uvm_config_db #(virtual pcs_tx_out_if)::set(null, "uvm_test_top.e.mon_out_dut","vif", dut_out);

        run_test("test");
    end

endmodule

`endif
