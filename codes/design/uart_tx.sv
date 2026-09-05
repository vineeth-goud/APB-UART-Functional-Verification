module UART_TX(
          input clk,
          input rst,
          input wr_en,
          input tx_en,
          input [7:0] data_in,
          output reg tx,
          output  busy
  );
    reg [2:0] count=0;
    parameter IDLE=0,START=1,DATA=2,STOP=3;
    reg [1:0] current_state,next_state;
    reg [7:0] data;
    
  
    always@(posedge clk or posedge rst) begin
            if(rst)     current_state<=IDLE ;
            else  current_state<=next_state;      
    end
    
    
     always@(*) begin
          case(current_state) 
          IDLE:  if(wr_en)  next_state=START;
                 else       next_state=IDLE;
                 
          START: if(tx_en)  next_state=DATA;
                 else       next_state=START;
                 
         DATA:  if(count==7 && tx_en)   next_state=STOP;
                 else 		        next_state=DATA;
         
         STOP: if(tx_en)      next_state=IDLE;
                else          next_state=STOP;
         default : next_state=IDLE; 
       endcase
     end
  always@(posedge clk or posedge rst) begin
         if(rst)     begin 
                   tx<=1'b1;
                end
        else   begin 
            case(current_state)  
              IDLE:begin
                    tx<=1'b1;
                      if(wr_en) begin
                          data<=data_in; count<=0;
                      end
                  end
              START: if(tx_en) begin tx<=data[0]; count<=1; end
                     else tx<=1'b0;
              DATA:   begin
                       if(tx_en) begin                         
                           if(count==7)  count<=0;
                           else  count<=count+1 ;
                          tx<=data[count];  
                       end
                end
             STOP: if(tx_en) tx<=1'b1;
             endcase
           end
        end
       
  
         
   assign  busy=(current_state!=IDLE)?1'b1:1'b0;
  endmodule

