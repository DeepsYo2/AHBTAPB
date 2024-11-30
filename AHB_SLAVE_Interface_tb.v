/*
// TITLE :          AHB_SLAVE_INTERFACE.v

// Created by :     Mr. Deepak Kumar

// Duration :       22 Nov 2024 to 24 Nov 2024

// Date of publish : 1 Dec 2024
*/


module AHB_SLAVE_INTERFACE_tb;

// Declaring inputs and outputs for AHB_Master instance
reg Hclk, Hresetn, Hreadyout;
reg [1:0] Hresp;
reg [31:0] Hrdata;
wire Hwrite, Hreadyin;
wire [1:0] Htrans;
wire [31:0] Hwdata, Haddr;

// Instantiate the AHB_Master module
AHB_Master uut (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .Hresp(Hresp),
    .Hrdata(Hrdata),
    .Hwrite(Hwrite),
    .Hreadyin(Hreadyin),
    .Hreadyout(Hreadyout),
    .Htrans(Htrans),
    .Hwdata(Wwdata),
    .Haddr(Haddr)
);

// Clock generation
initial begin
    Hclk = 0;
    forever #5 Hclk = ~Hclk;  // 10ns clock period
end

// Stimulus
initial begin
    // Initialize inputs
    Hresetn = 0;
    Hreadyout = 1;
    Hresp = 2'b00;
    Hrdata = 32'h0000_0000;

    // Apply reset
    #10 Hresetn = 1;

    // Single Write Operation
    #10 uut.single_write();

    // Wait some time
    #20;

    // Single Read Operation
    #10 uut.single_read();

    // Wait for tasks to complete
    #50;

    // End simulation
    $stop;
end

// Monitor output
initial begin
    $monitor($time, " Hclk=%b Hresetn=%b Hwrite=%b Hreadyin=%b Htrans=%b Haddr=%h Hwdata=%h",
                     Hclk, Hresetn, Hwrite, Hreadyin, Htrans, Haddr, Hwdata);
end

endmodule
