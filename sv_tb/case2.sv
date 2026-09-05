class write_read extends  generator;
    mailbox gen2drv;
    trans tr;
  function new(mailbox gen2drv);
    this.gen2drv=gen2drv;
  endfunction
  task run();
    repeat(30) begin
      tr=new();
      if(!tr.randomize() with {tr.PRESETn==1;})
        $display("randomization failed ");
      else begin 
           gen2drv.put(tr);
      end
      
    end
  endtask
endclass
