
module decode_n #(
    parameter n = 3,
    parameter m = 1 << n
) (
    input   wire [n-1:0] in ,
    output  reg  [m-1:0] y    
);

integer i;
always @(*) begin
    for(i=0;i<m;i=i+1)
        y[i] = in==i;
end

endmodule
