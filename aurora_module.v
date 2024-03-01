`timescale 1ns/1ps

module aurora_module(
    input                   i_init_clk              ,
    input                   i_rst                   ,
    input                   i_gt_refclk_p           ,
    input                   i_gt_refclk_n           ,

    input [0 : 31]          s_axi_tx_tdata          ,
    input [0 : 3]           s_axi_tx_tkeep          ,
    input                   s_axi_tx_tlast          ,
    input                   s_axi_tx_tvalid         ,
    output                  s_axi_tx_tready         ,
    output [0 : 31]         m_axi_rx_tdata          ,
    output [0 : 3]          m_axi_rx_tkeep          ,
    output                  m_axi_rx_tlast          ,
    output                  m_axi_rx_tvalid         ,

    output                  o_hard_err              ,
    output                  o_soft_err              ,
    output                  o_frame_err             ,

    output                  o_channel_up            ,
    output                  o_lane_up               ,

    output                  o_txp                   ,
    output                  o_txn                   ,

    input [3:0]             i_loopback              ,

    input                   i_rxp                   ,
    input                   i_rxn                   ,

    input                   i_powerdown             ,

    output                  o_user_clk              ,
    output                  o_sys_rst               
);

wire                        w_gt_refclk             ;
wire                        w_gt0_qplllock          ;
wire                        w_gt0_qpllrefclklost    ;
wire                        w_gt0_qpllreset         ;
wire                        w_gt_qpllclk_quad1      ;
wire                        w_gt_qpllrefclk_quad1   ;

IBUFDS_GTE2 #(
    .CLKCM_CFG      ("TRUE"),   // Refer to Transceiver User Guide
    .CLKRCV_TRST    ("TRUE"), // Refer to Transceiver User Guide
    .CLKSWING_CFG   (2'b11)  // Refer to Transceiver User Guide
)
IBUFDS_GTE2_inst 
(
    .O      (w_gt_refclk    ),         // 1-bit output: Refer to Transceiver User Guide
    .ODIV2  (), // 1-bit output: Refer to Transceiver User Guide
    .CEB    (0),     // 1-bit input: Refer to Transceiver User Guide
    .I      (i_gt_refclk_p  ),         // 1-bit input: Refer to Transceiver User Guide
    .IB     (i_gt_refclk_n  )        // 1-bit input: Refer to Transceiver User Guide
);

AURORA_8B10B_gt_common_wrapper AURORA_8B10B_gt_common_wrapper_u
(
//____________________________COMMON PORTS ,_______________________________{
    .gt_qpllclk_quad1_i         (w_gt_qpllclk_quad1     ),
    .gt_qpllrefclk_quad1_i      (w_gt_qpllrefclk_quad1  ),
//____________________________COMMON PORTS ,_______________________________}
    //-------------------- Common Block  - Ref Clock Ports ---------------------
    .gt0_gtrefclk0_common_in    (w_gt_refclk            ),
    //----------------------- Common Block - QPLL Ports ------------------------
    .gt0_qplllock_out           (w_gt0_qplllock         ),
    .gt0_qplllockdetclk_in      (i_init_clk             ),
    .gt0_qpllrefclklost_out     (w_gt0_qpllrefclklost   ),
    .gt0_qpllreset_in           (w_gt0_qpllreset        )
);


aurora_channel aurora_channel_u(
    .i_init_clk              (i_init_clk            ),
    .i_rst                   (i_rst                 ),
    .i_gt_refclk             (w_gt_refclk           ),

    .s_axi_tx_tdata          (s_axi_tx_tdata        ),
    .s_axi_tx_tkeep          (s_axi_tx_tkeep        ),
    .s_axi_tx_tlast          (s_axi_tx_tlast        ),
    .s_axi_tx_tvalid         (s_axi_tx_tvalid       ),
    .s_axi_tx_tready         (s_axi_tx_tready       ),
    .m_axi_rx_tdata          (m_axi_rx_tdata        ),
    .m_axi_rx_tkeep          (m_axi_rx_tkeep        ),
    .m_axi_rx_tlast          (m_axi_rx_tlast        ),
    .m_axi_rx_tvalid         (m_axi_rx_tvalid       ),

    .o_hard_err              (o_hard_err            ),
    .o_soft_err              (o_soft_err            ),
    .o_frame_err             (o_frame_err           ),

    .o_channel_up            (o_channel_up          ),
    .o_lane_up               (o_lane_up             ),

    .o_txp                   (o_txp                 ),
    .o_txn                   (o_txn                 ),

    .i_loopback              (i_loopback            ),

    .i_rxp                   (i_rxp                 ),
    .i_rxn                   (i_rxn                 ),

    .i_drpaddr_in            (0                     ),
    .i_drpen_in              (0                     ),
    .i_drpdi_in              (0                     ),
    .o_drprdy_out            (                      ),
    .o_drpdo_out             (                      ),
    .i_drpwe_in              (0                     ),

    .i_powerdown             (i_powerdown           ),

    .i_gt0_qplllock          (w_gt0_qplllock        ),
    .i_gt0_qpllrefclklost    (w_gt0_qpllrefclklost  ),
    .o_gt0_qpllreset         (w_gt0_qpllreset       ),
    .i_gt_qpllclk_quad1      (w_gt_qpllclk_quad1    ),
    .i_gt_qpllrefclk_quad1   (w_gt_qpllrefclk_quad1 ),

    .o_user_clk              (o_user_clk            ),
    .o_sys_rst               (o_sys_rst             )
);



























endmodule
