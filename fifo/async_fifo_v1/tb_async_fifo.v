
module async_fifo_tb;
  reg           reset_n ;
  
  reg           clk_w ;
  reg           wr_en ;
  reg [7:0]     data_w;
  
  reg           clk_r ;
  reg           rd_en ;
  reg [7:0]     data_r;

//  reg           overflow   ;
//  reg           underflow  ;
  reg           empty ;
  reg           full ;

  initial begin                    //设置写时钟，写周期是20ns，50Mhz
                    clk_w=0;
                    forever    #2     clk_w=~clk_w;
            end
            
  initial begin                    //设置读时钟，读周期是10ns，100Mhz
                    clk_r=0;
                    forever    #5      clk_r=~clk_r;
          end
  
  always #2   data_w  =  {$random}%8'd15;   

initial begin
    reset_n = 1'b0;
    wr_en   = 1'b0;
    rd_en   = 1'b0;
#10 reset_n = 1'b1;
    wr_en   = 1'b1;
    //rd_en   = 1'b1;
    #1000 $finish;

end

asyncfifo_64x8 u_fifo(
    .reset_n(reset_n),

    .clk_w(clk_w),
    .wr_en(wr_en),
    .data_w(data_w),

    //read interface
    .clk_r(clk_r),
    .rd_en(rd_en),
    .data_r(data_r),

    //flag signal
    .overflow(full),
    .underflow(empty)

);

initial begin
    $dumpfile("async_fifo_tb.vcd");
    $dumpvars(0, async_fifo_tb);    //tb模块名称
end
endmodule
