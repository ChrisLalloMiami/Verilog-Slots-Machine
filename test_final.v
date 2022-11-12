module test_final(clk, rst, button, VGA_CLK, VGA_VS, VGA_HS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B, light1, light2, light3);
	input clk;
	input rst;
	input [1:0] button;


	output VGA_CLK;
	output VGA_HS;
	output VGA_VS;
	output VGA_BLANK_N;
	output VGA_SYNC_N;
	output [9:0] VGA_R;
	output [9:0] VGA_G;
	output [9:0] VGA_B;
	output reg light1;
	output reg light2;
	output reg light3;

	// Found VGA on the internet (Credited in citation)
	vga_adapter VGA(
	  .resetn(1'b1),
	  .clock(clk),
	  .colour(colour),
	  .x(x),
	  .y(y),
	  .plot(1'b1),
	  .VGA_R(VGA_R),
	  .VGA_G(VGA_G),
	  .VGA_B(VGA_B),
	  .VGA_HS(VGA_HS),
	  .VGA_VS(VGA_VS),
	  .VGA_BLANK(VGA_BLANK_N),
	  .VGA_SYNC(VGA_SYNC_N),
	  .VGA_CLK(VGA_CLK));
	defparam VGA.RESOLUTION = "160x120";
	defparam VGA.MONOCHROME = "FALSE";
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	defparam VGA.BACKGROUND_IMAGE = "background.mif";
	
	clock(.clock(clk), .clk(frame));
	
	reg [5:0]S;
	reg [5:0]NS;
	reg [17:0]draw;
	reg done;
	reg fill_done;
	
	reg [19:0]line_len;
	reg [19:0]line_dip;
	
	parameter VERTICAL_LEN = 20'd40,
				 HORIZONTAL_LEN = 20'd20,
				 BORDER_COLOR = 3'b101,
				 FILL_COLOR = 3'b111,
				 INIT_X = 20'd50,
				 INIT_Y = 20'd25;
	
	
	reg [7:0]x;
	reg [7:0]y;
	reg [2:0]colour;
	wire frame;

	
	parameter START = 4'd0,
				 init_left_border = 4'd1,
				 init_top_border = 4'd2,
				 init_right_border = 4'd3,
				 init_bottom_border = 4'd4,
				 init_midleft_border = 4'd5,
				 init_midright_border = 4'd6,
				 init_left_slot = 4'd7,
				 init_mid_slot = 4'd8,
				 init_right_slot = 4'd9,
				 END = 4'd10;
	
	always @(posedge clk or negedge rst)
		if (rst == 1'b0)
			S <= START;
		else if (done == 1'b1)
			S <= NS;
			
	always @(*)
		case (S)
			START : NS = init_left_border;
			init_left_border : NS = init_top_border;
			init_top_border : NS = init_midleft_border;
			init_midleft_border : NS = init_midright_border;
			init_midright_border : NS = init_right_border;
			init_right_border : NS = init_bottom_border;
			init_bottom_border : NS = init_left_slot;
			init_left_slot : NS = init_mid_slot;
			init_mid_slot : NS = init_right_slot;
			init_right_slot : NS = END;
			END : NS = END;
			
		endcase
			
			
	always @(posedge clk or negedge rst)
		if (rst == 1'b0)
		begin
			done <= 1'b0;
			fill_done <= 1'b0;
			colour <= 3'b000; // Background color
			x <= 8'b00000000;
			y <= 8'b00000000;
			draw <= 18'b0;
			line_len <= 20'd0;
			line_dip <= 20'd0;
			light1 <= 1'b0;
			light2 <= 1'b0;
			light3 <= 1'b0;
		end
		else
			case (S)
				START :
					if (draw < 17'b10000000000000000)
					begin
						done <= 1'b0;
						x <= draw[7:0];
						y <= draw[16:8];
						draw <= draw + 1'b1;
						colour <= 3'b010;
						light1 <= 1'b1;
					end
					else
					begin
						done <= 1'b1;
						draw <= 17'b0;
					end
				init_left_border :
					if (line_len < VERTICAL_LEN)
					begin
						done <= 1'd0;
						colour <= BORDER_COLOR;
						x <= INIT_X;
						y <= INIT_Y + line_len;
						line_len <= line_len + 1'd1;
					end
					else
					begin
						line_len <= 20'd0;
						done <= 1'd1;
					end
				init_top_border :
					if (line_len < 3 * HORIZONTAL_LEN)
					begin
						done <= 1'd0;
						colour <= BORDER_COLOR;
						x <= INIT_X + line_len;
						y <= INIT_Y;
						line_len <= line_len + 1'd1;
					end
					else
					begin
						line_len <= 20'd0;
						done <= 1'd1;
					end
				init_midleft_border :
					if (line_len < VERTICAL_LEN)
					begin
						done <= 1'd0;
						colour <= BORDER_COLOR;
						x <= INIT_X + HORIZONTAL_LEN;
						y <= INIT_Y + line_len;
						line_len <= line_len + 1'd1;
					end
					else
					begin
						line_len <= 20'd0;
						done <= 1'd1;
					end
				init_midright_border :
					if (line_len < VERTICAL_LEN)
					begin
						done <= 1'd0;
						colour <= BORDER_COLOR;
						x <= INIT_X + (2 * HORIZONTAL_LEN);
						y <= INIT_Y + line_len;
						line_len <= line_len + 1'd1;
					end
					else
					begin
						line_len <= 20'd0;
						done <= 1'd1;
					end
				init_right_border :
					if (line_len < VERTICAL_LEN)
					begin
						done <= 1'd0;
						colour <= BORDER_COLOR;
						x <= INIT_X + (3 * HORIZONTAL_LEN);
						y <= INIT_Y + line_len;
						line_len <= line_len + 1'd1;
					end
					else
					begin
						line_len <= 20'd0;
						done <= 1'd1;
					end
				init_bottom_border : 
					if (line_len < 3 * HORIZONTAL_LEN)
					begin
						done <= 1'd0;
						colour <= BORDER_COLOR;
						x <= INIT_X + line_len;
						y <= INIT_Y + VERTICAL_LEN;
						line_len <= line_len + 1'd1;
					end
					else
					begin
						x <= INIT_X + line_len; // Fill missing pixel.
						line_len <= 20'd0;
						done <= 1'd1;
					end
				init_left_slot :
					begin
						begin
							if (line_len < HORIZONTAL_LEN - 1 && fill_done == 1'b0)
							begin
								colour <= FILL_COLOR;
								x <= INIT_X + line_len + 1'd1;
								y <= INIT_Y + line_dip + 1'd1;
								line_len <= line_len + 1'd1;
							end
						end
						begin
							if (line_len >= HORIZONTAL_LEN - 1 && fill_done == 1'b0)
							begin
								line_dip <= line_dip + 1'd1;
								line_len <= 20'd0;
							end
						end
						begin
							if (line_dip >= VERTICAL_LEN - 1)
							begin
								line_dip <= 20'd0;
								line_len <= 20'd0;
								done <= 1'b1;
								fill_done <= 1'b1;
								x <= INIT_X + 1'd1;
								y <= INIT_Y + 1'd1;
							end
						end
					end
				END : done <= 1'b1;
			endcase
	
endmodule 


module clock (input clock, output clk);
	reg [19:0] frame_counter;
	reg frame;

	always@(posedge clock)
	  begin
		 if (frame_counter == 20'b0) begin
			frame_counter = 20'd833332;  // This divisor gives us ~60 frames per second
			frame = 1'b1;
		 end 
		 
		 else 
		 begin
			frame_counter = frame_counter - 1'b1;
			frame = 1'b0;
		 end
	  end

	assign clk = frame;
endmodule
