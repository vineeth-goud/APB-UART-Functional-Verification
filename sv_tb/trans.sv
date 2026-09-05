class trans;
   rand bit PRESETn;
  rand bit [`DATA_W-1:0] wdata;
        bit transfer;
        bit write;
        bit  [`ADDR_W-1:0] addr;
       bit [`DATA_W-1:0] rdata;
        bit rdy;
  constraint c1{
    wdata inside {[0:255]};
  }
endclass
