class monitor;
  mailbox mon2scb;
  virtual intf inf;
  function new(mailbox mon2scb, virtual intf inf);
    this.mon2scb=mon2scb;
    this.inf=inf;
  endfunction

  task run();
    bit prev_write;
    bit prev_rdy;
    bit has_pending;
    trans pending_tr;

    prev_write   = 0;
    prev_rdy     = 0;
    has_pending  = 0;

    forever begin
      @(inf.mon_cb);
      if (inf.mon_cb.write && !prev_write) begin
        pending_tr = new();
        pending_tr.wdata = inf.mon_cb.wdata;
        has_pending = 1;
      end
      if (!inf.mon_cb.rdy && prev_rdy && has_pending) begin
        pending_tr.rdy   = 1;
        pending_tr.rdata = inf.mon_cb.rdata;
        $display("[MON] t=%0t write_data=%0h read_data=%0h",
                  $time, pending_tr.wdata, pending_tr.rdata);
        mon2scb.put(pending_tr);
        has_pending = 0;
      end

      prev_write = inf.mon_cb.write;
      prev_rdy   = inf.mon_cb.rdy;
    end
  endtask
endclass
