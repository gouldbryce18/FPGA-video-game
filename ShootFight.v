`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2018 03:37:23 PM
// Design Name: 
// Module Name: EksBox
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module XBox(ARST_L, CLK, SCLK, SDATA, HSYNC, VSYNC, RED, GREEN, BLUE);
input ARST_L, CLK, SCLK, SDATA;
output HSYNC, VSYNC;
output [3:0] RED;
output [3:0] GREEN;
output [3:0] BLUE;

wire synca_i;
wire syncb_i;
wire keyup_i;
wire slowclk_i;
wire swdb_i;
wire [3:0] hex1_i;
wire [3:0] hex0_i;
wire [7:0] hex_i;
wire [11:0] sel_i;
wire [9:0] hcoord_i;
wire [9:0] vcoord_i;

assign hex_i = {hex1_i, hex0_i};

Clk25Mhz Clk25Mhz(.CLKIN(CLK), .ACLR(ARST_L), .CLKOUT(slowclk_i));
Sync2 Sync2a(.CLK(CLK), .ASYNC(SCLK), .ACLR_L(ARST_L), .SYNC(synca_i));
Sync2 Sync2b(.CLK(CLK), .ASYNC(SDATA), .ACLR_L(ARST_L), .SYNC(syncb_i));
KBDecoder KBDecoder(.CLK(synca_i), .SDATA(syncb_i), .ARST_L(ARST_L), .KEYUP(keyup_i), .HEX1(hex1_i), .HEX0(hex0_i));
VGAEncoder VGAEncoder(.CLK(slowclk_i), .CSEL(sel_i), .ARST(ARST_L), .HSYNC(HSYNC), .VSYNC(VSYNC), .RED(RED), .GREEN(GREEN), .BLUE(BLUE),
 .HCOORD(hcoord_i), .VCOORD(vcoord_i));
SwitchDB SwitchDB(.SW(keyup_i), .CLK(slowclk_i), .ACLR_L(ARST_L), .SWDB(swdb_i));

VGAController2 VGAController2(.CLK(slowclk_i), .KBCODE(hex_i), .HCOORD(hcoord_i), .VCOORD(vcoord_i), .KBSTROBE(swdb_i), .ARST_L(ARST_L), .CSEL(sel_i));
       
endmodule
