/*
// TITLE :          AHB MASTER.v

// Created by :     Mr. Deepak Kumar

// Duration :       22 Nov 2024 to 24 Nov 2024

// Date of publish : 30 Nov 2024
*/


module AHB_MASTER( input Hclk, Hresetn, Hreadyout, input[31:0] Hrdata, 
 output reg[31:0] Haddr, Hwdata, output reg Hwrite, Hreadyin, 
 output reg[1:0] Htrans );


// Internal variables
reg[2:0] Hburst;
reg[2:0] Hsize;

integer i, j;


// Single write
task single_write();
  begin
	@(posedge Hclk)
		#10;
	begin
		Hwrite = 1;
		Htrans = 2'd2;
		Hsize  = 0;
		Hburst = 0;
		Hreadyin=1;
		Haddr  = 32'h8000_0001;
	end

	@(posedge Hclk)
		#10;
	begin
		Htrans = 2'd0;
		Hwdata = 8'h80;
	end
  end
endtask


// Single Read
task single_read();
  begin
	@(posedge Hclk)
	begin
		Hwrite = 0;
		Htrans = 2'd2;
		Hsize  = 0;
		Hburst = 0;
		Hreadyin=1;
		Haddr=32'h8000_0001;
	end
	@(posedge Hclk)
		#10;
	begin
		Htrans = 2'd0;
	end
  end
endtask


// Burst Write
task burst_write();
  begin
	@(posedge Hclk)
		#10;
	begin
		Hwrite = 1'b1;
		Htrans = 2'd2;
		Hsize  = 0;
		Hburst = 3'd3;
		Hreadyin=1;
		Haddr  = 32'h8000_0001;
	end
	@(posedge Hclk)
		#10;
	begin
		Haddr = Haddr + 1'b1;
		Hwdata= {$random}%256;
		Htrans= 2'd3;
	end

for( i=0; i<2; i=i+1 )
begin
@(posedge Hclk)
	#10;
	Haddr = Haddr + 1;
	Hwdata= {$random}%256;
	Htrans = 2'd3;
end

@(posedge Hclk)
	#10;
begin
	Hwdata = {$random}%256;
	Htrans = 2'd0;
end

end
endtask

task wrap_write();
begin
	@(posedge Hclk)
		#10;
	begin
		Hwrite =  1'b1;
		Htrans = 2'b10;
		Hsize  = 1;
		Hburst = 2;
		Hreadyin=1;
		Haddr  = 32'h8000_0048;
	end
	@(posedge Hclk)
		#10;
	begin
		Htrans = 2'b11;
		Haddr  = { Haddr[31:3], Haddr[2:1] + 1'b1, Haddr[0] };
		Hwdata = {$random}%256;
	end
	
	for( j=0; j<2; j=j+1 )
	  begin
	  @(posedge Hclk)
		#10;
		Htrans = 2'b11;
		Haddr = { Haddr[31:3], Haddr[2:1] + 1'b1, Haddr[0] };
		Hwdata = {$random}%256;
	  end
	  @(posedge Hclk)
		#10;
	  begin
		Htrans = 2'b00;
		Hwdata = {$random}%256;
	  end

end
endtask

endmodule
