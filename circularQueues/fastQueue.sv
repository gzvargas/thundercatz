/****************************************************************
 Module to implement the circular queue opperating at 48.828kHz.
 Authors : ThunderCatz 		HDL : System Verilog		 
 Student ID: 903 015 5247	
 Date : 11/13/2015 							
****************************************************************/ 

module fastQueue(sequencing, smpl_out, wrt_smpl, new_smpl, clk, rst_n);

////////// Variable Declaration for interface ///////////////////
input clk, rst_n;		// system reset and clk
input [15:0] new_smpl;		// The newest sample from CODEC
input wrt_smpl;			// Triggers a new sample into queue and 
				//   reading out of the queue data

output reg [15:0] smpl_out;	// Data being read out
output reg sequencing; 		// High the entire time the 1021 samples
				//  


////////// Intermediate wire Declarations ///////////////////////



endmodule