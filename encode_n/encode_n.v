module encode_n # (
        parameter n = 3,
        parameter m = 1<<n
    )(
        input       [m-1:0] in        ,
        output  reg [n-1:0]  y                   
    );


    integer i;
    always @(*) 
    begin:encode
    for (i = m-1; i>0; i=i-1) 
            if(in[i] == 1'b1)
            begin
                y = i;
                disable encode;
            end
            else
                y = 0;
    end



endmodule