// Code your design here
`include  "apb_master.sv"
`include "apb_uart_slave.sv"
`include "uart_top.sv"
module APB_UART_TOP(
    input PCLK,
    input PRESETn,
    input transfer,
    input write,
    input [31:0] addr,
    input [31:0] wdata,
    output [31:0] rdata,
    output rdy
);
    wire PSEL, PENABLE, PWRITE, PREADY, PSLVERR;
    wire [31:0] PADDR, PWDATA, PRDATA;
    wire wr_en, rdy_clr, busy,tx_pin;
    wire [7:0] tx_data, rx_data;

    APB_MASTER #(.addr_w(32), .data_w(32)) u_master(
        .PCLK(PCLK), .PRESETn(PRESETn),
        .PRDATA(PRDATA), .PSLVERR(PSLVERR), .PREADY(PREADY),
        .transfer(transfer), .write(write), .addr(addr), .wdata(wdata),
        .PSEL(PSEL), .PENABLE(PENABLE), .PADDR(PADDR), .PWRITE(PWRITE), .PWDATA(PWDATA)
    );

    APB_UART_SLAVE #(.addr_w(32), .data_w(32)) u_slave(
        .PCLK(PCLK), .PRESETn(PRESETn),
        .PSEL(PSEL), .PENABLE(PENABLE), .PWRITE(PWRITE), .PADDR(PADDR), .PWDATA(PWDATA),
        .PRDATA(PRDATA), .PREADY(PREADY), .PSLVERR(PSLVERR),
        .wr_en(wr_en), .tx_data(tx_data), .busy(busy), .rdy(rdy), .rx_data(rx_data), .rdy_clr(rdy_clr)
    );

    UART_TOP u_uart(
        .clk(PCLK), .rst(!PRESETn),
        .wr_en(wr_en), .data_in(tx_data), .rdy_clr(rdy_clr),
        .tx(tx_pin), .busy(busy), .rdy(rdy), .data_out(rx_data)
    );
  
    assign rdata = PRDATA;
endmodule
