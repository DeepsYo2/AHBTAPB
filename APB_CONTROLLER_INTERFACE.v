/*
// TITLE :          APB_CONTROLLER_INTERFACE.v

// Created by :     Mr. Deepak Kumar

// Duration :       22 Nov 2024 to 24 Nov 2024

// Date of publish : 1 Dec 2024
*/



module APB_CONTROLLER_INTERFACE(Pwrite,Pselx,Penable,Paddr,Pwdata,Pwrite_out,Pselx_out,Penable_out,Paddr_out,Pwdata_out,Prdata);

input Pwrite,Penable;
input [2:0] Pselx;
input [31:0] Pwdata,Paddr;

output Pwrite_out,Penable_out;
output [2:0] Pselx_out;
output [31:0] Pwdata_out,Paddr_out;
output reg [31:0] Prdata;

assign Penable_out=Penable;
assign Pselx_out=Pselx;
assign Pwrite_out=Pwrite;
assign Paddr_out=Paddr;
assign Pwdata_out=Pwdata;

always @(*)
 begin
  if (~Pwrite && Penable)
   Prdata=($random)%256;
  else
   Prdata=0;
 end

endmodule