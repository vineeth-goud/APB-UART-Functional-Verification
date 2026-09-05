interface intf(input logic PCLK);
  logic PRESETn;
  logic transfer;
  logic write;
  logic [`ADDR_W-1:0] addr;
  logic [`DATA_W-1:0] wdata;
  logic [`DATA_W-1:0] rdata;
  logic rdy;
  
 
  clocking drv_cb@(posedge PCLK);
    default input #1  output #0;
    input rdata,rdy;
    output PRESETn,transfer,write,addr,wdata;
  endclocking
  clocking mon_cb@(posedge PCLK);
    default input #1  output #0;
    input rdata,rdy;
    input PRESETn,transfer,write,addr,wdata;
  endclocking
endinterface
