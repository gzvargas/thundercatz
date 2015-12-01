/****************************************************************
 Module to implement the FIR engine for B1 band.
 Authors : ThunderCatz 		HDL : System Verilog		 
 Student ID: 903 015 5247	
 Date : 11/24/2015 							
****************************************************************/ 
module B1_FIR(smpl_out, sequencing, smpl_in, clk, rst_n);

////////// Variable Declaration for interface ///////////////////
output signed [15:0] smpl_out;	// The FIR scaled sample

input signed [15:0] smpl_in;	// The input audio sample from the queue
input sequencing;		// Signals FIR calculation 
input clk, rst_n;		// System clk and reset

////////// Intermediate wire Declarations ///////////////////////
reg [9:0] index;		// Signal to index into ROM

wire signed [15:0] coeff;	// The FIR coefficient
wire signed [31:0] product;	// Product of the coeff and sample

logic signed [31:0] accum;	// Acumulated FIR results
logic delayed_seq;		// Sequencing signal delayed by one clk

/////////////////////// ROM instantiation ///////////////////////
ROM_B1 iROM (.clk(clk), .addr(index), .dout(coeff));

/////////////////////// product assignment ///////////////////////
assign product = (coeff*smpl_in);

/////////////////////// Infer accum flop ////////////////////////
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n)
		accum <= 32'h0000;
	else if (delayed_seq)
		accum <= accum + product;
	else if (sequencing)
		accum <= 32'h0000;
	else
		accum <= accum;
end

/////////////////////// Infer index flop ////////////////////////
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n)
		index <= 10'h000;
	else if (delayed_seq)
		index <= (index + 1) % 1021;
	else if (sequencing)
		index <= 10'h000;
	else
		index <= index;
end

/////////////////////// smpl out assignment /////////////////////
assign smpl_out = {accum[30:15]};

//////////// State Machine for edge detection ///////////////////
// used two states to handle holding RSTn high for one cycle of LRCLK
typedef enum reg {RESET, EDGE} state_t;
state_t state, nxt_state;

// next state logic
always_ff@(posedge clk, negedge rst_n) begin
  if(!rst_n)
    state <= RESET;
  else
    state <= nxt_state;
end

// State machine output combinational logic
always_comb begin
  delayed_seq = 0;
  nxt_state = RESET;

  case(state)

    RESET: begin
      if(!rst_n)
	nxt_state = RESET;
      else if(sequencing) begin
	delayed_seq = 1; 
	nxt_state = EDGE;
      end
    end

    EDGE: begin
      if(!rst_n)
	nxt_state = RESET;
      else if (!sequencing) begin
 	delayed_seq = 0;
	nxt_state = RESET;
      end else begin
	delayed_seq = 1;
	nxt_state = EDGE;
      end
    end

  endcase
end

endmodule