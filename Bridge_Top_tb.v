module BRIDGE_TOP_tb;

// Inputs
reg Hclk, Hresetn, Hwrite, Hreadyin;
reg [31:0] Hwdata, Haddr, Prdata;
reg [1:0] Htrans;

// Outputs
wire Pwrite, Penable, Hreadyout;
wire [1:0] Hresp;
wire [2:0] Pselx;
wire [31:0] Paddr, Pwdata, Hrdata;

// Instantiate the Unit Under Test (UUT)
BRIDGE_TOP uut (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .Hwrite(Hwrite),
    .Hreadyin(Hreadyin),
    .Hwdata(Hwdata),
    .Haddr(Haddr),
    .Htrans(Htrans),
    .Prdata(Prdata),
    .Penable(Penable),
    .Pwrite(Pwrite),
    .Pselx(Pselx),
    .Paddr(Paddr),
    .Pwdata(Pwdata),
    .Hreadyout(Hreadyout),
    .Hresp(Hresp),
    .Hrdata(Hrdata)
);

// Clock generation
initial begin
    Hclk = 0;
    forever #5 Hclk = ~Hclk; // Clock period: 10 ns
end

// Stimulus
initial begin
    // Initialize inputs
    Hresetn = 0; Hwrite = 0; Hreadyin = 0;
    Hwdata = 0; Haddr = 0; Prdata = 0;
    Htrans = 2'b00;

    // Apply reset
    #10 Hresetn = 1;

    // Test Case 1: Idle state, no write or read transaction
    #20 Hwrite = 0; Htrans = 2'b00; Hwdata = 32'h0000_0000; Haddr = 32'h1000_0000;

    // Test Case 2: Write transaction
    #20 Hwrite = 1; Htrans = 2'b10; Hwdata = 32'hA5A5_A5A5; Haddr = 32'h2000_0000;

    // Test Case 3: Read transaction
    #20 Hwrite = 0; Htrans = 2'b01; Hwdata = 32'h0000_0000; Haddr = 32'h3000_0000; Prdata = 32'h5A5A_5A5A;

    // Test Case 4: Idle state after transaction completion
    #20 Hwrite = 0; Htrans = 2'b00; Hwdata = 32'h0000_0000; Haddr = 32'h4000_0000;

    // End simulation
    #50 $finish;
end

// Monitor signals
initial begin
    $monitor($time, " Hclk=%b Hresetn=%b Hwrite=%b Hreadyin=%b Htrans=%b Haddr=%h Hwdata=%h Prdata=%h Pwrite=%b Penable=%b Pselx=%b Paddr=%h Pwdata=%h Hreadyout=%b Hresp=%b Hrdata=%h",
                     Hclk, Hresetn, Hwrite, Hreadyin, Htrans, Haddr, Hwdata, Prdata, Pwrite, Penable, Pselx, Paddr, Pwdata, Hreadyout, Hresp, Hrdata);
end

endmodule
