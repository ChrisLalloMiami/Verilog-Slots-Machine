module random_number(clk, rst, o);
	input clk, rst;
	output reg [2:0]o;
	reg [31:0]ff;
	
	always @(posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
			ff <= 32'd1;
		else
			ff <= {ff[30:24], ff[2] ^ ff[23] ^ ff[11],
								ff[22:16], ff[14] ^ ff[20] ^ ff[5],
								ff[14:8], ff[13] ^ ff[19] ^ ff[7],
								ff[6:0], ff[26] ^ ff[3] ^ ff[29]};
													
	end
		
		always @(*)
			o = {ff[25], ff[3], ff[19]};
endmodule 