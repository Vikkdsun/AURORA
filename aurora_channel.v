`timescale 1ns/1ps

module aurora_channel(
    input                   i_init_clk              ,
    input                   i_rst                   ,
    input                   i_gt_refclk             ,

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

    input [8 : 0]           i_drpaddr_in            ,
    input                   i_drpen_in              ,
    input [15 : 0]          i_drpdi_in              ,
    output                  o_drprdy_out            ,
    output [15 : 0]         o_drpdo_out             ,
    input                   i_drpwe_in              ,

    input                   i_powerdown             ,

    input                   i_gt0_qplllock          ,
    input                   i_gt0_qpllrefclklost    ,
    output                  o_gt0_qpllreset         ,
    input                   i_gt_qpllclk_quad1      ,
    input                   i_gt_qpllrefclk_quad1   ,

    output                  o_user_clk              ,
    output                  o_sys_rst               
);

wire                        w_tx_out_clk            ;
wire                        w_tx_lock               ;
wire                        w_user_clk              ;
wire                        w_sync_clk              ;
wire                        w_pll_not_locked        ;
wire                        w_reset                 ;
wire                        w_gt_reset              ;
assign                      o_user_clk = w_user_clk ;


AURORA_8B10B_CLOCK_MODULE AURORA_8B10B_CLOCK_MODULE_u
(
    .GT_CLK                 (w_tx_out_clk           ),
    .GT_CLK_LOCKED          (w_tx_lock              ),
    .USER_CLK               (w_user_clk             ),
    .SYNC_CLK               (w_sync_clk             ),
    .PLL_NOT_LOCKED         (w_pll_not_locked       )
);

AURORA_8B10B_SUPPORT_RESET_LOGIC AURORA_8B10B_SUPPORT_RESET_LOGIC_u
(
    .RESET                  (i_rst                  ),
    .USER_CLK               (w_user_clk             ), 
    .INIT_CLK_IN            (i_init_clk             ),
    .GT_RESET_IN            (i_rst                  ),
    .SYSTEM_RESET           (w_reset                ),
    .GT_RESET_OUT           (w_gt_reset             )
);

AURORA_8B10B AURORA_8B10B_u (
  .s_axi_tx_tdata           (s_axi_tx_tdata         ),                  // input wire [0 : 31] s_axi_tx_tdata
  .s_axi_tx_tkeep           (s_axi_tx_tkeep         ),                  // input wire [0 : 3] s_axi_tx_tkeep
  .s_axi_tx_tlast           (s_axi_tx_tlast         ),                  // input wire s_axi_tx_tlast
  .s_axi_tx_tvalid          (s_axi_tx_tvalid        ),                  // input wire s_axi_tx_tvalid
  .s_axi_tx_tready          (s_axi_tx_tready        ),                  // output wire s_axi_tx_tready
  .m_axi_rx_tdata           (m_axi_rx_tdata         ),                  // output wire [0 : 31] m_axi_rx_tdata
  .m_axi_rx_tkeep           (m_axi_rx_tkeep         ),                  // output wire [0 : 3] m_axi_rx_tkeep
  .m_axi_rx_tlast           (m_axi_rx_tlast         ),                  // output wire m_axi_rx_tlast
  .m_axi_rx_tvalid          (m_axi_rx_tvalid        ),                // output wire m_axi_rx_tvalid
  .hard_err                 (o_hard_err             ),                              // output wire hard_err
  .soft_err                 (o_soft_err             ),                              // output wire soft_err
  .frame_err                (o_frame_err            ),                              // output wire frame_err
  .channel_up               (o_channel_up           ),                                 // output wire channel_up
  .lane_up                  (o_lane_up              ),                                 // output wire [0 : 0] lane_up
  .txp                      (o_txp                  ),                                        // output wire [0 : 0] txp
  .txn                      (o_txn                  ),                                        // output wire [0 : 0] txn

  .reset                    (w_reset                ),                                    // input wire reset
  .gt_reset                 (w_gt_reset             ),                              // input wire gt_reset

  .loopback                 (i_loopback             ),                              // input wire [2 : 0] loopback
  .rxp                      (i_rxp                  ),                                        // input wire [0 : 0] rxp
  .rxn                      (i_rxn                  ),                                        // input wire [0 : 0] rxn
  .drpclk_in                (i_init_clk             ),                                 // input wire drpclk_in
  .drpaddr_in               (i_drpaddr_in           ),                                 // input wire [8 : 0] drpaddr_in
  .drpen_in                 (i_drpen_in             ),                                 // input wire drpen_in
  .drpdi_in                 (i_drpdi_in             ),                                 // input wire [15 : 0] drpdi_in
  .drprdy_out               (o_drprdy_out           ),                                 // output wire drprdy_out
  .drpdo_out                (o_drpdo_out            ),                                 // output wire [15 : 0] drpdo_out
  .drpwe_in                 (i_drpwe_in             ),                                 // input wire drpwe_in
  .power_down               (i_powerdown            ),                          // input wire power_down
  .tx_lock                  (w_tx_lock              ),                                // output wire tx_lock
  .tx_resetdone_out         (),              // output wire tx_resetdone_out
  .rx_resetdone_out         (),              // output wire rx_resetdone_out
  .link_reset_out           (),                  // output wire link_reset_out

  .gt0_qplllock_in          (i_gt0_qplllock         ),                 // input wire gt0_qplllock_in
  .gt0_qpllrefclklost_in    (i_gt0_qpllrefclklost   ),                 // input wire gt0_qpllrefclklost_in
  .gt0_qpllreset_out        (o_gt0_qpllreset        ),                 // output wire gt0_qpllreset_out
  .gt_qpllclk_quad1_in      (i_gt_qpllclk_quad1     ),                 // input wire gt_qpllclk_quad1_in
  .gt_qpllrefclk_quad1_in   (i_gt_qpllrefclk_quad1  ),                 // input wire gt_qpllrefclk_quad1_in

  .init_clk_in              (i_init_clk             ),                        // input wire init_clk_in
  .pll_not_locked           (w_pll_not_locked       ),                  // input wire pll_not_locked
  .tx_out_clk               (w_tx_out_clk           ),                          // output wire tx_out_clk
  .sys_reset_out            (o_sys_rst              ),                    // output wire sys_reset_out
  .user_clk                 (w_user_clk             ),                              // input wire user_clk
  .sync_clk                 (w_sync_clk             ),                              // input wire sync_clk
  .gt_refclk1               (i_gt_refclk            )                          // input wire gt_refclk1
);


endmodule
