`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2018 05:47:00 PM
// Design Name: 
// Module Name: VGAController
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


module VGAController2(CLK, KBCODE, HCOORD, VCOORD, KBSTROBE, CSEL, ARST_L);
input CLK, ARST_L, KBSTROBE;
input [7:0] KBCODE;
input [9:0] HCOORD;
input [9:0] VCOORD;
output [11:0] CSEL;

reg refresh;
reg refreshSlow;
reg [31:0] count_i;
reg [31:0] count2_i;
reg [11:0] CSEL;
reg [10:0] XPos;
reg [10:0] xspeed_i;
reg [10:0] YPos;
reg [10:0] yspeed_i;
reg [10:0] laserPos1X; 
reg [10:0] laserPos1Y;
reg [10:0] laserPos2X; 
reg [10:0] laserPos2Y; 
reg [10:0] laserPos3X; 
reg [10:0] laserPos3Y;  
wire col_S;
wire col_N;
wire col_W;
wire col_E;
wire floor;
reg laser1Wait;
reg laser2Wait;
reg laser3Wait;
reg moveright;
reg moveleft;
reg [6:0] jumpcount;
reg [6:0] laserCount;
reg jump;
reg [2:0] laser;
reg shield;
reg laserEN;
wire shieldCol;

assign col_S = (YPos >= 471) ? 1'b1 : 1'b0;
assign col_N = (YPos <= 10) ? 1'b1 : 1'b0;
assign col_W = (XPos <= 10) ? 1'b1 : 1'b0;
assign col_E = (XPos >= 630) ? 1'b1 : 1'b0;
assign floor = (YPos >= 420) ? 1'b1 : 1'b0;
//assign shieldCol = (laserPosX = ((XPos + 25)&&(Ypos + 30)&&(YPos - 5))) ? 1'b1 : 1'b0;
assign col_Elaser1 = (laserPos1X >= 630) ? 1'b1 : 1'b0;
assign col_Elaser2 = (laserPos2X >= 630) ? 1'b1 : 1'b0;
assign col_Elaser3 = (laserPos3X >= 630) ? 1'b1 : 1'b0;


////PLAYER TWO/////
/*reg [10:0] XPos2;
reg [10:0] xspeed2_i;
reg [10:0] YPos2;
reg [10:0] yspeed2_i;
reg moveright2;
reg moveleft2;
reg [6:0] jumpcount2;
reg [6:0] laserCount2;
reg [10:0] laserPos1X2; 
reg [10:0] laserPos1Y2;
reg [10:0] laserPos2X2; 
reg [10:0] laserPos2Y2; 
reg [10:0] laserPos3X2; 
reg [10:0] laserPos3Y2;  
wire col_S2;
wire col_N2;
wire col_W2;
wire col_E2;
wire floor2;

assign col_S2 = (YPos2 >= 471) ? 1'b1 : 1'b0;
assign col_N2 = (YPos2 <= 10) ? 1'b1 : 1'b0;
assign col_W2 = (XPos2 <= 10) ? 1'b1 : 1'b0;
assign col_E2 = (XPos2 >= 630) ? 1'b1 : 1'b0;
assign floor2 = (YPos2 >= 420) ? 1'b1 : 1'b0;
//assign shieldCol = (laserPosX = ((XPos + 25)&&(Ypos + 30)&&(YPos - 5))) ? 1'b1 : 1'b0;
assign col2_Elaser1 = (laserPos1X2 >= 630) ? 1'b1 : 1'b0;
assign col2_Elaser2 = (laserPos2X2 >= 630) ? 1'b1 : 1'b0;
assign col2_Elaser3 = (laserPos3X2 >= 630) ? 1'b1 : 1'b0;
*/
always@(posedge CLK or negedge ARST_L)
    begin
        if(ARST_L == 1'b0)
            ;      
        //hair
        else if((HCOORD >= XPos) && (HCOORD < (XPos + 10))&&(VCOORD >= YPos)&&(VCOORD < (YPos + 2)))
            CSEL <= 12'h000;
        //forehead
        else if((HCOORD >= XPos + 2) && (HCOORD < (XPos + 10)) && (VCOORD >= YPos+2) && (VCOORD < (YPos + 4)))
            CSEL <= 12'hFA5;
        //hair
        else if((HCOORD >= XPos) && (HCOORD < (XPos + 2)) && (VCOORD >= YPos+2) && (VCOORD < (YPos + 5)))
            CSEL <= 12'h000; 
       //head 
        else if((HCOORD >= XPos + 2) && (HCOORD < (XPos + 6)) && (VCOORD >= YPos+4) && (VCOORD < (YPos + 5)))
             CSEL <= 12'hFA5;
        //eye
        else if((HCOORD >= XPos + 6) && (HCOORD < (XPos + 7)) && (VCOORD >= YPos+4) && (VCOORD < (YPos + 5)))
             CSEL <= 12'hFFF; 
        //eye color           
        else if((HCOORD >= XPos+7) && (HCOORD < (XPos + 8)) && (VCOORD >= YPos+4) && (VCOORD < (YPos + 5)))
                CSEL <= 12'h00F; 
        //between eyes
        else if((HCOORD >= XPos + 8) && (HCOORD < (XPos + 10)) && (VCOORD >= YPos+4) && (VCOORD < (YPos + 5)))
                CSEL <= 12'hFA5;  
        //face cheeks
        else if((HCOORD >= XPos) && (HCOORD < (XPos + 10)) && (VCOORD >= YPos+5) && (VCOORD < (YPos + 8)))
                CSEL <= 12'hFA5;  
        //jaw
        else if((HCOORD >= XPos) && (HCOORD < (XPos + 6)) && (VCOORD >= YPos+9) && (VCOORD < (YPos + 10)))
                CSEL <= 12'hFA5;  
        //mouth
        else if((HCOORD >= XPos + 6) && (HCOORD < (XPos + 10)) && (VCOORD >= YPos+8) && (VCOORD < (YPos + 9)))
                CSEL <= 12'h000;
        //chin 
        else if((HCOORD >= XPos) && (HCOORD < (XPos + 10)) && (VCOORD >= YPos+8) && (VCOORD < (YPos + 10)))
                CSEL <= 12'hFA5; 
        //neck 
        else if((HCOORD >= XPos + 3) && (HCOORD < (XPos + 7)) && (VCOORD >= YPos+10) && (VCOORD < (YPos + 12)))
                CSEL <= 12'hFA5;  
        //torso
        else if((HCOORD >= XPos + 1) && (HCOORD < (XPos + 10)) && (VCOORD >= YPos+12) && (VCOORD < (YPos + 14)))
                CSEL <= 12'h00F;          
        //shoulder
        else if((HCOORD >= XPos + 1) && (HCOORD < (XPos + 4)) && (VCOORD >= YPos+14) && (VCOORD < (YPos + 16)))
                CSEL <= 12'h00F;  
        //body
        else if((HCOORD >= XPos + 1) && (HCOORD < (XPos + 10)) && (VCOORD >= YPos+16) && (VCOORD < (YPos + 23)))
                CSEL <= 12'h00F;
        //arm                                          
        else if((HCOORD >= XPos + 4) && (HCOORD < (XPos + 15)) && (VCOORD >= YPos+14) && (VCOORD < (YPos + 16)))
                CSEL <= 12'hFA5;
        //legs 1                                         
        else if((HCOORD >= XPos + 3) && (HCOORD < (XPos + 5)) && (VCOORD >= YPos+23) && (VCOORD < (YPos + 27)))
                CSEL <= 12'h000;  
       //lwg 2                                        
        else if((HCOORD >= XPos + 6) && (HCOORD < (XPos + 8)) && (VCOORD >= YPos+23) && (VCOORD < (YPos + 27)))
                CSEL <= 12'h000;
        //gun barrel 
        else if((HCOORD >= XPos + 13) && (HCOORD < (XPos + 22)) && (VCOORD >= YPos + 11) && (VCOORD < (YPos + 13)))
                CSEL <= 12'h000; 
        //gun handle
        else if((HCOORD >= XPos + 13) && (HCOORD < (XPos + 15)) && (VCOORD >= YPos + 13) && (VCOORD < (YPos + 14)))
                CSEL <= 12'h000;
        else if((HCOORD >= XPos + 13) && (HCOORD < (XPos + 15)) && (VCOORD >= YPos + 16) && (VCOORD < (YPos + 17)))
                CSEL <= 12'h000; 
        //laser  
        else if((HCOORD >= laserPos1X) && (HCOORD < (laserPos1X + 7)) && (VCOORD >= laserPos1Y) && (VCOORD <(laserPos1Y + 2)))
                CSEL <= 12'hF00;
        //lser2
     
        else if((HCOORD >= laserPos2X) && (HCOORD < (laserPos2X + 7)) && (VCOORD >= laserPos2Y) && (VCOORD <(laserPos2Y + 2)))
                CSEL <= 12'hF00;   
        //laser3
        //else if((HCOORD >= XPos + 22) && (HCOORD < (XPos + 29)) && (VCOORD >= YPos+11) && (VCOORD < (YPos + 13)) && (laser == 3))
                //CSEL <= 12'hF00;
        else if((HCOORD >= laserPos3X) && (HCOORD < (laserPos3X + 7)) && (VCOORD >= laserPos3Y) && (VCOORD <(laserPos3Y + 2)))
                CSEL <= 12'hF00; 
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////PLAYER TWO///////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                                       
         //hair
        /*else if((HCOORD >= XPos2) && (HCOORD < (XPos2 - 10))&&(VCOORD >= YPos2)&&(VCOORD < (YPos2 - 2)))
            CSEL <= 12'h000;
        //forehead
        else if((HCOORD >= XPos2 - 2) && (HCOORD < (XPos2 - 10)) && (VCOORD >= YPos2-2) && (VCOORD < (YPos2 - 4)))
            CSEL <= 12'hFA5;
        //hair
        else if((HCOORD >= XPos2) && (HCOORD < (XPos2 - 2)) && (VCOORD >= YPos2-2) && (VCOORD < (YPos2 - 5)))
            CSEL <= 12'h000; 
       //head 
        else if((HCOORD >= XPos2 - 2) && (HCOORD < (XPos2 - 6)) && (VCOORD >= YPos2-4) && (VCOORD < (YPos2 - 5)))
             CSEL <= 12'hFA5;
        //eye
        else if((HCOORD >= XPos2 - 6) && (HCOORD < (XPos2 - 7)) && (VCOORD >= YPos2-4) && (VCOORD < (YPos2 - 5)))
             CSEL <= 12'hFFF; 
        //eye color           
        else if((HCOORD >= XPos2-7) && (HCOORD < (XPos2 - 8)) && (VCOORD >= YPos2-4) && (VCOORD < (YPos2 - 5)))
                CSEL <= 12'h00F; 
        //between eyes
        else if((HCOORD >= XPos2 - 8) && (HCOORD < (XPos2 - 10)) && (VCOORD >= YPos2-4) && (VCOORD < (YPos2 - 5)))
                CSEL <= 12'hFA5;  
        //face cheeks
        else if((HCOORD >= XPos2) && (HCOORD < (XPos2 - 10)) && (VCOORD >= YPos2-5) && (VCOORD < (YPos2 - 8)))
                CSEL <= 12'hFA5;  
        //jaw
        else if((HCOORD >= XPos2) && (HCOORD < (XPos2 - 6)) && (VCOORD >= YPos2-9) && (VCOORD < (YPos2 - 10)))
                CSEL <= 12'hFA5;  
        //mouth
        else if((HCOORD >= XPos2 - 6) && (HCOORD < (XPos2 - 10)) && (VCOORD >= YPos2-8) && (VCOORD < (YPos2 - 9)))
                CSEL <= 12'h000;
        //chin 
        else if((HCOORD >= XPos2) && (HCOORD < (XPos2 - 10)) && (VCOORD >= YPos2-8) && (VCOORD < (YPos2 - 10)))
                CSEL <= 12'hFA5; 
        //neck 
        else if((HCOORD >= XPos2 - 3) && (HCOORD < (XPos2 - 7)) && (VCOORD >= YPos2-10) && (VCOORD < (YPos2 - 12)))
                CSEL <= 12'hFA5;  
        //torso
        else if((HCOORD >= XPos2 - 1) && (HCOORD < (XPos2 - 10)) && (VCOORD >= YPos2-12) && (VCOORD < (YPos2 - 14)))
                CSEL <= 12'h00F;          
        //shoulder
        else if((HCOORD >= XPos2 - 1) && (HCOORD < (XPos2 - 4)) && (VCOORD >= YPos2-14) && (VCOORD < (YPos2 - 16)))
                CSEL <= 12'h00F;  
        //body
        else if((HCOORD >= XPos2 - 1) && (HCOORD < (XPos2 - 10)) && (VCOORD >= YPos2-16) && (VCOORD < (YPos2 - 23)))
                CSEL <= 12'h00F;
        //arm                                          
        else if((HCOORD >= XPos2 - 4) && (HCOORD < (XPos2 - 15)) && (VCOORD >= YPos2-14) && (VCOORD < (YPos2 - 16)))
                CSEL <= 12'hFA5;
        //legs 1                                         
        else if((HCOORD >= XPos2 - 3) && (HCOORD < (XPos2 - 5)) && (VCOORD >= YPos2-23) && (VCOORD < (YPos2 - 27)))
                CSEL <= 12'h000;  
       //lwg 2                                        
        else if((HCOORD >= XPos2 - 6) && (HCOORD < (XPos2 - 8)) && (VCOORD >= YPos2-23) && (VCOORD < (YPos2 - 27)))
                CSEL <= 12'h000;
        //gun barrel 
        else if((HCOORD >= XPos2 - 13) && (HCOORD < (XPos2 - 22)) && (VCOORD >= YPos2 - 11) && (VCOORD < (YPos2 - 13)))
                CSEL <= 12'h000; 
        //gun handle
        else if((HCOORD >= XPos2 - 13) && (HCOORD < (XPos2 - 15)) && (VCOORD >= YPos2 - 13) && (VCOORD < (YPos2 - 14)))
                CSEL <= 12'h000;
        else if((HCOORD >= XPos2 - 13) && (HCOORD < (XPos2 - 15)) && (VCOORD >= YPos2 - 16) && (VCOORD < (YPos2 - 17)))
                CSEL <= 12'h000; 
        //laser  
        //else if((HCOORD >= XPos2 + 22) && (HCOORD < (XPos2 + 29)) && (VCOORD >= YPos+11) && (VCOORD < (YPos + 13)) )
        //        CSEL <= 12'hF00;
        else if((HCOORD >= laserPos1X) && (HCOORD < (laserPos1X + 7)) && (VCOORD >= laserPos1Y) && (VCOORD <(laserPos1Y + 2)))
                CSEL <= 12'hF00;
        //lser2
        //else if((HCOORD >= XPos + 22) && (HCOORD < (XPos + 29)) && (VCOORD >= YPos+11) && (VCOORD < (YPos + 13)) && (laser == 2))
               // CSEL <= 12'hF00;
        else if((HCOORD >= laserPos2X) && (HCOORD < (laserPos2X + 7)) && (VCOORD >= laserPos2Y) && (VCOORD <(laserPos2Y + 2)))
                CSEL <= 12'hF00;   
        //laser3
        //else if((HCOORD >= XPos + 22) && (HCOORD < (XPos + 29)) && (VCOORD >= YPos+11) && (VCOORD < (YPos + 13)) && (laser == 3))
                //CSEL <= 12'hF00;
        else if((HCOORD >= laserPos3X) && (HCOORD < (laserPos3X + 7)) && (VCOORD >= laserPos3Y) && (VCOORD <(laserPos3Y + 2)))
                CSEL <= 12'hF00; */                                                                                                                                   
        else
            CSEL <= 12'hFFF;
    end

always@(posedge CLK or negedge ARST_L)
    begin
        if(ARST_L == 1'b0)
        begin
            jump <= 1'b1;
        end
        else if(jumpcount == 3)
        begin
            jump <= 1'b0;
        end
        else
        begin
            jump <= 1'b1;
        end
        
    end

always@(posedge CLK or negedge ARST_L)
    begin
        if(ARST_L == 1'b0)
        begin
            laserEN <= 1'b1;
        end
        else if(laserCount == 4)
        begin
            laserEN <= 1'b0;
        end
        else
        begin
            laserEN <= 1'b1;
        end
        
    end
        
        
always@(posedge CLK or negedge ARST_L)
    begin
        if(ARST_L == 1'b0)
        begin
            yspeed_i <= 0;
            xspeed_i <= 0;
            jumpcount <= 0;
            laserCount <= 0;
            
            //yspeed2_i <= 0;
            //xspeed_i <= 0;
            //jumpcount2<= 0;
            //laserCount2 <= 0;
        end
        else if((KBCODE == 8'h1D) && (KBSTROBE == 1'b1) && (col_N == 1'b0) && (col_S == 1'b0) && (col_W == 1'b0) && (col_E == 1'b0) && (jump == 1'b1))
            begin
                yspeed_i <= yspeed_i - 10;
                jumpcount <= jumpcount + 1;
            end
        else if((YPos <= 418)&&(refreshSlow == 1'b1)&& (KBSTROBE == 1'b0) )
            begin 
                yspeed_i <= yspeed_i + 1;
            end
        else if((YPos >= 419)&& (refreshSlow == 1'b1)&&(KBSTROBE == 1'b0))
            begin
                yspeed_i <= 0;
                jumpcount <= 0;
            end
        else if((col_Elaser1 == 1'b1) && (KBSTROBE == 1'b0))
            begin
                laserCount <= 0;
            end
        else if((KBCODE == 8'h23) && (KBSTROBE == 1'b1) && (moveleft == 1'b1 )) //stop going left
            begin
                xspeed_i <= 0;
                moveleft <= 1'b0;
            end
        else if((KBCODE == 8'h1C) && (KBSTROBE == 1'b1) && (moveright == 1'b1) ) //stop going right
            begin
                xspeed_i <= 0;
                moveright <= 1'b0;
            end
        else if((KBCODE == 8'h23) && (KBSTROBE == 1'b1)) //right
            begin
                xspeed_i <= 3;
                moveright <= 1'b1;
            end
        else if((KBCODE == 8'h1C) && (KBSTROBE == 1'b1)) //left
            begin
                xspeed_i <= -3;
                moveleft <= 1'b1;
            end
        else if((KBCODE == 8'h29) && (KBSTROBE == 1'b1) && (laserCount == 0) && (laserEN == 1'b1))
            begin
                laser <= 1;
                laserCount <= laserCount + 1;
                
            end
        else if((KBCODE == 8'h29) && (KBSTROBE == 1'b1) && (laserCount == 1) && (laserEN ==1'b1))
            begin
                laserCount <= laserCount + 1;
                laser <= 2;
                laser2Wait <= 1'b1;
            end
        else if((KBCODE == 8'h29) && (KBSTROBE == 1'b1) && (laserCount == 2)&& (laserEN == 1'b1))
            begin
                laserCount <= laserCount + 1;
                laser <= 3;
                laser3Wait <= 1'b1;
            end 
        ////////////////////////////////////////////PLAYER TWO//////////////////////////////////
        /*else if((KBCODE == 8'h75) && (KBSTROBE == 1'b1))//up
            begin
                yspeed2_i <= yspeed2_i - 10;
                jumpcount2 <= jumpcount2 + 1;
            end
        else if((YPos2 <= 418)&&(refreshSlow == 1'b1)&& (KBSTROBE == 1'b0) )
            begin 
                yspeed2_i <= yspeed2_i + 1;
            end
        else if((YPos2 >= 419)&& (refreshSlow == 1'b1)&&(KBSTROBE == 1'b0))
            begin
                yspeed2_i <= 0;
                jumpcount2 <= 0;
            end 
        else if((KBCODE == 8'h74) && (KBSTROBE == 1'b1) && (moveleft2 == 1'b1 )) //stop going left
            begin
                xspeed2_i <= 0;
                moveleft2 <= 1'b0;
            end
        else if((KBCODE == 8'h6B) && (KBSTROBE == 1'b1) && (moveright2 == 1'b1) ) //stop going right
            begin
                xspeed2_i <= 0;
                moveright2 <= 1'b0;
            end       
        else if((KBCODE == 8'h6B) && (KBSTROBE == 1'b1))//left
            begin
                xspeed2_i <= 3;
                moveright2 <= 1'b1;
            end 
        else if((KBCODE == 8'h74) && (KBSTROBE == 1'b1))//right
            begin
                xspeed2_i <= -3;
                moveleft2 <= 1'b1;            
            end */                                                
        else if((refresh == 1'b1))
            begin
                laser <= 0;
                
            end
        else
        ;
           
    end        

always@(posedge CLK)
    begin 
        if(ARST_L == 1'b0)
        begin
            count_i <= 0;
            refresh <= 1'b0;
        end
        else if(count_i == 250000)
        begin
            count_i <= 0;
            refresh <= 1'b1;
        end
        else
        begin
            count_i <= count_i + 1;
            refresh <= 1'b0;
        end
    end

//laser speed
always @(posedge CLK or negedge ARST_L)
    begin
        if(ARST_L == 1'b0)
            begin
                laserPos1X <= 0;
                laserPos1Y <= 0; 
            end
        else if(laser == 1)
            begin
                laserPos1X <= (XPos + 22);  
                laserPos1Y <= (YPos + 11);
            end
        else if(laser == 2)
            begin
                laserPos2X <= (XPos + 22);  
                laserPos2Y <= (YPos + 11);
            end
        else if(laser == 3)
            begin
                laserPos3X <= (XPos + 22);  
                laserPos3Y <= (YPos + 11);
            end   
        
        else if((refresh == 1'b1)&&(col_Elaser1 == 1'b0)&&(col_Elaser2 == 1'b0) && (col_Elaser3 == 1'b0))// && (shieldCol == 1'b0))
            begin
                laserPos1X <= laserPos1X + 5;
                laserPos1Y <= laserPos1Y;
                laserPos2X <= laserPos2X + 5;
                laserPos2Y <= laserPos2Y;
                laserPos3X <= laserPos3X + 5;
                laserPos3Y <= laserPos3Y;
            end
        else if((col_Elaser1 == 1'b1))
            begin
                laserPos1X <= 0;
                laserPos1Y <= 0;
            end     
        else if((col_Elaser2 == 1'b1))
            begin
                laserPos2X <= 0;
                laserPos2Y <= 0;
            end
        else if((col_Elaser3 == 1'b1))
            begin
                laserPos3X <= 0;
                laserPos3Y <= 0;       
            end   
        else 
            ;
     end       
        
            
always@(posedge CLK)
        begin
            if(ARST_L == 1'b0)
            begin
                count2_i <= 0;
                refreshSlow <= 1'b0;
            end
            else if(count2_i == 1000000)
            begin
                count2_i <= 0;
                refreshSlow <= 1'b1;
            end
            else
            begin
                count2_i <= count2_i + 1;
                refreshSlow <= 1'b0;
            end
        end          
       

always @(posedge CLK or negedge ARST_L)
    begin
        if(ARST_L == 1'b0)
        begin
            YPos <= 239;
            XPos <= 319;
            //YPos2 <= 400;
            //XPos2 <= 319;
        end
        else if((refresh == 1'b1) && (col_N == 0) && (col_S == 0) && (col_W == 0) && (col_E == 0) && (floor == 0))
        begin
            YPos <= YPos + yspeed_i;
            XPos <= XPos + xspeed_i;
            //YPos2 <= YPos2 + yspeed2_i;
            //XPos2 <= XPos2 + xspeed2_i;
        end
        else if((col_N == 1) && (refresh == 1'b1))
        begin
            YPos <= 11;
            
        end
        else if((col_S == 1) && (refresh == 1'b1))
        begin
            YPos <= 420;
        end
        else if((col_W == 1) && (refresh == 1'b1))
        begin
            XPos <= 11;
        end
        else if((col_E == 1) && (refresh == 1'b1))
        begin
            XPos <= 629;
        end
        else if((floor == 1) && (refresh == 1'b1))
        begin
            YPos <= 419;
        end
        
        
        else ;
    end


endmodule
