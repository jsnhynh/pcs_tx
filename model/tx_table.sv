`ifndef TX_TABLE_SV
`define TX_TABLE_SV

module tx_table (
    input  logic [4:0]         tx_enable_n,  
    input  logic [3:0]         tx_error_n,   
    input  logic [7:0]         TXD,
    input  logic [8:0]         Sd_n,

    output logic signed [2:0]  TA_n,
    output logic signed [2:0]  TB_n,
    output logic signed [2:0]  TC_n,
    output logic signed [2:0]  TD_n
);
    import pcs_tx_pkg::*;

    localparam logic [3:0] ROW_NORMAL         = 4'd0;
    localparam logic [3:0] ROW_XMT_ERR        = 4'd1;
    localparam logic [3:0] ROW_CSRESET        = 4'd2;
    localparam logic [3:0] ROW_CSEXTEND       = 4'd3;
    localparam logic [3:0] ROW_CSEXTEND_ERR   = 4'd4;
    localparam logic [3:0] ROW_SSD1           = 4'd5;
    localparam logic [3:0] ROW_SSD2           = 4'd6;
    localparam logic [3:0] ROW_ESD1           = 4'd7;
    localparam logic [3:0] ROW_ESD2_EXT_0     = 4'd8;
    localparam logic [3:0] ROW_ESD2_EXT_1     = 4'd9;
    localparam logic [3:0] ROW_ESD2_EXT_2     = 4'd10;
    localparam logic [3:0] ROW_ESD_EXT_ERR    = 4'd11;

    logic [3:0]            row_sel;
    logic                  csreset_n;
    logic                  ssd_n;
    logic                  esd_n;
    logic                  esd_ext_err_n;
    logic [11:0]           row_hit;
    logic                  fixed_special_row;
    logic [1:0]            subset_col;
    logic                  subset_is_odd;
    tx_table_entry_t       table_entry;

    always_comb begin
        csreset_n     = tx_enable_n[2]  & ~tx_enable_n[0];
        ssd_n         = tx_enable_n[0]  & ~tx_enable_n[2];
        esd_n         = ~tx_enable_n[2] & tx_enable_n[4];
        row_hit       = '0;
        esd_ext_err_n     = (tx_error_n[0] && tx_error_n[1] && tx_error_n[2] && (TXD != 8'h0F)) ||
                            (tx_error_n[0] && tx_error_n[1] && tx_error_n[2] && tx_error_n[3] && (TXD != 8'h0F));

        // row priority from spec
        row_hit[ROW_XMT_ERR]      = tx_error_n[0]   && tx_enable_n[0]   && tx_enable_n[2];
        row_hit[ROW_CSRESET]      = csreset_n       && !tx_error_n[0];
        row_hit[ROW_CSEXTEND]     = csreset_n       && tx_error_n[0]    && (TXD == 8'h0F);
        row_hit[ROW_CSEXTEND_ERR] = csreset_n       && tx_error_n[0]    && (TXD != 8'h0F);
        row_hit[ROW_SSD1]         = ssd_n           && tx_enable_n[0]   && !tx_enable_n[1];
        row_hit[ROW_SSD2]         = ssd_n           && tx_enable_n[1]   && !tx_enable_n[2];
        row_hit[ROW_ESD_EXT_ERR]  = esd_n           && esd_ext_err_n;
        row_hit[ROW_ESD1]         = !tx_enable_n[2] && tx_enable_n[3];
        row_hit[ROW_ESD2_EXT_0]   = !tx_enable_n[3] && tx_enable_n[4]   && !tx_error_n[0]   && !tx_error_n[1];
        row_hit[ROW_ESD2_EXT_1]   = !tx_enable_n[3] && tx_enable_n[4]   && !tx_error_n[0]   &&
                                    tx_error_n[1]   && tx_error_n[2]    && tx_error_n[3];
        row_hit[ROW_ESD2_EXT_2]   = !tx_enable_n[3] && tx_enable_n[4]   && tx_error_n[0]    &&
                                    tx_error_n[1]   && tx_error_n[2]    && tx_error_n[3]    && (TXD == 8'h0F);

        row_sel = ROW_NORMAL;
        if      (row_hit[ROW_XMT_ERR])      row_sel = ROW_XMT_ERR;
        else if (row_hit[ROW_CSRESET])      row_sel = ROW_CSRESET;
        else if (row_hit[ROW_CSEXTEND])     row_sel = ROW_CSEXTEND;
        else if (row_hit[ROW_CSEXTEND_ERR]) row_sel = ROW_CSEXTEND_ERR;
        else if (row_hit[ROW_SSD1])         row_sel = ROW_SSD1;
        else if (row_hit[ROW_SSD2])         row_sel = ROW_SSD2;
        else if (row_hit[ROW_ESD_EXT_ERR])  row_sel = ROW_ESD_EXT_ERR;
        else if (row_hit[ROW_ESD1])         row_sel = ROW_ESD1;
        else if (row_hit[ROW_ESD2_EXT_0])   row_sel = ROW_ESD2_EXT_0;
        else if (row_hit[ROW_ESD2_EXT_1])   row_sel = ROW_ESD2_EXT_1;
        else if (row_hit[ROW_ESD2_EXT_2])   row_sel = ROW_ESD2_EXT_2;
    end

    always_comb begin
        subset_col    = Sd_n[8:7];
        subset_is_odd = Sd_n[6];
        fixed_special_row = (row_sel == ROW_SSD1)        ||
                            (row_sel == ROW_SSD2)        ||
                            (row_sel == ROW_ESD1)        ||
                            (row_sel == ROW_ESD2_EXT_0)  ||
                            (row_sel == ROW_ESD2_EXT_1)  ||
                            (row_sel == ROW_ESD2_EXT_2)  ||
                            (row_sel == ROW_ESD_EXT_ERR);

        if (row_sel == ROW_NORMAL) begin
            if (subset_is_odd) begin
                table_entry = TX_TABLE_NORMAL_ODD[subset_col][Sd_n[5:0]];
            end else begin
                table_entry = TX_TABLE_NORMAL_EVEN[subset_col][Sd_n[5:0]];
            end
        end else if (fixed_special_row) begin
            table_entry = TX_TABLE_SPECIAL_EVEN[row_sel][2'd0];
        end else begin
            if (subset_is_odd) begin
                table_entry = TX_TABLE_SPECIAL_ODD[row_sel][subset_col];
            end else begin
                table_entry = TX_TABLE_SPECIAL_EVEN[row_sel][subset_col];
            end
        end

        TA_n = table_entry.TA_n;
        TB_n = table_entry.TB_n;
        TC_n = table_entry.TC_n;
        TD_n = table_entry.TD_n;
    end

endmodule

`endif
