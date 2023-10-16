/*
This divider is based on [the following link](https://projectf.io/posts/division-in-verilog/). This project is just to give it a personal take on the algorithm shown there.

Basically this project tries to use the 
* next state update
* next state logic
* datapath logic

workflow, or in other words, how i understand digital design.

Kinda bad since its pretty long and the number of cycles can be improved. However, overall the algorithm is solid and works OKAY i guess.
*/


module divisor #(parameter WIDTH=4) (A_IN,B_IN,Q_OUT,R_OUT,STATE_OUT,NEXT_OUT,clk,rst,en,A_REG,B_REG,COUNT_OUT,COUNT_MAX,valid);
  // unsigned A:B = D+R
  input [WIDTH-1:0] A_IN;
  input [WIDTH-1:0] B_IN;
  input clk,rst,en;
  output [WIDTH-1:0] Q_OUT;
  output [WIDTH-1:0] R_OUT;
  output [WIDTH-1:0] A_REG;
  output [WIDTH-1:0] B_REG;
  output [2:0] STATE_OUT;
  output [2:0] NEXT_OUT;
  output [WIDTH-1:0] COUNT_OUT;
  output COUNT_MAX;
  output valid;
  
  reg valid_r;
  reg [WIDTH-1:0] A; // copy of A
  reg [WIDTH-1:0] B; // copy of B
  reg [WIDTH-1:0] Q; // placeholder for D (quotient)
  reg [WIDTH-1:0] R; // placeholder for R (remainder), also serves as accumulator
  
  reg [2:0]	cur_state;
  reg [2:0]	next_state;
  reg [WIDTH-1:0]counter;//iteration counter
  
  assign Q_OUT = Q;
  assign R_OUT = R;
  assign A_REG = A;
  assign B_REG = B;
  assign valid = valid_r;
  assign STATE_OUT = cur_state;
  assign NEXT_OUT = next_state;
  assign COUNT_OUT =counter;
  assign COUNT_MAX = (counter>=WIDTH) ? 1:0;
  localparam IDLE = 3'd0;
  localparam ZERO = 3'd1;
  localparam LOAD = 3'd2;
  localparam DIV = 3'd3;
  localparam FINISH = 3'd4;
  
  //update state
  always @(posedge clk) begin
    if(B_IN==0)
      cur_state<=IDLE;
    else if(rst)
      cur_state<=ZERO;
    else
      cur_state<=next_state;
  end
  
  //next state logic
  always @(*)begin
    case(cur_state)
      IDLE:begin
        if(rst)
          	next_state=ZERO;
      	else if(en)
      		next_state=LOAD;
        else
          	next_state=IDLE;
      end
      
      ZERO:begin
        if(en)
          next_state=LOAD;
        else
          next_state=ZERO;
      end
      
      LOAD:begin
        	next_state=DIV;
      end
      
      DIV:begin
        if(COUNT_MAX)
          next_state=FINISH;
        else
          next_state=DIV;
      end
      
      FINISH:begin
          next_state=IDLE;
      end
      
    endcase
  end
  
  //actual data algorithm
  always @(posedge clk)begin
    
    case(cur_state)
      IDLE:begin
        A<=A;
        B<=B;
        Q<=Q;
        R<=R;
        counter<=1'd0;
        valid_r <=1'd0;
      end
      
      ZERO:begin
        A<=0;
        B<=0;
        Q<=0;
        R<=0;
        valid_r <=1'd0;
      end
      
      LOAD:begin
        A<=A_IN;
        B<=B_IN;
        counter<=1'd0;
      end
      
      DIV:begin
        if((R>=B)& !COUNT_MAX)begin
          R<=R-B;
          Q<= Q + 1'b1;
        end
        else if ((R<B) & !COUNT_MAX) begin
          counter<=counter+1;
          R<={R[WIDTH-2:0],A[WIDTH-1]};
          A<=A<<1;
          Q<=Q<<1;
        end
        
      end
      
      FINISH:begin
        if(R >= B) begin
          	R<=R-B;
          	Q<= Q + 1'b1;
        end
       	else begin
        	Q<=Q;
      		R<=R;
        end
        counter<=1'd0;
        valid_r <= 1;
      end
      
    endcase
  end
  
endmodule
  
  
