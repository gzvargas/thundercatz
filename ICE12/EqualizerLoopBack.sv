/****************************************************************
 Module to implement a equilizer feedback loop to test codec_intf.
 Author : ThunderCatz 		HDL : Verilog		 
 Student ID: 903 015 5247	
 Date : 11/09/2015 							
****************************************************************/ 
module EqualizerLoopBack (LRCLK, SCL, MCLK, RSTn, SDin,
						  SDout, RST_n, clk);

////////// Variable Declaration for interface ///////////////////
input RST_n,	// Async reset from pushbutton
	  clk;		// Sytem clock
input SDout;	// Serial data line from CODEC
output LRCLK, 
	   SCL, 
	   MCLK,
	   RSTn, 
	   SDin;	// To CODEC

////////// Intermediate wire Declarations ///////////////////////
wire rst_n;						// The synchronized system reset
wire [15:0] w_lft_in, w_rht_in;	// Audio input channels
wire valid;						// Asserted when aduio outputs valid
wire select;					// Asserted at valid posedge
logic [15:0] lft_out, rht_out;	// Audio output channels

///////////// Initializations of modules ////////////////////////
reset_synch irst_sync   ( .rst_n(rst_n), .RST_n(RST_n), .clk(clk) );
codec_intf  iCODEC_intf ( .lft_in(w_lft_in), .rht_in(w_rht_in),
						  .valid(valid), 
						  .LRCLK(LRCLK), .SCLK(SCL), .MCLK(MCLK),
						  .RSTn(RSTn), .SDin(SDin), .SDout(SDout), 
						  .lft_out(lft_out), .rht_out(rht_out),
						  .clk(clk), .rst_n(rst_n) );
posedgeDetect iedgeDet  ( .sig_posedge(select), .sig(valid), .clk(clk));

///////////// Infer Audio output flops //////////////////////////
always_ff @(posedge clk) begin
	if (select) begin
		lft_out <= w_lft_in;
		rht_out <= w_rht_in;
	end else begin
		lft_out <= lft_out;
		rht_out <= rht_out;
	end		
end

endmodule
