module two_decimal_vals_w_neg (
input [7:0]val,
output [6:0]seg7_neg_sign,
output [6:0]seg7_lsb,
output [6:0]seg7_mid,
output [6:0]seg7_msb
);

reg [3:0] result_one_digit;
reg [3:0] result_ten_digit;
reg [3:0] result_hundreds_digit;
reg result_is_negative;

reg [7:0]twos_comp;



always @(*)
begin
	twos_comp = -8'b1 * val;
	if (val[7] == 1'b1)
	begin
		result_is_negative = 1'b1;
		result_one_digit = twos_comp % 8'd10;
		result_ten_digit = (twos_comp / 8'd10) % 8'd10;
		result_hundreds_digit = twos_comp / 8'd100;
	end
	else
	begin
		result_is_negative = 1'b0;
		result_one_digit = val % 8'd10;
		result_ten_digit = (val / 8'd10) % 8'd10;
		result_hundreds_digit = val / 8'd100;
	end
	
end

/* instantiate the modules for each of the seven seg decoders including the negative one */
seven_segment ones(result_one_digit, seg7_lsb);
seven_segment tens(result_ten_digit, seg7_mid);
seven_segment hundreds(result_hundreds_digit, seg7_msb);
seven_segment_negative negative(result_is_negative, seg7_neg_sign);

endmodule 