`timescale 1 ns/ 1 ns
module gray_n_tb();
reg clk;
reg rst_n;
                                            

parameter N = 8;

reg     [N-1:0] data;
gray_n #(N) u_gray (
// port map - connection between master ports and signals/registers   
	.clk(clk),
	.rst_n(rst_n),
    .gray_code(data)
);
initial 
begin 
	rst_n = 0;
	clk = 0;
	#5 rst_n = 1;
	#1000 $stop;
end

always #5 clk = ~clk;

initial begin
    $dumpfile("gray_n_tb.vcd");
    $dumpvars(0, gray_n_tb);    //tb模块名称
end

initial $monitor($time,"-> \t now state of gray_data is : %b",data);
endmodule
