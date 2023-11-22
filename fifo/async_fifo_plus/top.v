module top(
    input   [7:0]   data_i,
    input           clk_w,
    input           clk_r,
    input           reset_n,
    output [7:0]    data_o
);

wire    overflow;
wire    underflow;
wire    [7:0]    data_w;
reg     [7:0]    data_r;
wire    wr_en;
reg     rd_en;

trans u_tran(
    .reset_n (reset_n),
    .clk_w   (clk_w),
    .data_i  (data_i),

    .overflow(overflow),
    .data_w  (data_w),
    .wr_en   (wr_en)
);

async_fifo  u_fifo(
    .wr_clk     (clk_w),				//写时钟
    .wr_rst_n   (reset_n)	,       		//低电平有效的写复位信号
    .wr_en      (wr_en)		,       		//写使能信号，高电平有效	
    .data_in	(data_w)	,       		//写入的数据
//读数据			
    .rd_clk     (clk_r)		,				//读时钟
    .rd_rst_n   (reset_n)	,       		//低电平有效的读复位信号
    .rd_en      (rd_en)		,				//读使能信号，高电平有效						                                        
    .data_out   (data_r)	,				//输出的数据
//状态标志					
    .overflow   (overflow)  ,
    .underflow  (underflow)
);

recv    u_recv(
    .reset_n(reset_n),
    .clk_r  (clk_r),
    .data_o (data_o),

    .underflow(underflow),
    .data_r (data_r),
    .rd_en  (rd_en)
);



endmodule