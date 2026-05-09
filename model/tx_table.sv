`ifndef TX_TABLE_SV
`define TX_TABLE_SV

module tx_table (
    input  logic [2:0]         tx_state,
    input  logic               TX_EN,
    input  logic [8:0]         Sd_n,

    output logic signed [2:0]  TA_n,
    output logic signed [2:0]  TB_n,
    output logic signed [2:0]  TC_n,
    output logic signed [2:0]  TD_n
);
    import pcs_tx_pkg::*;

    localparam logic [3:0] ROW_CSRESET        = 4'd2;
    localparam logic [3:0] ROW_SSD1           = 4'd5;
    localparam logic [3:0] ROW_SSD2           = 4'd6;
    localparam logic [3:0] ROW_ESD1           = 4'd7;
    localparam logic [3:0] ROW_ESD2_EXT_0     = 4'd8;

    localparam logic [2:0] ST_RESET            = 3'd0;
    localparam logic [2:0] ST_IDLE             = 3'd1;
    localparam logic [2:0] ST_SDD2             = 3'd2;
    localparam logic [2:0] ST_DATA             = 3'd3;
    localparam logic [2:0] ST_CSR2             = 3'd4;
    localparam logic [2:0] ST_ESD1             = 3'd5;
    localparam logic [2:0] ST_ESD2             = 3'd6;

    logic [1:0]            subset_col;
    logic                  subset_is_odd;
    tx_table_entry_t       table_entry;

    always_comb begin
        subset_col    = {Sd_n[6], Sd_n[7]};
        subset_is_odd = Sd_n[8];

        unique case (tx_state)
            ST_IDLE: if (TX_EN) table_entry = TX_TABLE_SPECIAL_EVEN[ROW_SSD1][2'd0];
                    else        table_entry = TX_TABLE_NORMAL_EVEN[2'd0][Sd_n[5:0]];
            ST_SDD2:            table_entry = TX_TABLE_SPECIAL_EVEN[ROW_SSD2][2'd0];
            ST_DATA: if (TX_EN) table_entry = subset_is_odd ? TX_TABLE_NORMAL_ODD[subset_col][Sd_n[5:0]]    : TX_TABLE_NORMAL_EVEN[subset_col][Sd_n[5:0]];
                    else        table_entry = subset_is_odd ? TX_TABLE_SPECIAL_ODD[ROW_CSRESET][subset_col] : TX_TABLE_SPECIAL_EVEN[ROW_CSRESET][subset_col];
            ST_CSR2:            table_entry = subset_is_odd ? TX_TABLE_SPECIAL_ODD[ROW_CSRESET][subset_col] : TX_TABLE_SPECIAL_EVEN[ROW_CSRESET][subset_col];
            ST_ESD1:            table_entry = TX_TABLE_SPECIAL_EVEN[ROW_ESD1][2'd0];
            ST_ESD2:            table_entry = TX_TABLE_SPECIAL_EVEN[ROW_ESD2_EXT_0][2'd0];
            default:            table_entry = TX_TABLE_NORMAL_EVEN[2'd0][Sd_n[5:0]];
        endcase

        TA_n = table_entry.TA_n;
        TB_n = table_entry.TB_n;
        TC_n = table_entry.TC_n;
        TD_n = table_entry.TD_n;
    end

endmodule

`endif
