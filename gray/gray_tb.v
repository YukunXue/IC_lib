`timescale 1 ns/ 1 ns
module gray_tb();
reg clk;
reg rst_n;
                                            
wire [3:0]  data;
                        
gray u_gray (   
	.clk(clk),
	.rst_n(rst_n),
    .data(data)
);
initial 
begin 
	rst_n = 0;
	clk = 0;
	#5 rst_n = 1;
	#110 $stop;
end

always #5 clk = ~clk;

initial begin
    $dumpfile("gray_tb.vcd");
    $dumpvars(0, gray_tb);    //tb模块名称
end

initial $monitor($time,"-> \t now state of gray_data is : %b",data);
endmodule
