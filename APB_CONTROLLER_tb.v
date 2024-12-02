/*
// TITLE :          APB_CONTROLLER_tb.v

// Created by :     Mr. Deepak Kumar

// Duration :       18 Nov 2024 to 21 Nov 2024

// Date of publish : 30 Nov 2024
*/



module APB_Controller_tb();


// Declare the ports
reg Hclk;
reg Hresetn;
reg Hwrite;
reg valid;
reg Hwritereg;
reg [31:0] Haddr;
reg [31:0] Hwdata;
reg [31:0] Haddr1;
reg [31:0] Haddr2;
reg [31:0] Hwdata1;
reg [31:0] Hwdata2;
reg [2:0] tempselx;

wire Pwrite;
wire Penable;
wire Hreadyout;
wire [2:0] Pselx;
wire [31:0] Pwdata;
wire [31:0] Paddr;
wire [31:0] Prdata;


// Instantiate the APB Controller
APB_Controller DUT( .Hclk(Hclk), .Hresetn(Hresetn), .Hwrite(Hwrite), .valid(valid),
		    .Hwritereg(Hwritereg), .Haddr(Haddr), .Hwdata(Hwdata), .Haddr1(Haddr1),
		    .Haddr2(Haddr2), .Hwdata1(Hwdata1), .Hwdata2(Hwdata2), .tempselx(tempselx),
		    .Pwrite(Pwrite), .Penable(Penable), .Hreadyout(Hreadyout), .Pselx(Pselx),
		    .Pwdata(Pwdata), .Paddr(Paddr), .Prdata(Prdata) );


// Clock Generation
initial
  begin
	Hclk = 1'b0;
	forever #10
	Hclk = ~Hclk;
  end


// Reset task
task r();
  begin
	@(negedge Hclk)
		Hresetn = 1'b0;
	#10;
		Hresetn = 1'b1;
  end
endtask


// Input Stimulus task
task in(input a, input [31:0] b, input [31:0] c, input [31:0] d, input [31:0] e, input [31:0] f, input [31:0] g, input [2:0] h, input w);
  begin
	valid = a;
    	Haddr = b;
    	Hwdata = c;
    	Haddr1 = d;
    	Haddr2 = e;
    	Hwdata1 = f;
    	Hwdata2 = g;
    	tempselx = h;
    	Hwritereg = w;
  end
endtask

// Stimulus Generation
initial
  begin
	r;
	#10;
	
	// Apply first set of inputs (Write operation)
    	in(1'b1, 32'h8c00_1234, 32'h8500_0000, 32'h8040_0000, 32'h8000_0000, 32'h0000_0000, 32'h0000_0000, 3'b001, 1'b1);
    	#10;
    
    	// Apply second set of inputs (Read operation)
    	in(1'b1, 32'h8040_0000, 32'h8000_0000, 32'h8040_0000, 32'h8000_0000, 32'h0000_0000, 32'h0000_0000, 3'b010, 1'b0);
    	#10;
    
    	// Apply third set of inputs (Write operation)
    	in(1'b1, 32'h8c00_5678, 32'h9500_0000, 32'h8040_1111, 32'h9000_1111, 32'h0000_0000, 32'h0000_0000, 3'b011, 1'b1);
    	#10;

	$finish;    // End Simulatioin
  end

endmodule
