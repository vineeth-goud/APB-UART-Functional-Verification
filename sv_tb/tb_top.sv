`timescale 1ns/1ps
`include "package.sv"
module tb;
  bit PCLK;
  test t;
  
  intf inf(PCLK);
  
  APB_UART_TOP dut ( .PCLK(inf.PCLK), .PRESETn(inf.PRESETn),.transfer(inf.transfer),. write(inf.write), .addr(inf.addr), .wdata(inf.wdata), .rdata(inf.rdata), .rdy(inf.rdy));
  
  initial forever #5 PCLK=~PCLK;
  initial begin
    t=new(inf);
    t.run();
  end
  initial begin
    #20_000_000;
    $finish;
  end
endmodule
