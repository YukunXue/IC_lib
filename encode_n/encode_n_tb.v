module encode_n_tb;

parameter n = 4;
parameter m = 1<<n;

    reg     [m-1:0] in;
    wire    [n-1:0] y;

encode_n #(n,m) u_encode(
        .in(in),
        .y(y)
);  

integer i   ;
initial begin
    $display("***********encode test*****************");
    i = 0;
    in = 0;
    #1;
    i = 2**(m-1);
    repeat(m)begin
        in = i;
        i = i>>1;
        #1;
        $display("in is %b,out is %b",in,y);
        #1;
    end
end

initial begin
    $dumpfile("encode_n_tb.vcd");
    $dumpvars(0, encode_n_tb);    //tb模块名称
end

endmodule