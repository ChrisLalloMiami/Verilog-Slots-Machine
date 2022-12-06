module seven_segment_negative(i,o);

input i;
output reg [6:0]o; // a, b, c, d, e, f, g

always @(*)
begin
	if (i == 1'b1)
		o = 7'b1111110;
	else
		o = 7'b1111111;

end
endmodule 