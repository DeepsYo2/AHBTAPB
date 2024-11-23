module Bridge_Top (
    input Hclk, 
    input Hresetn, 
    input Hwrite, 
    input Hreadyin,
    input[1:0] Hresp,  
    input[1:0] Htrans, 
    input [31:0] Haddr,
    input [31:0] Hwdata, 
    input [31:0] Prdata, 

    output Pwrite, 
    output Paddr, 
    output Penable, 
    output Pselx,
    output Pwdata, 
    output [31:0] Hreadyout,
    output [31:0] Hrdata 
);


// Instantiate the AHB_SLAVE_Interface module
    AHB_SLAVE_Interface AHB_SLAVE (
        .Hclk(Hclk),
        .Hresetn(Hresetn), 
        .Hwrite(Hwrite), 
        .Hreadyin(Hreadyin), 
	.Hresp(Hresp), 
        .Htrans(Htrans), 
        .Haddr(Haddr), 
        .Hwdata(Hwdata), 
        .Prdata(Prdata), 
	.Haddr1(Haddr1), 
	.Haddr2(Haddr2), 
	.Hrdata(Hrdata), 
	.Hwdata1(Hwdata1), 
	.Hwdata2(Hwdata2),  
        .valid(valid), 
        .Hwritereg(Hwritereg), 
        .tempselx(tempselx) 
    );

    // Instantiate the APB_Controller module
    APB_Controller APB_CONTROLLER (
        .Hclk(Hclk), 
        .Hresetn(Hresetn), 
        .Hwrite(Hwrite), 
        .valid(valid), 
        .Haddr(Haddr), 
        .Hwdata(Hwdata), 
        .Haddr1(Haddr1), 
        .Haddr2(Haddr2), 
        .Hwdata1(Hwdata1), 
        .Hwdata2(Hwdata2), 
        .Hwritereg(Hwritereg), 
        .tempselx(tempselx), 
        .Pwrite(Pwrite),  
        .Penable(Penable),  
        .Hreadyout(Hreadyout), 
        .Pselx(Pselx), 
        .Pwdata(Pwdata), 
        .Paddr(Paddr), 
        .Prdata(Prdata) 
    );

endmodule
