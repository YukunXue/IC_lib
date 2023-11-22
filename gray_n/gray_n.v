module gray_n #(
    parameter N = 4

)(
	input                clk,
	input                rst_n,
	output wire [N-1:0]  gray_code
);

    reg [N-1:0] bin_code;

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n) bin_code <= 0;
        else    bin_code <= bin_code +1'b1;
    end


    assign  gray_code[N-1] = bin_code[N-1];

    generate
        genvar  i;
        for(i = 0; i < N-1; i = i + 1) begin
            assign gray_code[i] = bin_code[i+1] ^ bin_code[i];
        end
    endgenerate


endmodule 
