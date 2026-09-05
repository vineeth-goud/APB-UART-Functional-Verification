class test;
  virtual intf inf;
  env ev;
  function new(virtual intf inf);
    this.inf=inf;
    ev=new(inf);
  endfunction
  task run();
      ev.test_case=1;
      ev.run();
  endtask
endclass
