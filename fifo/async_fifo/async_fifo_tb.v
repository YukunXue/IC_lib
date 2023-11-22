
module async_fifo_tb;
  reg           reset_n ;
  
  reg           clk_w ;
  reg           wr_en ;
  reg [7:0]     data_w;
  
  reg           clk_r ;
  reg           rd_en ;
  reg [7:0]     data_r;

  reg           overflow   ;
  reg           underflow  ;
//  reg           empty ;
//  reg           full ;

  initial begin                    //设置写时钟，
                    clk_w=0;
                    forever    #2     clk_w=~clk_w;
            end
            
  initial begin                    //设置读时钟，
                    clk_r=0;
                    forever    #3      clk_r=~clk_r;
          end
  
  always #2   data_w  =  {$random}%8'd15;   

initial begin
    reset_n = 1'b0;
    wr_en   = 1'b0;
    rd_en   = 1'b0;
#10 reset_n = 1'b1;
    wr_en   = 1'b1;
    rd_en   = 1'b1;
    #1000 $finish;

end

async_fifo u_fifo(
  .wr_clk(clk_w)		,				//写时钟
  .wr_rst_n(reset_n)	,       		//低电平有效的写复位信号
  .wr_en(wr_en)		,       		//写使能信号，高电平有效	
  .data_in(data_w)		,       		//写入的数据
//读数据			
  .rd_clk(clk_r)		,				//读时钟
  .rd_rst_n(reset_n)	,       		//低电平有效的读复位信号
  .rd_en(rd_en)		,				//读使能信号，高电平有效						                                        
  .data_out(data_r)	,				//输出的数据
//状态标志					
  .underflow(underflow)		,				//空标志，高电平表示当前FIFO已被写满
  .overflow(overflow)		    			//满标志，高电平表示当前FIFO已被读空
);

initial begin
    $dumpfile("async_fifo_tb.vcd");
    $dumpvars(0, async_fifo_tb);    //tb模块名称
end
endmodule
