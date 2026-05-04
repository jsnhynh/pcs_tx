`ifndef PCS_TX_PKG_SV
`define PCS_TX_PKG_SV

package pcs_tx_pkg;
    typedef struct packed {
        logic signed [2:0] TA_n;
        logic signed [2:0] TB_n;
        logic signed [2:0] TC_n;
        logic signed [2:0] TD_n;
    } tx_table_entry_t;

    // table 40-1: even subsets [000], [010], [100], [110]
    localparam tx_table_entry_t TX_TABLE_NORMAL_EVEN [4][64] = '{
        '{ // subset 000
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // 000000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // 000001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd0 }, // 000010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd0 }, // 000011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd0 }, // 000100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd0 }, // 000101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd0 }, // 000110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd0 }, // 000111
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n:-3'sd2 }, // 001000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd0, TD_n:-3'sd2 }, // 001001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd0, TD_n:-3'sd2 }, // 001010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd0, TD_n:-3'sd2 }, // 001011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n:-3'sd2, TD_n:-3'sd2 }, // 001100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n:-3'sd2, TD_n:-3'sd2 }, // 001101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n:-3'sd2, TD_n:-3'sd2 }, // 001110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n:-3'sd2, TD_n:-3'sd2 }, // 001111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd1 }, // 010000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd1 }, // 010001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd1 }, // 010010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd1 }, // 010011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd1 }, // 010100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd1 }, // 010101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd1 }, // 010110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd1 }, // 010111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd1, TD_n:-3'sd1 }, // 011000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd1, TD_n:-3'sd1 }, // 011001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd1, TD_n:-3'sd1 }, // 011010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd1, TD_n:-3'sd1 }, // 011011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n:-3'sd1, TD_n:-3'sd1 }, // 011100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n:-3'sd1, TD_n:-3'sd1 }, // 011101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n:-3'sd1, TD_n:-3'sd1 }, // 011110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n:-3'sd1, TD_n:-3'sd1 }, // 011111
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // 100000
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd0 }, // 100001
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd0 }, // 100010
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd0 }, // 100011
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd0, TD_n:-3'sd2 }, // 100100
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n: 3'sd0, TD_n:-3'sd2 }, // 100101
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n:-3'sd2, TD_n:-3'sd2 }, // 100110
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n:-3'sd2, TD_n:-3'sd2 }, // 100111
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101111
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n: 3'sd0, TD_n: 3'sd0 }, // 110000
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n: 3'sd0, TD_n: 3'sd0 }, // 110001
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n:-3'sd2, TD_n: 3'sd0 }, // 110010
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n:-3'sd2, TD_n: 3'sd0 }, // 110011
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n: 3'sd0, TD_n:-3'sd2 }, // 110100
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n: 3'sd0, TD_n:-3'sd2 }, // 110101
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n:-3'sd2, TD_n:-3'sd2 }, // 110110
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n:-3'sd2, TD_n:-3'sd2 }, // 110111
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd2 } // 111111
        },
        '{ // subset 010
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd1 }, // 000000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd1 }, // 000001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd1 }, // 000010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd1 }, // 000011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd1 }, // 000100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd1 }, // 000101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd1 }, // 000110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd1 }, // 000111
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd1, TD_n:-3'sd1 }, // 001000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd1, TD_n:-3'sd1 }, // 001001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd1, TD_n:-3'sd1 }, // 001010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd1, TD_n:-3'sd1 }, // 001011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n:-3'sd1, TD_n:-3'sd1 }, // 001100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n:-3'sd1, TD_n:-3'sd1 }, // 001101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n:-3'sd1, TD_n:-3'sd1 }, // 001110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n:-3'sd1, TD_n:-3'sd1 }, // 001111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd0 }, // 010000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd0 }, // 010001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd0 }, // 010010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd0 }, // 010011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd0 }, // 010100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd0 }, // 010101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd0 }, // 010110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd0 }, // 010111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd0, TD_n:-3'sd2 }, // 011000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd0, TD_n:-3'sd2 }, // 011001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd0, TD_n:-3'sd2 }, // 011010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd0, TD_n:-3'sd2 }, // 011011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n:-3'sd2, TD_n:-3'sd2 }, // 011100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n:-3'sd2, TD_n:-3'sd2 }, // 011101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n:-3'sd2, TD_n:-3'sd2 }, // 011110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n:-3'sd2, TD_n:-3'sd2 }, // 011111
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd1 }, // 100000
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd1 }, // 100001
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd1 }, // 100010
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd1 }, // 100011
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd1, TD_n:-3'sd1 }, // 100100
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n: 3'sd1, TD_n:-3'sd1 }, // 100101
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n:-3'sd1, TD_n:-3'sd1 }, // 100110
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n:-3'sd1, TD_n:-3'sd1 }, // 100111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101111
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd1 }, // 110000
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd1 }, // 110001
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n:-3'sd1, TD_n: 3'sd1 }, // 110010
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n:-3'sd1, TD_n: 3'sd1 }, // 110011
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n: 3'sd1, TD_n:-3'sd1 }, // 110100
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n: 3'sd1, TD_n:-3'sd1 }, // 110101
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n:-3'sd1, TD_n:-3'sd1 }, // 110110
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n:-3'sd1, TD_n:-3'sd1 }, // 110111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd2 } // 111111
        },
        '{ // subset 100
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd0 }, // 000000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd0 }, // 000001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd0 }, // 000010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd0 }, // 000011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd0 }, // 000100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd0 }, // 000101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd0 }, // 000110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd0 }, // 000111
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd1, TD_n:-3'sd2 }, // 001000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd1, TD_n:-3'sd2 }, // 001001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd1, TD_n:-3'sd2 }, // 001010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd1, TD_n:-3'sd2 }, // 001011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n:-3'sd1, TD_n:-3'sd2 }, // 001100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n:-3'sd1, TD_n:-3'sd2 }, // 001101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n:-3'sd1, TD_n:-3'sd2 }, // 001110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n:-3'sd1, TD_n:-3'sd2 }, // 001111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd1 }, // 010000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd1 }, // 010001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd1 }, // 010010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd1 }, // 010011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd1 }, // 010100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd1 }, // 010101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd1 }, // 010110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd1 }, // 010111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd0, TD_n:-3'sd1 }, // 011000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd0, TD_n:-3'sd1 }, // 011001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd0, TD_n:-3'sd1 }, // 011010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd0, TD_n:-3'sd1 }, // 011011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n:-3'sd2, TD_n:-3'sd1 }, // 011100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n:-3'sd2, TD_n:-3'sd1 }, // 011101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n:-3'sd2, TD_n:-3'sd1 }, // 011110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n:-3'sd2, TD_n:-3'sd1 }, // 011111
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd0 }, // 100000
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd0 }, // 100001
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd0 }, // 100010
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd0 }, // 100011
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd1, TD_n:-3'sd2 }, // 100100
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n: 3'sd1, TD_n:-3'sd2 }, // 100101
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n:-3'sd1, TD_n:-3'sd2 }, // 100110
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n:-3'sd1, TD_n:-3'sd2 }, // 100111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101111
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd0, TD_n: 3'sd1 }, // 110000
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n: 3'sd0, TD_n: 3'sd1 }, // 110001
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n:-3'sd2, TD_n: 3'sd1 }, // 110010
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n:-3'sd2, TD_n: 3'sd1 }, // 110011
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd0, TD_n:-3'sd1 }, // 110100
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n: 3'sd0, TD_n:-3'sd1 }, // 110101
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n:-3'sd2, TD_n:-3'sd1 }, // 110110
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n:-3'sd2, TD_n:-3'sd1 }, // 110111
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd2 } // 111111
        },
        '{ // subset 110
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd1 }, // 000000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd1 }, // 000001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd1 }, // 000010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd1 }, // 000011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd1 }, // 000100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd1 }, // 000101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd1 }, // 000110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd1 }, // 000111
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd0, TD_n:-3'sd1 }, // 001000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd0, TD_n:-3'sd1 }, // 001001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd0, TD_n:-3'sd1 }, // 001010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd0, TD_n:-3'sd1 }, // 001011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n:-3'sd2, TD_n:-3'sd1 }, // 001100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n:-3'sd2, TD_n:-3'sd1 }, // 001101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n:-3'sd2, TD_n:-3'sd1 }, // 001110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n:-3'sd2, TD_n:-3'sd1 }, // 001111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd0 }, // 010000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd0 }, // 010001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd0 }, // 010010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd0 }, // 010011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd0 }, // 010100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd0 }, // 010101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd0 }, // 010110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd0 }, // 010111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd1, TD_n:-3'sd2 }, // 011000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd1, TD_n:-3'sd2 }, // 011001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd1, TD_n:-3'sd2 }, // 011010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd1, TD_n:-3'sd2 }, // 011011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n:-3'sd1, TD_n:-3'sd2 }, // 011100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n:-3'sd1, TD_n:-3'sd2 }, // 011101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n:-3'sd1, TD_n:-3'sd2 }, // 011110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n:-3'sd1, TD_n:-3'sd2 }, // 011111
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd1 }, // 100000
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd1 }, // 100001
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd1 }, // 100010
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd1 }, // 100011
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd0, TD_n:-3'sd1 }, // 100100
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n: 3'sd0, TD_n:-3'sd1 }, // 100101
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n:-3'sd2, TD_n:-3'sd1 }, // 100110
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n:-3'sd2, TD_n:-3'sd1 }, // 100111
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101111
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd0 }, // 110000
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd0 }, // 110001
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n:-3'sd1, TD_n: 3'sd0 }, // 110010
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n:-3'sd1, TD_n: 3'sd0 }, // 110011
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd1, TD_n:-3'sd2 }, // 110100
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n: 3'sd1, TD_n:-3'sd2 }, // 110101
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n:-3'sd1, TD_n:-3'sd2 }, // 110110
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n:-3'sd1, TD_n:-3'sd2 }, // 110111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd2 } // 111111
        }
    };

    // Table 40-2: odd subsets [001], [011], [101], [111]
    localparam tx_table_entry_t TX_TABLE_NORMAL_ODD [4][64] = '{
        '{ // subset 001
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd1 }, // 000000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd1 }, // 000001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd1 }, // 000010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd1 }, // 000011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd1 }, // 000100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd1 }, // 000101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd1 }, // 000110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd1 }, // 000111
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n:-3'sd1 }, // 001000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd0, TD_n:-3'sd1 }, // 001001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd0, TD_n:-3'sd1 }, // 001010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd0, TD_n:-3'sd1 }, // 001011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n:-3'sd2, TD_n:-3'sd1 }, // 001100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n:-3'sd2, TD_n:-3'sd1 }, // 001101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n:-3'sd2, TD_n:-3'sd1 }, // 001110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n:-3'sd2, TD_n:-3'sd1 }, // 001111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd0 }, // 010000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd0 }, // 010001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd0 }, // 010010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd0 }, // 010011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd0 }, // 010100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd0 }, // 010101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd0 }, // 010110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd0 }, // 010111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd1, TD_n:-3'sd2 }, // 011000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd1, TD_n:-3'sd2 }, // 011001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd1, TD_n:-3'sd2 }, // 011010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd1, TD_n:-3'sd2 }, // 011011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n:-3'sd1, TD_n:-3'sd2 }, // 011100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n:-3'sd1, TD_n:-3'sd2 }, // 011101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n:-3'sd1, TD_n:-3'sd2 }, // 011110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n:-3'sd1, TD_n:-3'sd2 }, // 011111
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd1 }, // 100000
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd1 }, // 100001
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd1 }, // 100010
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd1 }, // 100011
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd0, TD_n:-3'sd1 }, // 100100
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n: 3'sd0, TD_n:-3'sd1 }, // 100101
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n:-3'sd2, TD_n:-3'sd1 }, // 100110
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n:-3'sd2, TD_n:-3'sd1 }, // 100111
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101111
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n: 3'sd0, TD_n: 3'sd1 }, // 110000
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n: 3'sd0, TD_n: 3'sd1 }, // 110001
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n:-3'sd2, TD_n: 3'sd1 }, // 110010
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n:-3'sd2, TD_n: 3'sd1 }, // 110011
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n: 3'sd0, TD_n:-3'sd1 }, // 110100
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n: 3'sd0, TD_n:-3'sd1 }, // 110101
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n:-3'sd2, TD_n:-3'sd1 }, // 110110
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n:-3'sd2, TD_n:-3'sd1 }, // 110111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd2 } // 111111
        },
        '{ // subset 011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd0 }, // 000000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd0 }, // 000001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd0 }, // 000010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd0 }, // 000011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd0 }, // 000100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd0 }, // 000101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd0 }, // 000110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd0 }, // 000111
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd1, TD_n:-3'sd2 }, // 001000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd1, TD_n:-3'sd2 }, // 001001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd1, TD_n:-3'sd2 }, // 001010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd1, TD_n:-3'sd2 }, // 001011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n:-3'sd1, TD_n:-3'sd2 }, // 001100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n:-3'sd1, TD_n:-3'sd2 }, // 001101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n:-3'sd1, TD_n:-3'sd2 }, // 001110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n:-3'sd1, TD_n:-3'sd2 }, // 001111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd1 }, // 010000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd1 }, // 010001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd1 }, // 010010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd1 }, // 010011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd1 }, // 010100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd1 }, // 010101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd1 }, // 010110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd1 }, // 010111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd0, TD_n:-3'sd1 }, // 011000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd0, TD_n:-3'sd1 }, // 011001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd0, TD_n:-3'sd1 }, // 011010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd0, TD_n:-3'sd1 }, // 011011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n:-3'sd2, TD_n:-3'sd1 }, // 011100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n:-3'sd2, TD_n:-3'sd1 }, // 011101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n:-3'sd2, TD_n:-3'sd1 }, // 011110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n:-3'sd2, TD_n:-3'sd1 }, // 011111
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd0 }, // 100000
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd0 }, // 100001
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd0 }, // 100010
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd0 }, // 100011
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd1, TD_n:-3'sd2 }, // 100100
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n: 3'sd1, TD_n:-3'sd2 }, // 100101
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n:-3'sd1, TD_n:-3'sd2 }, // 100110
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n:-3'sd1, TD_n:-3'sd2 }, // 100111
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101000
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101001
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101010
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd2, TD_n: 3'sd1 }, // 101011
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101100
            '{ TA_n:-3'sd1, TB_n: 3'sd1, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101101
            '{ TA_n: 3'sd1, TB_n:-3'sd1, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101110
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd2, TD_n:-3'sd1 }, // 101111
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd0 }, // 110000
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd0 }, // 110001
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n:-3'sd1, TD_n: 3'sd0 }, // 110010
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n:-3'sd1, TD_n: 3'sd0 }, // 110011
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n: 3'sd1, TD_n:-3'sd2 }, // 110100
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n: 3'sd1, TD_n:-3'sd2 }, // 110101
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n:-3'sd1, TD_n:-3'sd2 }, // 110110
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n:-3'sd1, TD_n:-3'sd2 }, // 110111
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111000
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111001
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111010
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd2 }, // 111011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111100
            '{ TA_n:-3'sd2, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111101
            '{ TA_n: 3'sd0, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd2 }, // 111110
            '{ TA_n:-3'sd2, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd2 } // 111111
        },
        '{ // subset 101
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd1 }, // 000000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd1 }, // 000001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd1 }, // 000010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd1 }, // 000011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd1 }, // 000100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd1 }, // 000101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd1 }, // 000110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd1 }, // 000111
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd1, TD_n:-3'sd1 }, // 001000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd1, TD_n:-3'sd1 }, // 001001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd1, TD_n:-3'sd1 }, // 001010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd1, TD_n:-3'sd1 }, // 001011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n:-3'sd1, TD_n:-3'sd1 }, // 001100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n:-3'sd1, TD_n:-3'sd1 }, // 001101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n:-3'sd1, TD_n:-3'sd1 }, // 001110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n:-3'sd1, TD_n:-3'sd1 }, // 001111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // 010000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // 010001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd0 }, // 010010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd0 }, // 010011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd0 }, // 010100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd0 }, // 010101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd0 }, // 010110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd0 }, // 010111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd0, TD_n:-3'sd2 }, // 011000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd0, TD_n:-3'sd2 }, // 011001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd0, TD_n:-3'sd2 }, // 011010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd0, TD_n:-3'sd2 }, // 011011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n:-3'sd2, TD_n:-3'sd2 }, // 011100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n:-3'sd2, TD_n:-3'sd2 }, // 011101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n:-3'sd2, TD_n:-3'sd2 }, // 011110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n:-3'sd2, TD_n:-3'sd2 }, // 011111
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd1 }, // 100000
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n: 3'sd1, TD_n: 3'sd1 }, // 100001
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n:-3'sd1, TD_n: 3'sd1 }, // 100010
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd1 }, // 100011
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd1, TD_n:-3'sd1 }, // 100100
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n: 3'sd1, TD_n:-3'sd1 }, // 100101
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n:-3'sd1, TD_n:-3'sd1 }, // 100110
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n:-3'sd1, TD_n:-3'sd1 }, // 100111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101111
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd0, TD_n: 3'sd0 }, // 110000
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n: 3'sd0, TD_n: 3'sd0 }, // 110001
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n:-3'sd2, TD_n: 3'sd0 }, // 110010
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n:-3'sd2, TD_n: 3'sd0 }, // 110011
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd0, TD_n:-3'sd2 }, // 110100
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n: 3'sd0, TD_n:-3'sd2 }, // 110101
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n:-3'sd2, TD_n:-3'sd2 }, // 110110
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n:-3'sd2, TD_n:-3'sd2 }, // 110111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd2 } // 111111
        },
        '{ // subset 111
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd0 }, // 000000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd0 }, // 000001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd0 }, // 000010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd0 }, // 000011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd0 }, // 000100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd0 }, // 000101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd0 }, // 000110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd0 }, // 000111
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd0, TD_n:-3'sd2 }, // 001000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd0, TD_n:-3'sd2 }, // 001001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd0, TD_n:-3'sd2 }, // 001010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd0, TD_n:-3'sd2 }, // 001011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n:-3'sd2, TD_n:-3'sd2 }, // 001100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n:-3'sd2, TD_n:-3'sd2 }, // 001101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n:-3'sd2, TD_n:-3'sd2 }, // 001110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n:-3'sd2, TD_n:-3'sd2 }, // 001111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd1 }, // 010000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd1 }, // 010001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd1 }, // 010010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd1, TD_n: 3'sd1 }, // 010011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd1 }, // 010100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n:-3'sd1, TD_n: 3'sd1 }, // 010101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd1 }, // 010110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd1 }, // 010111
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd1, TD_n:-3'sd1 }, // 011000
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n: 3'sd1, TD_n:-3'sd1 }, // 011001
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n: 3'sd1, TD_n:-3'sd1 }, // 011010
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd1, TD_n:-3'sd1 }, // 011011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n:-3'sd1, TD_n:-3'sd1 }, // 011100
            '{ TA_n:-3'sd1, TB_n: 3'sd0, TC_n:-3'sd1, TD_n:-3'sd1 }, // 011101
            '{ TA_n: 3'sd1, TB_n:-3'sd2, TC_n:-3'sd1, TD_n:-3'sd1 }, // 011110
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n:-3'sd1, TD_n:-3'sd1 }, // 011111
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd0 }, // 100000
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd0 }, // 100001
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd0 }, // 100010
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd0 }, // 100011
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd0, TD_n:-3'sd2 }, // 100100
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n: 3'sd0, TD_n:-3'sd2 }, // 100101
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n:-3'sd2, TD_n:-3'sd2 }, // 100110
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n:-3'sd2, TD_n:-3'sd2 }, // 100111
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd2, TD_n: 3'sd0 }, // 101011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd2, TD_n:-3'sd2 }, // 101111
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd1 }, // 110000
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd1 }, // 110001
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n:-3'sd1, TD_n: 3'sd1 }, // 110010
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n:-3'sd1, TD_n: 3'sd1 }, // 110011
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd1, TD_n:-3'sd1 }, // 110100
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n: 3'sd1, TD_n:-3'sd1 }, // 110101
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n:-3'sd1, TD_n:-3'sd1 }, // 110110
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n:-3'sd1, TD_n:-3'sd1 }, // 110111
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111000
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111001
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111010
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n: 3'sd0, TD_n: 3'sd2 }, // 111011
            '{ TA_n: 3'sd0, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111100
            '{ TA_n:-3'sd2, TB_n: 3'sd1, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111101
            '{ TA_n: 3'sd0, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd2 }, // 111110
            '{ TA_n:-3'sd2, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd2 } // 111111
        }
    };

    // special rows for table 40-1 (even subsets).
    localparam tx_table_entry_t TX_TABLE_SPECIAL_EVEN [12][4] = '{
        '{ // ROW_NORMAL_UNUSED
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 000
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 010
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 100
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 110
        },
        '{ // xmt_err
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n: 3'sd2, TD_n: 3'sd0 }, // subset 000
            '{ TA_n: 3'sd1, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd2 }, // subset 010
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd1, TD_n: 3'sd2 }, // subset 100
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd1 } // subset 110
        },
        '{ // CSReset
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n:-3'sd2, TD_n: 3'sd2 }, // subset 000
            '{ TA_n: 3'sd2, TB_n: 3'sd2, TC_n:-3'sd1, TD_n:-3'sd1 }, // subset 010
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n: 3'sd2, TD_n:-3'sd1 }, // subset 100
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n:-3'sd1, TD_n: 3'sd2 } // subset 110
        },
        '{ // CSExtend
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd2 }, // subset 000
            '{ TA_n: 3'sd2, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd1 }, // subset 010
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd2, TD_n: 3'sd1 }, // subset 100
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd2 } // subset 110
        },
        '{ // CSExtend_Err
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n: 3'sd2, TD_n:-3'sd2 }, // subset 000
            '{ TA_n:-3'sd1, TB_n:-3'sd1, TC_n: 3'sd2, TD_n: 3'sd2 }, // subset 010
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n:-3'sd1, TD_n: 3'sd2 }, // subset 100
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n: 3'sd2, TD_n:-3'sd1 } // subset 110
        },
        '{ // SSD1
            '{ TA_n: 3'sd2, TB_n: 3'sd2, TC_n: 3'sd2, TD_n: 3'sd2 }, // subset 000
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 010
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 100
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 110
        },
        '{ // SSD2
            '{ TA_n: 3'sd2, TB_n: 3'sd2, TC_n: 3'sd2, TD_n:-3'sd2 }, // subset 000
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 010
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 100
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 110
        },
        '{ // ESD1
            '{ TA_n: 3'sd2, TB_n: 3'sd2, TC_n: 3'sd2, TD_n: 3'sd2 }, // subset 000
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 010
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 100
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 110
        },
        '{ // ESD2_Ext_0
            '{ TA_n: 3'sd2, TB_n: 3'sd2, TC_n: 3'sd2, TD_n:-3'sd2 }, // subset 000
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 010
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 100
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 110
        },
        '{ // ESD2_Ext_1
            '{ TA_n: 3'sd2, TB_n: 3'sd2, TC_n:-3'sd2, TD_n: 3'sd2 }, // subset 000
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 010
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 100
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 110
        },
        '{ // ESD2_Ext_2
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n: 3'sd2, TD_n: 3'sd2 }, // subset 000
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 010
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 100
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 110
        },
        '{ // ESD_Ext_Err
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n: 3'sd2, TD_n: 3'sd2 }, // subset 000
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 010
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 100
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 110
        }
    };

    // special rows for Table 40-2 (odd subsets).
    // Only xmt_err/CSReset/CSExtend/CSExtend_Err are selected from this table.
    // ssd/esd rows are defined only in table 40-1 and are handled from the fixed even-row entry.
    localparam tx_table_entry_t TX_TABLE_SPECIAL_ODD [12][4] = '{
        '{ // ROW_NORMAL_UNUSED
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 001
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 101
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 111
        },
        '{ // xmt_err
            '{ TA_n: 3'sd2, TB_n: 3'sd2, TC_n: 3'sd0, TD_n: 3'sd1 }, // subset 001
            '{ TA_n: 3'sd0, TB_n: 3'sd2, TC_n: 3'sd1, TD_n: 3'sd2 }, // subset 011
            '{ TA_n: 3'sd1, TB_n: 3'sd2, TC_n: 3'sd2, TD_n: 3'sd0 }, // subset 101
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd2, TD_n: 3'sd0 } // subset 111
        },
        '{ // CSReset
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n: 3'sd2, TD_n:-3'sd1 }, // subset 001
            '{ TA_n: 3'sd2, TB_n:-3'sd2, TC_n:-3'sd1, TD_n: 3'sd2 }, // subset 011
            '{ TA_n:-3'sd1, TB_n:-3'sd2, TC_n: 3'sd2, TD_n: 3'sd2 }, // subset 101
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n:-3'sd2, TD_n: 3'sd2 } // subset 111
        },
        '{ // CSExtend
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd2, TD_n: 3'sd1 }, // subset 001
            '{ TA_n: 3'sd2, TB_n: 3'sd0, TC_n: 3'sd1, TD_n: 3'sd2 }, // subset 011
            '{ TA_n: 3'sd1, TB_n: 3'sd0, TC_n: 3'sd2, TD_n: 3'sd2 }, // subset 101
            '{ TA_n: 3'sd2, TB_n: 3'sd1, TC_n: 3'sd0, TD_n: 3'sd2 } // subset 111
        },
        '{ // CSExtend_Err
            '{ TA_n: 3'sd2, TB_n: 3'sd2, TC_n:-3'sd2, TD_n:-3'sd1 }, // subset 001
            '{ TA_n:-3'sd2, TB_n: 3'sd2, TC_n:-3'sd1, TD_n: 3'sd2 }, // subset 011
            '{ TA_n:-3'sd1, TB_n: 3'sd2, TC_n: 3'sd2, TD_n:-3'sd2 }, // subset 101
            '{ TA_n: 3'sd2, TB_n:-3'sd1, TC_n: 3'sd2, TD_n:-3'sd2 } // subset 111
        },
        '{ // SSD1
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 001
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 101
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 111
        },
        '{ // SSD2
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 001
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 101
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 111
        },
        '{ // ESD1
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 001
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 101
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 111
        },
        '{ // ESD2_Ext_0
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 001
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 101
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 111
        },
        '{ // ESD2_Ext_1
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 001
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 101
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 111
        },
        '{ // ESD2_Ext_2
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 001
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 101
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 111
        },
        '{ // ESD_Ext_Err
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 001
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 011
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 }, // subset 101
            '{ TA_n: 3'sd0, TB_n: 3'sd0, TC_n: 3'sd0, TD_n: 3'sd0 } // subset 111
        }
    };
endpackage

`endif
