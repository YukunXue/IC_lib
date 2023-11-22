module top_tb ( 
);
    reg             clk_w;
    reg             clk_r;
    reg             reset_n;
    wire   [7:0]    data_o;
    reg    [7:0]    data_i;
    reg             null_flag;    //null产生信号，拉高时，data_i为0x00(null)


    always #1   clk_w = ~clk_w;

    always #2   clk_r = ~clk_r;

    always @(posedge clk_w)begin
        if(null_flag)begin
            data_i  =   8'd0;    
        end
        else begin
            data_i  =  {$random}%8'd15; 
        end
    end

    initial begin
        reset_n     =  1'b0;
        clk_r       =  1'b0;
        clk_w       =  1'b0;
        null_flag   =  1'b0;
        data_i      =  8'd0;
    #10 reset_n     =  1'b1;
    #162 null_flag  =  1'b1;

    #200 null_flag  =  1'b0;      

    #10000 $finish;
    end

    top u_top(
        .data_i (data_i),
        .clk_w  (clk_w),
        .clk_r  (clk_r),
        .reset_n(reset_n),
        .data_o (data_o)
    );

initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);    //tb模块名称
end

endmodule