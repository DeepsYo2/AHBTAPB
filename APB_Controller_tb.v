/*
// TITLE :          AHB_SLAVE_INTERFACE.v

// Created by :     Mr. Deepak Kumar

// Duration :       22 Nov 2024 to 24 Nov 2024

// Date of publish : 1 Dec 2024
*/


module APB_CONTROLLER_tb;

// Inputs
reg Hclk, Hresetn, valid, Hwrite, Hwritereg;
reg [31:0] Hwdata, Haddr, Haddr1, Haddr2, Hwdata1, Hwdata2, Prdata;
reg [2:0] tempselx;

// Outputs
wire Pwrite, Penable, Hreadyout;
wire [2:0] Pselx;
wire [31:0] Paddr, Pwdata;

// Instantiate the Unit Under Test (UUT)
APB_CONTROLLER uut (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .valid(valid),
    .Haddr1(Haddr1),
    .Haddr2(Haddr2),
    .Hwdata1(Hwdata1),
    .Hwdata2(Hwdata2),
    .Prdata(Prdata),
    .Hwrite(Hwrite),
    .Haddr(Haddr),
    .Hwdata(Hwdata),
    .Hwritereg(Hwritereg),
    .tempselx(tempselx),
    .Pwrite(Pwrite),
    .Penable(Penable),
    .Pselx(Pselx),
    .Paddr(Paddr),
    .Pwdata(Pwdata),
    .Hreadyout(Hreadyout)
);

// Clock generation
initial begin
    Hclk = 0;
    forever #5 Hclk = ~Hclk; // Clock period: 10 ns
end

// Stimulus
initial begin
    // Initialize inputs
    Hresetn = 0; valid = 0; Hwrite = 0; Hwritereg = 0;
    Hwdata = 0; Haddr = 0; Haddr1 = 0; Haddr2 = 0;
    Hwdata1 = 0; Hwdata2 = 0; Prdata = 0; tempselx = 3'b000;

    // Apply reset
    #10 Hresetn = 1;

    // Test Case 1: Idle to Read Transition
    #10 valid = 1; Hwrite = 0; Haddr = 32'h1000_0000; tempselx = 3'b001;

    // Wait and check outputs
    #20 valid = 0;

    // Test Case 2: Idle to Write Transition
    #10 valid = 1; Hwrite = 1; Hwdata = 32'hA5A5_A5A5; Haddr1 = 32'h2000_0000;

    // Wait and check outputs
    #20 valid = 0;

    // Test Case 3: Read Enable
    #10 valid = 1; Hwrite = 0; Haddr = 32'h3000_0000;

    // Wait and check outputs
    #20;

    // Test Case 4: Write Enable
    #10 valid = 1; Hwritereg = 1; Hwdata = 32'h5A5A_5A5A; Haddr2 = 32'h4000_0000;

    // Wait and check outputs
    #20 valid = 0;

    // End simulation
    #50 $finish;
end

// Monitor signals
initial begin
    $monitor($time, " Hclk=%b Hresetn=%b valid=%b Hwrite=%b Hwritereg=%b Paddr=%h Pwdata=%h Pwrite=%b Penable=%b Pselx=%b Hreadyout=%b",
                     Hclk, Hresetn, valid, Hwrite, Hwritereg, Paddr, Pwdata, Pwrite, Penable, Pselx, Hreadyout);
end

endmodule
