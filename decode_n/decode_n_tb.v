module decode_n_tb ;

parameter n = 4;
parameter m = 1<<n;

    reg     [n-1:0] in;
    wire    [m-1:0] y;

    decode_n #(n,m) u_decode
    (
        .in(in),
        .y(y)
    );

integer i   ;
initial begin
    $display("***********decode test*****************");
    i = 0;
    in = 0;

    for(i = 0; i< 2**n ; i = i + 1) begin
    #1;
        in = i;
    #1;
        $display("in is %b,out is %b",in,y);
    end
end

    initial begin
        $dumpfile("decode_n_tb.vcd");
        $dumpvars(0, decode_n_tb);    //tb模块名称
    end

endmodule