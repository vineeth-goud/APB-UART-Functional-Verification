module Baud_rate_gen(
        input clk,
        input tx_start,
        output reg rx_en,
        output reg tx_en
 );
   reg [12:0] count1=0;
   reg [9:0]  count2=0;
   always@(posedge clk) begin
       if(tx_start) begin
                 count1<=0;
                 tx_en<=1'b0;
           end
       else if(count1==((50000000/9600)-1))  begin
                 count1<=0;  
                 tx_en<=1'b1;
           end
       else  begin
             count1<=count1+1;
             tx_en<=1'b0;
          end
       
         if(count2==((50000000/(16*9600))-1))  begin
                    count2<=0;
                    rx_en<=1'b1;
              end
       else   begin
            count2<=count2+1;
            rx_en<=1'b0;
           end
                
   end
 endmodule
