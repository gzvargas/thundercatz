/****************************************************************
 Module to implement a 5 Channel Equalizer.
 Author : Thundercatz			HDL : System Verilog		 
 Date : 11/30/2015 							
****************************************************************/ 
module Equalizer( clk, RST_n, LED, A2D_SS_n, A2D_MOSI, 
		  A2D_SCLK, A2D_MISO, MCLK, SCL, LRCLK,
		  SDout, SDin, AMP_ON, RSTn );

input clk,RST_n;		// 50MHz clock and asynch active low reset from push button
output [7:0] LED;		// Active high outputs that drive LEDs
output A2D_SS_n;		// Active low slave select to ADC
output A2D_MOSI;		// Master Out Slave in to ADC
output A2D_SCLK;		// SCLK on SPI interface to ADC
input A2D_MISO;			// Master In Slave Out from ADC
output MCLK;			// 12.5MHz clock to CODEC
output SCL;				// serial shift clock clock to CODEC
output LRCLK;			// Left/Right clock to CODEC
output SDin;			// forms serial data in to CODEC
input SDout;			// from CODEC SDout pin (serial data in to core)
output AMP_ON;			// signal to turn amp on
output RSTn;			// active low reset to CODEC

wire rst_n;			// internal global active low reset
wire valid;
wire valid_fall,valid_rise;
wire [15:0] lft_in,rht_in;
wire [15:0] lft_out,rht_out,lft_out_sel,rht_out_sel;
wire [23:0] LP_gain,B1_gain,B2_gain,B3_gain,HP_gain;
wire [11:0] volume;
wire lftQ_full, rhtQ_full;

reg [10:0] del;

/////////////////////////////////////
// Instantiate Reset synchronizer //
///////////////////////////////////
reset_synch iRST(.clk(clk),.RST_n(RST_n),.rst_n(rst_n));
			  
///////////////////////////////////////////
// Instantiate Your Slide Pot Interface //
/////////////////////////////////////////
slide_intf iSLD (  .POT_LP(LP_gain), .POT_B1(B1_gain), .POT_B2(B2_gain), 
		   .POT_B3(B3_gain), .POT_HP(HP_gain), .VOLUME(volume),
		   .a2d_SS_n(A2D_SS_n), .SCLK(A2D_SCLK), .MOSI(A2D_MOSI),
		   .MISO(A2D_MISO), .clk(clk), .rst_n(rst_n) );		
				
///////////////////////////////////////
// Instantiate Your CODEC Interface //
/////////////////////////////////////
codec_intf iCintf ( .clk(clk), .rst_n(rst_n), .lft_in(lft_in), .rht_in(rht_in),
		 .lft_out(lft_out), .rht_out(rht_out),
                 .valid(valid), .RSTn(RSTn), .MCLK(MCLK), .SCLK(SCL),
		 .LRCLK(LRCLK), .SDin(SDin), .SDout(SDout) );

///////////////////////////////////
// Instantiate Equalizer Core   //
/////////////////////////////////
digitalCore iDigCore (	.lft_out(lft_out), .rht_out(rht_out), 
			.lftQ_full(lftQ_full), .rhtQ_full(rhtQ_full),
		   	.POT_LP(LP_gain), .POT_B1(B1_gain), .POT_B2(B2_gain),
			.POT_B3(B3_gain), .POT_HP(HP_gain), .VOLUME(volume),
		   	.lft_in(lft_in), .rht_in(rht_in), .valid(valid), 
			.clk(clk), .rst_n(rst_n) );

////////////////////////////////////////////////////////////
// Instantiate LED effect driver (optional extra credit) //
//////////////////////////////////////////////////////////
LED_intf iLED (.LEDs(LED), .volume(volume));
	  
////////////////////////////////////////////////
// Implement logic for delaying Amp_on until //
// after queues are steady.   (AMP_ON)      //
/////////////////////////////////////////////
assign AMP_ON = lftQ_full & rhtQ_full;

endmodule
