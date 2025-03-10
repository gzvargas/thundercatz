/****************************************************************
 Module to implement a meta stable posedge detector.
 Author : ThunderCatz 		HDL : Verilog		 
 Date : 11/09/2015 							
****************************************************************/ 

module posedgeDetect(sig_posedge, sig, clk);

////////// Variable Declaration for interface ///////////////////
output sig_posedge;	// Asserted at a positive edge of 
input sig;			// The signal on which to detect posedge
input clk;			// System clk

////////// Intermediate wire Declarations ///////////////////////
reg FF1, FF2, FF3;

//////// Infer flops for meta stability and detect///////////////
always @(posedge clk) begin
	FF1 <= sig;
	FF2 <= FF1;	// Flop twice for meta stability
	FF3 <= FF2;	// Flop again for edge detection
end

// Positive edge detection //
assign sig_posedge = FF2 && ~FF3;

endmodule
