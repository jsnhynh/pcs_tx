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
    pcs_tx_mon_if dif_dut(clk);

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
        .A_n             (dif_ref.A_n),
        .B_n             (dif_ref.B_n),
        .C_n             (dif_ref.C_n),
        .D_n             (dif_ref.D_n)
    );

    pcs_tx u_dut (
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
        .A_n             (dif_dut.A_n),
        .B_n             (dif_dut.B_n),
        .C_n             (dif_dut.C_n),
        .D_n             (dif_dut.D_n)
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

        uvm_config_db #(virtual pcs_tx_mon_if)::set(null, "*.agt.*",   "vif", dif_ref);
        uvm_config_db #(virtual pcs_tx_mon_if)::set(null, "*.mon_out_gm", "vif", dif_ref);
        uvm_config_db #(virtual pcs_tx_mon_if)::set(null, "*.mon_out_dut","vif", dif_dut);
        uvm_config_db #(virtual pcs_tx_mon_if)::set(null, "*",          "vif", dif_ref);

        run_test("test");
    end

endmodule

`endif
