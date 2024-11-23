module AHB_SLAVE_Interface_tb();


//Declaration of the inputs and outputs
reg Hclk, Hresetn, Hwrite, Hreadyin;
reg[1:0] Htrans;
reg[31:0] Haddr;
reg[31:0] Hwdata;
wire valid, Hwritereg;
wire[31:0] Haddr1;
wire[31:0] Haddr2;
wire[31:0] Hwdata1, Hrdata;
wire[31:0] Hwdata2;
wire[2:0] tempselx;
wire[1:0] Hresp;


//Instantiation
AHB_SLAVE_Interface DUT( .Hclk(Hclk), .Hresetn(Hresetn), .Hwrite(Hwrite), .Hreadyin(Hreadyin), 
 .Htrans(Htrans), .Haddr(Haddr), .Hwdata(Hwdata), .valid(valid), .Haddr1(Haddr1), .Haddr2(Haddr2), 
 .Hwdata1(Hwdata1), .Hwdata2(Hwdata2), .Hwritereg(Hwritereg), .tempselx(tempselx), .Hrdata(Hrdata), .Hresp(Hresp) );


//Declaration of Hclk
initial
  begin
	Hclk = 1'b0;
  forever #10;
	Hclk = ~Hclk;
  end


//Declaration of Hresetn
task r();
  begin
	@(negedge Hclk)
	    Hresetn = 1'b0;
	#10;
	@(negedge Hclk)
	    Hresetn = 1'b1;
  end
endtask


//Passsing inputs through stimulus task
task in( input a, input[1:0] b, input[31:0] c, input[31:0] d );
   begin
	Hreadyin = a;
	Htrans = b;
	Haddr = c;
	Hwdata = d;
   end
endtask


//Monitor Output signals
initial
  begin
        $monitor("Time = %0t, Haddr = %h, valid = %b, Hwritereg = %b, tempselx = %b", 
                 $time, Haddr, valid, Hwritereg, tempselx);
  end


//Stimulus Generation
initial
  begin
	r;
	#10;
	in( 1'b1, 2'b10, 32'h8c00_1234, 32'h8500_0000 );
	#10;
	in( 1'b0, 2'b11, 32'h8040_0000, 32'h8000_0000 );
	#10;
	
	$finish;  //End Simulation
  end

endmodule
