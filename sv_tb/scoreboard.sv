class scoreboard;
  trans act_tr;
  trans exp_tr;
  mailbox mon2scb;
  function new(mailbox mon2scb);
    this.mon2scb=mon2scb;
  endfunction

  task run();
    forever begin
      mon2scb.get(act_tr);
      exp_tr = new();
      exp_tr.wdata = act_tr.wdata;
      compare(act_tr, exp_tr);
    end
  endtask

  task compare(trans act_tr, trans exp_tr);
    if (act_tr.rdata == exp_tr.wdata) begin
      $display("pass : wrote %0h, read back %0h", exp_tr.wdata, act_tr.rdata);
    end
    else begin
      $display("fail : wrote %0h, read back %0h", exp_tr.wdata, act_tr.rdata);
    end
  endtask
endclass
