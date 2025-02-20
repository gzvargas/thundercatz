/****************************************************************
Module to implement a testbench for the Loopback equalizer.
Testbench style : Linear ( no self check ) 	
Author : Thundercatz	HDL : Verilog	
Date : 11/09/15 							
****************************************************************/ 

module EqualizerLoopBack_tb();

////////// Variable Declaration for interface ///////////////////
	
wire	w_LRCLK,
	w_SCL,
	w_MCLK,
	w_RSTn,
	w_SDin;

reg	stm_SDout;

reg	stm_clk,
	stm_RST_n;

////////// DUT instantiation ////////////////////////////////////
EqualizerLoopBack iDUT (.LRCLK(w_LRCLK), .SCL(w_SCL), .MCLK(w_MCLK), .RSTn(w_RSTn), .SDin(w_SDin),
		   	.SDout(stm_SDout), .RST_n(stm_RST_n), .clk(stm_clk));

///////////////////////////////////
/////Stimulus generation //////////
///////////////////////////////////
initial 
begin 
//////Intialize every input ///////
stm_clk = 0;

////// Global Reset //////////////
stm_RST_n = 0;
#10;

///////Begin Stimuli /////////////
stm_RST_n = 1;

@(posedge stm_clk)
stm_SDout = 1;

end 

///////Clock Generation ////////////
// Clock should be 50MHz
// 50MHz => 1/50000000 period = 20ns
always #10 stm_clk =~stm_clk;

endmodule 