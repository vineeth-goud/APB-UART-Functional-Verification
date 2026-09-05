`include "baud_rate_gen.sv"
`include "uart_tx.sv"
`include "uart_rx.sv"
module UART_TOP(
    input clk,
    input rst,
    input wr_en,
    input [7:0] data_in,
    input rdy_clr,
    output tx,
    output busy,
    output rdy,
    output [7:0] data_out
);
    wire tx_en, rx_en;
    wire tx_start = wr_en && !busy;

    Baud_rate_gen u_baud (
        .clk(clk),
        .tx_start(tx_start),
        .rx_en(rx_en),
        .tx_en(tx_en)
    );

    UART_TX u_tx (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .tx_en(tx_en),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    UART_RX u_rx (
        .clk(clk),
        .rst(rst),
        .rdy_clr(rdy_clr),
        .rx_en(rx_en),
        .rx(tx),
        .rdy(rdy),
        .data_out(data_out)
    );
endmodule


