module APB_MASTER #(parameter addr_w=32,data_w=32)(
      input PCLK,
      input PRESETn,
      input [data_w-1:0] PRDATA,
      input PSLVERR,
      input PREADY,
      input transfer,
      input write,
      input [addr_w-1:0]addr,
      input [data_w-1:0] wdata,
      output reg PSEL,
      output reg PENABLE,
      output reg  [addr_w-1:0] PADDR,
      output reg PWRITE,
      output reg [data_w-1:0] PWDATA
 );
   parameter IDLE=0,SETUP=1,ACCESS=2;
   reg [1:0] current_state,next_state;
   
   
 always@(posedge PCLK or negedge PRESETn) begin
      if(!PRESETn) begin
          current_state<=IDLE;
          
      end
      else begin
         current_state<=next_state; 
      end
 end
 
 
 always@(*) begin
      case(current_state) 
         IDLE: begin
                  if(transfer)    next_state=SETUP;
                  else    next_state=IDLE;
              end
         SETUP:   next_state=ACCESS;
         ACCESS:  begin  
                        if(PREADY)    begin
                                             if(transfer)    next_state=SETUP;
                                             else   next_state=IDLE;
                                     end
                        else   next_state=ACCESS;
                  end
         default: next_state=IDLE;
        endcase
 end
 
 
always@(posedge PCLK or negedge PRESETn) begin
     if(!PRESETn)  begin
                     PSEL <=1'b0;
                     PENABLE<=1'b0;
     		     PADDR<=0;
      		     PWRITE<=0;
      		     PWDATA<=0;
        end    
    else begin
                   
      	  case(next_state)  
      	         IDLE:  begin  PSEL <=1'b0;
                              PENABLE<=1'b0;
                         end
                 SETUP: begin
                          PSEL <=1'b1;    
                          PENABLE<=1'b0;
     		          PADDR<=addr;
      		          PWRITE<=write;
      		          PWDATA<=wdata;
                    end
                 ACCESS: begin
                          PSEL <=1'b1;    
                          PENABLE<=1'b1;
                 end
                 default: begin
                        PSEL <=1'b0;
                        PENABLE<=1'b0;
     		        PADDR<=0;
      		        PWRITE<=0;
      		        PWDATA<=0; 
                 end
                 endcase
    end
end
 
 endmodule
