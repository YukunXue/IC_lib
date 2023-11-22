module trans(
    input                   clk_w,
    input                   reset_n,
    input                   overflow,           

    input           [7:0]    data_i,
    output  wire    [7:0]    data_w,
    output  wire             wr_en
);

reg [7:0] data_buff;
reg       flag;

always@(posedge clk_w or negedge reset_n)begin
    if(!reset_n)begin
        data_buff  <= 8'd0;
        flag   <= 1'd0;
    end
    else begin
        if((overflow == 1) && (data_i == 8'd0))begin
            data_buff  <=  data_buff;
            flag   <=  1'd0; 
        end
        else    begin
            data_buff  <=  data_i;
            flag       <=  1'd1;   
        end
    end
end

assign  data_w  =   data_buff;
assign  wr_en   =   flag;

endmodule