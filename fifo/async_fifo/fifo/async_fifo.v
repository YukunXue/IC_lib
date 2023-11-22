//异步FIFO
module	async_fifo
#(
	parameter   DATA_WIDTH = 'd8  ,								//FIFO位宽
  parameter   DATA_DEPTH = 'd64 								//FIFO深度
)		
(		
//写数据		
	input							wr_clk		,				//写时钟
	input							wr_rst_n	,       		//低电平有效的写复位信号
	input							wr_en		,       		//写使能信号，高电平有效	
	input	[DATA_WIDTH-1:0]		data_in		,       		//写入的数据
//读数据			
	input							rd_clk		,				//读时钟
	input							rd_rst_n	,       		//低电平有效的读复位信号
	input							rd_en		,				//读使能信号，高电平有效						                                        
	output	reg	[DATA_WIDTH-1:0]	data_out	,				//输出的数据
//状态标志					
  output              overflow,
  output              underflow
);                                                              
 
//reg define
//用二维数组实现RAM
reg [DATA_WIDTH - 1 : 0]			fifo_buffer[DATA_DEPTH - 1 : 0];
	
reg [$clog2(DATA_DEPTH) : 0]		wr_ptr;						
reg [$clog2(DATA_DEPTH) : 0]		rd_ptr;						
reg	[$clog2(DATA_DEPTH) : 0]		rd_ptr_g_d1;				
reg	[$clog2(DATA_DEPTH) : 0]		rd_ptr_g_d2;				
reg	[$clog2(DATA_DEPTH) : 0]		wr_ptr_g_d1;				
reg	[$clog2(DATA_DEPTH) : 0]		wr_ptr_g_d2;				
	
//wire define
wire [$clog2(DATA_DEPTH) : 0]		wr_ptr_g;					
wire [$clog2(DATA_DEPTH) : 0]		rd_ptr_g;					
wire [$clog2(DATA_DEPTH) - 1 : 0]	wr_ptr_true;				
wire [$clog2(DATA_DEPTH) - 1 : 0]	rd_ptr_true;				
 

wire  full;
wire  empty;

assign 	wr_ptr_g = wr_ptr ^ (wr_ptr >> 1);					
assign 	rd_ptr_g = rd_ptr ^ (rd_ptr >> 1);

assign	wr_ptr_true = wr_ptr [$clog2(DATA_DEPTH) - 1 : 0];		
assign	rd_ptr_true = rd_ptr [$clog2(DATA_DEPTH) - 1 : 0];		
 
 

always @ (posedge wr_clk or negedge wr_rst_n) begin
	if (!wr_rst_n)
		wr_ptr <= 0;
	else if (!full && wr_en)begin								
		wr_ptr <= wr_ptr + 1'd1;
		fifo_buffer[wr_ptr_true] <= data_in;
	end	
end

always @ (posedge wr_clk or negedge wr_rst_n) begin
	if (!wr_rst_n)begin
		rd_ptr_g_d1 <= 0;										
		rd_ptr_g_d2 <= 0;										
	end				
	else begin												
		rd_ptr_g_d1 <= rd_ptr_g;								
		rd_ptr_g_d2 <= rd_ptr_g_d1;								
	end	
end
 
//读操作,更新读地址
always @ (posedge rd_clk or negedge rd_rst_n) begin
	if (!rd_rst_n)
		rd_ptr <= 'd0;
	else if (rd_en && !empty)begin								//读使能有效且非空
		data_out <= fifo_buffer[rd_ptr_true];
		rd_ptr <= rd_ptr + 1'd1;
	end
end
//将写指针的格雷码同步到读时钟域，来判断是否读空
always @ (posedge rd_clk or negedge rd_rst_n) begin
	if (!rd_rst_n)begin
		wr_ptr_g_d1 <= 0;										//寄存1拍
		wr_ptr_g_d2 <= 0;										//寄存2拍
	end				
	else begin												
		wr_ptr_g_d1 <= wr_ptr_g;								//寄存1拍
		wr_ptr_g_d2 <= wr_ptr_g_d1;								//寄存2拍		
	end	
end
 

assign	empty = ( wr_ptr_g_d2 == rd_ptr_g ) ? 1'b1 : 1'b0;
 

assign	full  = ( wr_ptr_g == { ~(rd_ptr_g_d2[$clog2(DATA_DEPTH) : $clog2(DATA_DEPTH) - 1])
				,rd_ptr_g_d2[$clog2(DATA_DEPTH) - 2 : 0]})? 1'b1 : 1'b0;


wire  [$clog2(DATA_DEPTH) : 0] rd_ptr_bin;
wire  [$clog2(DATA_DEPTH) : 0] wr_ptr_bin;

// gray -> bin
assign rd_ptr_bin[$clog2(DATA_DEPTH)] = rd_ptr_g_d2[$clog2(DATA_DEPTH)];
assign rd_ptr_bin[$clog2(DATA_DEPTH)-1:0] = rd_ptr_bin[$clog2(DATA_DEPTH):1] ^ rd_ptr_g_d2[$clog2(DATA_DEPTH)-1:0];

assign wr_ptr_bin[$clog2(DATA_DEPTH)] = wr_ptr_g_d2[$clog2(DATA_DEPTH)];
assign wr_ptr_bin[$clog2(DATA_DEPTH)-1:0] = wr_ptr_bin[$clog2(DATA_DEPTH):1] ^ wr_ptr_g_d2[$clog2(DATA_DEPTH)-1:0];


wire   [6:0]  dis_r;
wire   [6:0]  dis_w;
wire   [6:0]  dis_r_yuan;
wire   [6:0]  dis_w_yuan;
//由于overflows是在写时钟域发生的
assign  dis_w  = wr_ptr_true - rd_ptr_bin[5:0];
assign  dis_r  = wr_ptr_bin[5:0] - rd_ptr_true;
assign  dis_w_yuan = ~dis_w + 1'b1;
assign  dis_r_yuan = ~dis_r + 1'b1;
assign  overflow  = (dis_w[6] || full)?(dis_w_yuan[5:4] == 2'b00):(dis_w[5:4] == 2'b11);
assign  underflow = (dis_r[6])?(dis_r_yuan[5:4] == 2'b11):(dis_r[5:4] == 2'b00);


endmodule