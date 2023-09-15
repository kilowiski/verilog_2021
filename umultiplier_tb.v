// Code your testbench here
// or browse Examples
`define clk_period 10
module test #(parameter WIDTH=4);
  
  reg[WIDTH-1:0]A;
  reg [WIDTH-1:0]B;
  reg clk;
  reg start;
  wire [2*WIDTH-1:0]Z;
  wire valid_out;
  wire busy_out;
  wire [2*WIDTH-1:0]inter_out;
  wire [WIDTH-1:0]i_out;
  wire [WIDTH-1:0]A1_out;
  wire [WIDTH-1:0]B1_out;
  wire mult_out;
  
  umultiplier mul0(.A(A),.B(B),.clk(clk),.start(start),.Z(Z),.valid_out(valid_out),.busy_out(busy_out)
                  ,.inter_out(inter_out),.i_out(i_out),.A1_out(A1_out),.B1_out(B1_out),.mult_out(mult_out));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    clk=0;
    start=0;
    #17
    start=1;
    A=4;
    B=2;
	#30
    start=0;
    #70
    A=6;
    B=4;
    start=1;
    #20
    start=0;
  end
  always
    #(`clk_period/2) clk = ~clk;
endmodule
