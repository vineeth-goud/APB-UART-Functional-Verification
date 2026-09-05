class rst_check extends generator;
  mailbox gen2drv;
  trans tr;
  function new(mailbox gen2drv);
    this.gen2drv=gen2drv;
  endfunction
  task run();
    repeat(10) begin
      tr=new();
      if(!tr.randomize() with {tr.PRESETn==0;})
        $display("randomization failed ");
      else begin
           gen2drv.put(tr);
      end
      
    end
  endtask
endclass
