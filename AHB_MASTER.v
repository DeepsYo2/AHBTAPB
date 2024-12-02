/*
// TITLE :          AHB_MASTER.v

// Created by :     Mr. Deepak Kumar

// Duration :       22 Nov 2024 to 24 Nov 2024

// Date of publish : 1 Dec 2024
*/


module AHB_MASTER(Hclk,Hresetn,Hrdata,Hwrite,Hreadyin,Hreadyout,Htrans,Hwdata,Haddr);


// Declaring inputs and outputs

input Hclk,Hresetn,Hreadyout;
input [31:0] Hrdata;
output reg Hwrite,Hreadyin;
output reg [1:0] Htrans;
output reg [31:0] Hwdata,Haddr;


//Declaring internal variables

reg [2:0] Hburst;
reg [2:0] Hsize;


//Sigle Write

task single_write();
 begin
	@(posedge Hclk)
  	#2;
   	begin
    		Hwrite=1;
    		Htrans=2'b10;
    		Hsize=3'b000;
    		Hburst=3'b000;
    		Hreadyin=1;
    		Haddr=32'h8000_0001;
   	end
  
  	@(posedge Hclk)
  	#2;
   	begin
    		Htrans=2'b00;
    		Hwdata=8'hA3;
   	end 
 end
endtask

//Single Read

task single_read();
 begin
	@(posedge Hclk)
  	#2;
   	begin
		Hwrite=0;
    		Htrans=2'b10;
    		Hsize=3'b000;
    		Hburst=3'b000;
    		Hreadyin=1;
    		Haddr=32'h8000_00A2;
	end
  
  	@(posedge Hclk)
  	#2;
   	begin
    		Htrans=2'b00;
   	end 
 end
endtask


endmodule