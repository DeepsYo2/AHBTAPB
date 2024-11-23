module AHB_SLAVE_Interface( input Hclk, Hresetn, Hwrite, Hreadyin, 
 input[1:0] Htrans, Hresp, input[31:0] Haddr, Hwdata, Prdata, 
 output reg valid, output reg[31:0] Haddr1, Haddr2, Hwdata1, Hwdata2, Hrdata, 
 output reg Hwritereg, output reg[2:0] tempselx );


// Decalration of output valid
always@(*)
  begin
		valid = 1'b0;  
	  if( Hreadyin && ( Htrans == 2'b10 || Htrans == 2'b11 ) && ( Haddr >= 32'h8000_0000 && Haddr < 32'h8c00_0000 ) )
		valid = 1'b1;

  end


// Declaration of output tempselx
always@(*)
  begin
		tempselx = 3'b000;
	  if( Haddr >= 32'h8000_0000 && Haddr < 32'h8400_0000 )
		tempselx = 3'b001;
	  else if( Haddr >= 32'h8400_0000 && Haddr < 32'h8800_0000 )
		tempselx = 3'b010;
	  else if( Haddr >= 32'h8800_0000 && Haddr < 32'h8c00_0000 )
		tempselx = 3'b100;

  end


// Decalration of outputs Haddr1 and Haddr2
always @(posedge Hclk)
  begin
	if( !Hresetn )
		begin
		Haddr1 <= 32'h0000_0000;
        	Haddr2 <= 32'h0000_0000;
    	  	end
	else
	  	begin
        	Haddr1 <= Haddr;
        	Haddr2 <= Haddr1;
    	  	end
  end


// Declaration of outputs Hwdata1 and Hwdata2
always @(posedge Hclk)
  begin
	if( !Hresetn )
		begin
		Hwdata1 <= 32'h0000_0000;
        	Hwdata2 <= 32'h0000_0000;
    	  	end
	else
	  	begin
        	Hwdata1 <= Haddr;
        	Hwdata2 <= Haddr1;
    	  	end
  end


// Declaration of output Hwritereg
always@(posedge Hclk)
  begin
	if( !Hresetn )
		Hwritereg <= 1'b0;
	else
		Hwritereg <= Hwrite;
  end

endmodule
