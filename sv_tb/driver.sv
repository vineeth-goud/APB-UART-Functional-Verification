class driver;
  trans tr;
  mailbox gen2drv;
  virtual intf inf;
  function new(mailbox gen2drv,virtual intf inf);
    this.gen2drv=gen2drv;
    this.inf=inf;
  endfunction

  task run();
    reset_dut();
    forever begin
      gen2drv.get(tr);
      send_to_dut(tr);
      $display("[DRV] t=%0t  wrote=%0h  read=%0h", $time, tr.wdata, tr.rdata);
    end
  endtask

  task reset_dut();
    inf.drv_cb.PRESETn<=0;
    inf.drv_cb.transfer<=0;
    inf.drv_cb.write<=0;
    inf.drv_cb.addr<=32'h0;
    inf.drv_cb.wdata<=32'h0;
    repeat(3) @(inf.drv_cb);
    inf.drv_cb.PRESETn<=1;
    @(inf.drv_cb);
  endtask

  task send_to_dut(trans tr);
    inf.drv_cb.transfer<=0;
    inf.drv_cb.write<=0;
    repeat(3) @(inf.drv_cb);
    if(!tr.PRESETn) begin
      inf.drv_cb.PRESETn<=0;
      inf.drv_cb.transfer<=0;
      inf.drv_cb.write<=0;
      inf.drv_cb.addr<=32'h0;
      inf.drv_cb.wdata<=0;
      @(inf.drv_cb);
    end
    else begin
      inf.drv_cb.PRESETn<=1;
      inf.drv_cb.transfer<=1;
      inf.drv_cb.write<=1;
      inf.drv_cb.addr<=32'h0;
      inf.drv_cb.wdata<=tr.wdata;
      @(inf.drv_cb);
      inf.drv_cb.transfer<=0;
      inf.drv_cb.write<=0;
      repeat(3) @(inf.drv_cb);

      while (inf.drv_cb.rdy)  @(inf.drv_cb);
      while (!inf.drv_cb.rdy) @(inf.drv_cb);

      inf.drv_cb.transfer<=1;
      inf.drv_cb.write<=0;
      inf.drv_cb.addr<=32'h4;
      @(inf.drv_cb);
      inf.drv_cb.transfer<=0;
      @(inf.drv_cb);
      tr.rdata=inf.drv_cb.rdata;
      repeat(3) @(inf.drv_cb);
    end
  endtask
endclass
