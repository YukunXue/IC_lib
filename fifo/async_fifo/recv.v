module recv(
    input                   clk_r,
    input                   reset_n,
    input                   underflow,           

    input          [7:0]    data_r,
    output  reg    [7:0]    data_o,
    output  reg             rd_en
);

always@(posedge clk_r or negedge reset_n)begin
    if(!reset_n)begin
        data_o  <= 8'd0;
        rd_en   <= 1'd1;
    end
    else begin
        if(underflow != 1 )begin
        //  data_o  <=  data_r;
            rd_en   <=  1'd1;
        end
        else begin
            data_o  <=  8'd0;
            rd_en   <=  1'd0;  
        end
    end
end

endmodule