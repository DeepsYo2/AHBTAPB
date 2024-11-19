module APB_Controller(
    input Hclk, Hresetn, Hwrite, valid, 
    input [31:0] Haddr, Hwdata, Haddr1, Haddr2, Hwdata1, Hwdata2, Hrdata, 
    input Hwritereg, input [2:0] tempselx, input [1:0] Hresp, 
    output reg Pwrite, Penable, Hreadyout, 
    output reg [2:0] Pselx, 
    output reg [31:0] Pwdata, Paddr, Prdata
);

// Define the states
parameter ST_IDLE = 3'b000,
          ST_WWAIT = 3'b001,
          ST_WRITE = 3'b010,
	  ST_WRITEP = 3'b011,
          ST_WENABLE = 3'b100,
          ST_WENABLEP = 3'b101,
          ST_READ = 3'b110,
          ST_RENABLE = 3'b111;

// Present States and Next States
reg [2:0] ps, ns;

// Present State Logic
always @(posedge Hclk) begin
    if (!Hresetn)
        ps <= ST_IDLE;
    else
        ps <= ns;
  end

// Next State Logic
always @(*) begin
    ns = ps; // Default to the current state
    case (ps)
        ST_IDLE: begin
            if (valid && Hwrite)
                ns = ST_WWAIT;
            else if (valid && ~Hwrite)
                ns = ST_READ;
        end

        ST_WWAIT: begin
            ns = valid ? ST_WRITEP : ST_WRITE;
        end

        ST_WRITE: begin
            ns = ~valid ? ST_WENABLE : ST_WENABLEP;
        end
	
	ST_WRITEP: begin
	    ns = ST_WENABLEP;
	end

        ST_WENABLE: begin
            if (~valid)
                ns = ST_IDLE;
            else if (valid && ~Hwrite)
                ns = ST_READ;
            else if (valid && Hwrite)
                ns = ST_WWAIT;
        end

        ST_WENABLEP: begin
            ns = (valid && Hwritereg) ? ST_WRITEP : ST_WRITE;
        end

        ST_READ: begin
            ns = ST_RENABLE;
        end

        ST_RENABLE: begin
            if (~valid)
                ns = ST_IDLE;
            else if (valid && ~Hwrite)
                ns = ST_READ;
        end

        default: ns = ST_IDLE;
    endcase
end

// Temporary Logic
reg [31:0] Paddr_temp, Pwdata_temp;
reg Pwrite_temp, Penable_temp;
reg [2:0] Pselx_temp;
reg [31:0] Hreadyout_temp;

always @(*) begin
    // Default values for temporary logic
    Paddr_temp = 32'b0;
    Pwrite_temp = 1'b0;
    Pselx_temp = 3'b000;
    Penable_temp = 1'b0;
    Pwdata_temp = 32'b0;
    Hreadyout_temp = 1'b1;

    case (ps)
        ST_IDLE: begin
            if (valid && Hwrite) begin
                Pselx_temp = 3'b000;
                Penable_temp = 1'b0;
                Hreadyout_temp = 1'b0;
            end else if (valid && ~Hwrite) begin
                Paddr_temp = Haddr;
                Pwrite_temp = Hwrite;
                Pselx_temp = tempselx;
                Penable_temp = 1'b0;
                Hreadyout_temp = 1'b0;
            end else begin
                Pselx_temp = 3'b000;
                Penable_temp = 1'b0;
                Hreadyout_temp = 1'b1;
            end
        end

        ST_WWAIT: begin
            if (valid) begin
                Paddr_temp = Haddr2;
                Pwrite_temp = Hwrite;
                Pselx_temp = tempselx;
                Penable_temp = 1'b0;
                Pwdata_temp = Hwdata1;
                Hreadyout_temp = 1'b0;
            end else begin
                Paddr_temp = Haddr;
                Pwrite_temp = Hwrite;
                Pselx_temp = tempselx;
                Penable_temp = 1'b0;
                Pwdata_temp = Hwdata;
                Hreadyout_temp = 1'b0;
            end
        end

        ST_WRITE: begin
            Paddr_temp = Haddr;
            Pwrite_temp = Hwrite;
            Pselx_temp = tempselx;
            Penable_temp = 1'b1;
            Pwdata_temp = Hwdata;
            Hreadyout_temp = ~valid;
        end

	ST_WRITEP: begin
            Paddr_temp = Haddr;
            Pwrite_temp = Hwrite;
            Pselx_temp = tempselx;
            Penable_temp = 1'b0;
            Pwdata_temp = Hwdata;
            Hreadyout_temp = ~valid;
        end

        ST_WENABLE: begin
            Paddr_temp = Haddr;
            Pwrite_temp = 1'b1;
            Penable_temp = 1'b1;
            Pselx_temp = tempselx;
            Pwdata_temp = Hwdata;
            Hreadyout_temp = 1'b1;
        end

        ST_WENABLEP: begin
            if (valid && Hwritereg) begin
                Paddr_temp = Haddr;
                Pwrite_temp = 1'b1;
                Penable_temp = 1'b1;
                Pselx_temp = tempselx;
                Pwdata_temp = Hwdata;
                Hreadyout_temp = 1'b0;
            end else if (~valid && Hwritereg) begin
                Paddr_temp = Haddr;
            end
        end

        ST_READ: begin
            Paddr_temp = Haddr;
            Pwrite_temp = 1'b0;
            Penable_temp = 1'b1;
            Pselx_temp = tempselx;
            Pwdata_temp = 32'b0;
            Hreadyout_temp = 1'b0;
        end

        ST_RENABLE: begin
            if (~valid) begin
                Paddr_temp = Haddr;
                Pwrite_temp = 1'b0;
                Penable_temp = 1'b1;
                Pselx_temp = tempselx;
                Pwdata_temp = 32'b0;
                Hreadyout_temp = 1'b1;
            end else if (valid && ~Hwrite) begin
                Paddr_temp = Haddr;
            end
        end

        default: begin
            Pselx_temp = 3'b000;
            Penable_temp = 1'b0;
            Hreadyout_temp = 1'b1;
        end
    endcase
end

// Output Logic
always @(posedge Hclk or negedge Hresetn) begin
    if (!Hresetn) begin
        Pwrite <= 1'b0;
        Penable <= 1'b0;
        Pselx <= 3'b000;
        Pwdata <= 32'b0;
        Paddr <= 32'b0;
        Hreadyout <= 1'b1;
    end else begin
        Pwrite <= Pwrite_temp;
        Penable <= Penable_temp;
        Pselx <= Pselx_temp;
        Pwdata <= Pwdata_temp;
        Paddr <= Paddr_temp;
        Hreadyout <= Hreadyout_temp;
    end
end

endmodule

