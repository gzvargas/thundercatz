/****************************************************************
 Module to implement the pot sliders interface testbench.
 Authors : ThunderCatz 		HDL : System Verilog		 
 Student ID: 903 015 5247	
 Date : 11/10/2015 							
****************************************************************/ 

module queue_tb();

reg clk, rst_n;
reg [15:0] count;
reg wrt_smpl;

wire w_seq;
wire [15:0] w_smpl_out;

reg status;	// Flag to represent status of test

// Instantiate DUT //
slowQueue islowQ (.sequencing(w_seq), .smpl_out(w_smpl_out), 
		.wrt_smpl(wrt_smpl), .new_smpl(count), 
		.clk(clk), .rst_n(rst_n));

initial begin
  clk = 0;
  rst_n = 0;			// assert reset
  wrt_smpl = 0;
  count = 0;

  status = 1;

  @(posedge clk);		// wait one clock cycle
  @(negedge clk) rst_n = 1;	// deassert reset on negative edge (typically good practice)

  for (count = 0; count < 1533; count = count + 1) begin
	wrt_smpl = 1;
	@(negedge w_seq);
  end

  @(posedge clk)
  @(posedge clk)
  wrt_smpl = 0;
  @(posedge clk);

  for (count = 512; count < 1533; count = count + 1) begin

	@(posedge clk);

	if (w_smpl_out == count) 
		$display("PASS\n");
	else begin
		$display("FAIL: Expected: %h, Read: %h\n", count, w_smpl_out);
		status = 0;
	end
  end

  if (status)
		$display("All Tests Passed. Test Successful.\n");
  else
		$display("***************Test Failed***************\n");

  $stop;
end

always
  #5 clk = ~clk;

endmodule  
