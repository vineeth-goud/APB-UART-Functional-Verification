class env;
  virtual intf inf;
  trans tr;
  rst_check rc; 
  write_read wr;
  driver drv;
  monitor mon;
  scoreboard scb;
  mailbox gen2drv;
  mailbox mon2scb;
  bit test_case;
  function new(virtual intf inf);
    this.inf=inf;
    tr=new();
    gen2drv=new();
    mon2scb=new();
    rc=new(gen2drv);
    wr=new(gen2drv);
    drv=new(gen2drv,inf);
    mon=new(mon2scb,inf);
    scb=new(mon2scb);
  endfunction
  task run();
    fork
    
      drv.run();
      mon.run();
      scb.run();
    join_none
    // Choose which generator to run
    case (test_case)
            0: rc.run();
            1: wr.run();
            default: $display("[ENV] Invalid testcase_select value");
        endcase
  endtask
endclass
