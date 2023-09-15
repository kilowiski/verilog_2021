`define clk_period 10
module test #(parameter WIDTH=4);
  reg [WIDTH-1:0] A_IN;
  reg [WIDTH-1:0] B_IN;
  reg clk,rst,en;
  wire [WIDTH-1:0] Q_OUT;
  wire [WIDTH-1:0] R_OUT;
  wire [WIDTH-1:0] A_REG;
  wire [WIDTH-1:0] B_REG;
  wire [2:0] STATE_OUT;
  wire [2:0] NEXT_OUT;
  wire [WIDTH-1:0] COUNT_OUT;
  wire COUNT_MAX;
  
  divisor div0(.A_IN(A_IN),.B_IN(B_IN),.Q_OUT(Q_OUT),.R_OUT(R_OUT),.STATE_OUT(STATE_OUT),.NEXT_OUT(NEXT_OUT),.clk(clk),.rst(rst),.en(en),.A_REG(A_REG),.B_REG(B_REG),. COUNT_OUT(COUNT_OUT),.COUNT_MAX(COUNT_MAX));
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    clk=0;
    rst=1;
    #20
    rst=0;
    A_IN=3;
    B_IN=2;
    #30
    en=1;
    #10
    en=0;
    #70
    A_IN=13;
    B_IN=5;

  end
  
  always
    #(`clk_period/2) clk = ~clk;
endmodule