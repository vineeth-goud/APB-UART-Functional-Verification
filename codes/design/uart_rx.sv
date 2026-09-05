
module UART_RX(
    input clk,
    input rst,
    input rdy_clr,
    input rx_en,
    input rx,
    output reg rdy,
    output  reg [7:0] data_out   
);
  reg [3:0] sample,index;
  reg [7:0] temp;
  reg [1:0] current_state,next_state;
  parameter START=0,DATA_OUT=1,STOP=2;
  
  
  always@(posedge clk or posedge rst) begin
      if(rst) current_state<=START;
      else current_state<=next_state; 
    
  end
  
  
  always@(*) begin
     case(current_state) 
      START: begin
                if(rx_en && rx==0 && sample==15) next_state=DATA_OUT;
                else next_state=START;
             end
      DATA_OUT: begin
                     if(rx_en && index==8 && sample==15) next_state=STOP;
                    else next_state=DATA_OUT;  
               end
      STOP: begin 
                if(rx_en && sample==15) next_state=START;
                else next_state=STOP;
            end
      default: next_state=START;
      endcase
  end
  
  always@(posedge clk or posedge rst) begin
    if(rst) begin
        sample<=0; index<=0;temp<=0;rdy<=0;data_out<=0;
        
    end
    else if(rdy_clr) begin
        rdy<=0;
    end
    else begin
     case(current_state) 
     START: begin
              if(rx_en) begin
                 if(rx==0 || sample!=15) sample<=sample+1;
                 else begin rdy<=0;data_out<=0;sample<=0;index<=0; end  
             end   
         end
     DATA_OUT:begin  rdy<=0;
                    if(rx_en) begin
                           if(sample==8)  begin temp[index]<=rx;   index<=index+1; sample<=sample+1; end
                           else sample<=sample+1;                                      
                     end
              end
      STOP: begin
             
          if(rx_en) begin
              sample<=sample+1;
             if(sample==15) begin
                  rdy<=1;
                 data_out<=temp;
                 sample<=0;
                 index<=0;
             end
          end
              
            end
     default : begin   rdy<=0;
                  data_out<=0;
              end
    endcase
  end
  end
endmodule
