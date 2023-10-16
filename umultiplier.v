/*
# verilog_umult
Simple unsigned multiplier in verilog based on [this link](https://en.wikipedia.org/wiki/Binary_multiplier) in the section: "Binary long multiplication"

Pretty straightforward, just remember to press start and input at same time, then release the start
*/

// Code your design here
// unsigned binary multiplier Z = A*B
module umultiplier #(parameter WIDTH=4) (
  input [WIDTH-1:0]A,
  input [WIDTH-1:0]B,
  input clk,
  input start,
  output [2*WIDTH-1:0]Z,
  output valid_out,
  output busy_out,
  output [2*WIDTH-1:0]inter_out,
  output [WIDTH-1:0]i_out,
  output [WIDTH-1:0]A1_out,
  output [WIDTH-1:0]B1_out,
  output mult_out
);
  
  reg [WIDTH-1:0] i;//counter
  reg valid;
  reg busy;
  
  reg [2*WIDTH-1:0] inter;//intermediate multiplication put here
  reg [2*WIDTH-1:0] accum;//accumulated addition
  reg mult;//bit of B used to multiply A
  reg [WIDTH-1:0]B1; //copy of B
  reg [WIDTH-1:0]A1; //copy of B
  
  assign valid_out = valid;
  assign busy_out = busy;
  assign Z = accum;
  assign inter_out = inter;
  assign i_out = i;
  assign A1_out=A1;
  assign B1_out=B1;
  assign mult_out=mult;
  
  always @(*)begin
    if(mult==1'b1)begin
      inter=A1;
    end
    else if (mult==1'b0) begin
      inter=0;
    end
  end
  
  always @(posedge clk)begin
    if(start)begin
      i<=0;
      valid<=0;
      busy<=1;
      accum<=0;
      inter<=0;
      A1<=A;
      B1<=B;
    end
    else if(busy)begin
      if (i > WIDTH) begin  // we're done
        valid<=1;
        busy<=0;
        i<=0;
      end 
      else begin
        mult<=B1[0];
      	B1<=B1>>1;
        accum<=accum+(inter<<i-1);//multiplication starts at i=1, so i=0 is loading
      	i<=i+1;
      end
    end  
  end
    
endmodule
