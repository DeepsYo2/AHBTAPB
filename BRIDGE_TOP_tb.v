/*
// TITLE :          BRIDGE_TOP_tb.v

// Created by :     Mr. Deepak Kumar

// Duration :       28 Nov 2024 to 29 Nov 2024

// Date of publish : 1 Dec 2024
*/


module BRIDGE_TOP_tb();


//Internal wires
reg Hclk, Hresetn;
wire[31:0] Haddr, Hwdata, Prdata, Haddr1, Haddr2, Hrdata, Hwdata1, Hwdata2, Paddr, Pwdata;
wire[1:0] Htrans, Hresp;
wire[2:0] tempselx, Pselx;
wire Hreadyin, Hwrite, Hwritereg, valid, Hreadyout, Penable, Pwrite;


//Instantiate AHB_MASTER
AHB_MASTER AHB( .Hclk(Hclk), .Hresetn(Hresetn), .Hreadyout(Hreadyout), .Hrdata(Hrdata), 
 .Haddr(Haddr), .Hwdata(Hwdata), .Hwrite(Hwrite), .Hreadyin(Hreadyin), .Htrans(Htrans) );


//INSTANTIATE APB_Controller_Interface
APB_CONTROLLER_INTERFACE APB( .Pwrite(Pwrite), .Penable(Penable), 
 .Pselx(Pselx), .Paddr(Paddr), .Pwdata(Pwdata), .Pwrite_out(Pwrite_out), 
 .Penable_out(Penable_out), .Pselx_out(Pselx_out), .Paddr_out(Paddr_out), .Pwdata_out(Pwdata_out), .Prdata(Prdata) );


//Instantiate Bridge_Top
BRIDGE_TOP Bridge( .Hclk(Hclk), .Hresetn(Hresetn), .Hwrite(Hwrite), .Hreadyin(Hreadyin), .Hresp(Hresp), 
    		   .Htrans(Htrans), .Haddr(Haddr), .Hwdata(Hwdata), .Prdata(Prdata), .Pwrite(Pwrite), 
   		   .Paddr(Paddr), .Penable(Penable), .Pselx(Pselx), .Pwdata(Pwdata), .Hreadyout(Hreadyout), .Hrdata(Hrdata) );


//Clock generation
initial
  begin
	Hclk = 1'b0;
	forever #10
	Hclk = ~Hclk;
  end


task reset();
  begin
	@(negedge Hclk)
		Hresetn = 1'b0;
	#10;
	@(negedge Hclk)
		Hresetn = 1'b1;
  end
endtask


initial
  begin
	reset;
	#10;
	AHB.single_write();
	#10;
	AHB.single_read();
	
  end

endmodule



