module asyncfifo_64x8 (
    
    //reset signal
    input   wire        reset_n,

    //write interface
    input   wire        clk_w,
    input   wire        wr_en,
    input   wire  [7:0] data_w,

    //read interface
    input   wire         clk_r,
    input   wire         rd_en,
    output  wire   [7:0] data_r,

    //flag signal
    output  wire        overflow,
    output  wire        underflow

);
    //memory
    reg     [7:0]   regs_array  [63:0];

    //memory addr
    wire    [5:0]   wr_addr;
    wire    [5:0]   rd_addr;

    //write pointer of gray
    reg     [6:0]   wr_ptr;
    wire    [6:0]   gray_wr_ptr;
    reg     [6:0]   gray_wr_ptr_d1;
    reg     [6:0]   gray_wr_ptr_d2;
    wire    [6:0]   wr_ptr_bin;

    //read pointer of gray
    reg     [6:0]   rd_ptr;
    wire    [6:0]   gray_rd_ptr;
    reg     [6:0]   gray_rd_ptr_d1;
    reg     [6:0]   gray_rd_ptr_d2;
    wire    [6:0]   rd_ptr_bin;   

	wire 	full_o;
	wire	empty_o;

/*-----------------------------------------------\
 --         write addr and read addr          --
\-----------------------------------------------*/
assign wr_addr = wr_ptr[5:0];
assign rd_addr = rd_ptr[5:0];


/*---------------------------------------\
----      write ptr and bin ->gray ------
\---------------------------------------*/
always @(posedge clk_w or negedge reset_n) begin
    if(!reset_n)begin
        wr_ptr  <=  7'd0;
    end
    else if (wr_en && !full_o)begin
        wr_ptr  <=  wr_ptr +1'b1;
        regs_array[wr_addr] <= data_w;
    end
end

assign  gray_wr_ptr =   wr_ptr ^ (wr_ptr >> 1'b1);

/*-----------------------------------------------\
 --         read ptr and bin->gray      --
\-----------------------------------------------*/
always @ (posedge clk_r or negedge reset_n) begin
  if (!reset_n) begin
    rd_ptr <= 7'b0;
  end
  else if (rd_en && !empty_o) begin
    rd_ptr <= rd_ptr + 1'b1;
  end
end

assign data_r      = regs_array[rd_addr]; 

assign gray_rd_ptr = rd_ptr ^ (rd_ptr >> 1'b1);

/*-----------------------------------------------\
 --              gray_wr_ptr sync             --
\-----------------------------------------------*/
always @ (posedge clk_r or negedge reset_n) begin
  if (!reset_n) begin
    gray_wr_ptr_d1 <= 7'd0;
    gray_wr_ptr_d2 <= 7'd0;
  end
  else begin
    gray_wr_ptr_d1 <= gray_wr_ptr   ;
    gray_wr_ptr_d2 <= gray_wr_ptr_d1;
  end
end

/*-----------------------------------------------\
 --              gray_rd_prt sync             --
\-----------------------------------------------*/
always @ (posedge clk_w or negedge reset_n) begin
  if (!reset_n) begin
    gray_rd_ptr_d1 <= 7'd0;
    gray_rd_ptr_d2 <= 7'd0;
  end
  else begin
    gray_rd_ptr_d1 <= gray_rd_ptr   ;
    gray_rd_ptr_d2 <= gray_rd_ptr_d1;
  end
end

/*-----------------------------------------------\
 --         full flag and empty flag           --
\-----------------------------------------------*/
assign full_o  = (gray_wr_ptr == {~(gray_rd_ptr_d2[7:6]),gray_rd_ptr_d2[5:0]})? 1'b1 : 1'b0;
assign empty_o = (gray_rd_ptr == gray_wr_ptr_d2)? 1'b1 : 1'b0;




/*-----------------------------------------------\
 --             gray -->bin             --
\-----------------------------------------------*/
assign  rd_ptr_bin  = gray_rd_ptr_d2 ^  (gray_rd_ptr_d2>>1);
assign  wr_ptr_bin  = gray_wr_ptr_d2 ^  (gray_wr_ptr_d2>>1);

wire    [6:0]  dis_r;
wire    [6:0]  dis_w;
//由于overflows是在写时钟域发生的
assign  dis_w  = wr_addr - rd_ptr_bin[5:0];
assign  dis_r  = rd_addr - wr_ptr_bin[5:0];
assign  overflow  = (dis_w[6])?(dis_w[5:4] == 2'b00):(dis_w[5:4] == 2'b11);
assign  underflow = (dis_r[6])?(dis_w[5:4] == 2'b11):(dis_w[5:4] == 2'b00);


endmodule