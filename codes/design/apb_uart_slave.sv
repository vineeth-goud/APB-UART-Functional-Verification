module APB_UART_SLAVE #(parameter addr_w=32,data_w=32)(
    input PCLK,
    input PRESETn,
    input PSEL,
    input PENABLE,
    input PWRITE,
    input [addr_w-1:0] PADDR,
    input [data_w-1:0] PWDATA,
    output reg [data_w-1:0] PRDATA,
    output PREADY,
    output PSLVERR,
    output wr_en,
    output [7:0] tx_data,
    input busy,
    input rdy,
    input [7:0] rx_data,
    output rdy_clr
);
    assign PREADY  = 1'b1;
    assign PSLVERR = 1'b0;

    wire apb_write = PSEL && PENABLE && PWRITE;
    wire apb_read  = PSEL && PENABLE && !PWRITE;

    assign wr_en   = apb_write && (PADDR==32'h0);
    assign tx_data = PWDATA[7:0];
    assign rdy_clr = apb_read  && (PADDR==32'h4);

    always@(*) begin
        case(PADDR)
            32'h4:   PRDATA = {24'b0, rx_data};
            32'h8:   PRDATA = {30'b0, rdy, busy};
            default: PRDATA = 32'b0;
        endcase
    end
endmodule
