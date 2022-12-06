module seven_segment (
input [3:0]i,
output reg [6:0]o
);


// HEX out - rewire DE2
//  ---a---
// |       |
// f       b
// |       |
//  ---g---
// |       |
// e       c
// |       |
//  ---d---

always @(*)
begin
	case (i)	    // abcdefg
		4'd0 : o = 7'b0000001;
		4'd1 : o = 7'b1001111;
		4'd2 : o = 7'b0010010;
		4'd3 : o = 7'b0000110;
		4'd4 : o = 7'b1001100;
		4'd5 : o = 7'b0100100;
		4'd6 : o = 7'b0100000;
		4'd7 : o = 7'b0001111;
		4'd8 : o = 7'b0000000;
		4'd9 : o = 7'b0000100;
		4'd10 : o = 7'b0001000;
		4'd11 : o = 7'b1100000;
		4'd12 : o = 7'b0110001;
		4'd13 : o = 7'b1000010;
		4'd14 : o = 7'b0110000;
		4'd15 : o = 7'b0111000;
		
	endcase
end

endmodule