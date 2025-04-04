module cnt3_1(clk, reset, enable, cnt11, cnt12, cnt13, cnt21, cnt22, cnt23);

    input clk, reset, enable;
    output cnt11, cnt12, cnt13, cnt21, cnt22, cnt23;
    reg [2:0] cnt_int;

    always @(posedge clk)
        if(reset)
            cnt_int <= 3'b0;
        else
            if(enable)
                cnt_int <= cnt_int + 1;

    assign cnt11 = (cnt_int == 3'b110);
    assign cnt12 = (cnt_int == 3'b010);
    assign cnt13 = (cnt_int == 3'b001);
    assign cnt21 = (cnt_int == 3'b100);
    assign cnt22 = (cnt_int == 3'b011);
    assign cnt23 = (cnt_int == 3'b010);
endmodule

module cnt3_2(clk, reset, enable, cnt21, cnt22, cnt23);

    input clk, reset, enable;
    output cnt21, cnt22, cnt23;
    reg [2:0] cnt_int;

    always @(posedge clk)
        if(reset)
            cnt_int <= 3'b0;
        else
            if(enable)
                cnt_int <= cnt_int + 1;

    assign cnt21 = (cnt_int == 3'b100);
    assign cnt22 = (cnt_int == 3'b011);
    assign cnt23 = (cnt_int == 3'b010);
endmodule

module RSHL(clk, reset, pl, di, dot, fshl);
    input clk, reset, pl, fshl;
    input [7:0] di;
    output reg[15:0] dot;

    always@(posedge clk)
        casex({reset, pl, fshl})
            3'b1xx:
                begin
                    dot = 16'b0;
                end
            3'b01x:
                begin
                    dot[15:8] = 8'b0;
                    dot[7:0] = di;
                end
            3'b001:
                begin
                    dot[15:1] = dot[14:0];
                    dot[0] = 1'b0;
                end
        endcase
endmodule

module fsm(clk, reset, start, x0, y0, fcnt, wr, out);
    input clk, x0, y0, wr, start, reset;
    input [5:0] fcnt;

    output reg [11:0] out;

    reg [5:0] cs, ns;

    parameter s00 = 6'b000000;
    parameter s01 = 6'b000001;
    parameter s02 = 6'b000010;
    parameter s03 = 6'b000011;
    parameter s04 = 6'b000100;
    parameter s05 = 6'b000101;
    parameter s06 = 6'b000110;
    parameter s07 = 6'b000111;

    parameter s08 = 6'b001000;
    parameter s09 = 6'b001001;
    parameter s10 = 6'b001010;
    parameter s11 = 6'b001011;
    parameter s12 = 6'b001100;
    parameter s13 = 6'b001101;
    parameter s14 = 6'b001110;
    parameter s15 = 6'b001111;

    parameter s16 = 6'b010000;
    parameter s17 = 6'b010001;
    parameter s18 = 6'b010010;
    parameter s19 = 6'b010011;
    parameter s20 = 6'b010100;
    parameter s21 = 6'b010101;
    parameter s22 = 6'b010110;
    parameter s23 = 6'b010111;

    parameter s24 = 6'b011000;
    parameter s25 = 6'b011001;
    parameter s26 = 6'b011010;
    parameter s27 = 6'b011011;
    parameter s28 = 6'b011100;
    parameter s29 = 6'b011101;
    parameter s30 = 6'b011110;
    parameter s31 = 6'b011111;

    parameter s32 = 6'b100000;
    parameter s33 = 6'b100001;
    parameter s34 = 6'b100010;
    parameter s35 = 6'b100011;
    parameter s36 = 6'b100100;
    parameter s37 = 6'b100101;
    parameter s38 = 6'b100110;
    parameter s39 = 6'b100111;

    parameter s40 = 6'b101000;
    parameter s41 = 6'b101001;
    parameter s42 = 6'b101010;
   
    always @(posedge clk)
        if(reset)
            cs <= s00;
        else
            cs <= ns;

    always@(cs or start or x0 or y0 or fcnt or wr)
        casex({cs,start,x0,y0,fcnt,wr})
            16'b000000_0_xx_xxxxxx_x: ns = s00;
            16'b000000_1_xx_xxxxxx_x: ns = s01;
            16'b000001_x_xx_xxxxxx_x: ns = s02;
            16'b000010_x_1x_xxxxxx_x: ns = s03;
            16'b000010_x_0x_xxxxxx_x: ns = s13;

            // rez = y * b
            16'b000011_x_x1_xxxxxx_x: ns = s41;
            16'b000011_x_x0_xxxxxx_x: ns = s04;
            16'b000100_x_xx_xxxxxx_x: ns = s05;
            16'b000101_x_xx_xxxxxx_x: ns = s06;
            16'b000110_x_xx_xxxxxx_x: ns = s07;
            16'b000111_x_xx_0xxxxx_x: ns = s04;
            16'b000111_x_xx_1xxxxx_x: ns = s08;
            16'b001000_x_xx_x0xxxx_x: ns = s05;
            16'b001000_x_xx_x1xxxx_x: ns = s09;
            16'b001001_x_xx_xx0xxx_x: ns = s06;
            16'b001001_x_xx_xx1xxx_x: ns = s10;
            16'b001010_x_xx_xxxxxx_1: ns = s10;
            16'b001010_x_xx_xxxxxx_0: ns = s11;
            16'b001011_x_xx_xxxxxx_1: ns = s11;
            16'b001011_x_xx_xxxxxx_0: ns = s12;
            16'b001100_x_xx_xxxxxx_1: ns = s12;
            16'b001100_x_xx_xxxxxx_0: ns = s41;

            // rez = x * a
            16'b001101_x_x1_xxxxxx_x: ns = s14;
            16'b001101_x_x0_xxxxxx_x: ns = s23;
            16'b001110_x_xx_xxxxxx_x: ns = s15;
            16'b001111_x_xx_xxxxxx_x: ns = s16;
            16'b010000_x_xx_xxxxxx_x: ns = s17;
            16'b010001_x_xx_xxx0xx_x: ns = s14;
            16'b010001_x_xx_xxx1xx_x: ns = s18;
            16'b010010_x_xx_xxxx0x_x: ns = s15;
            16'b010010_x_xx_xxxx1x_x: ns = s19;
            16'b010011_x_xx_xxxxx0_x: ns = s16;
            16'b010011_x_xx_xxxxx1_x: ns = s20;
            16'b010100_x_xx_xxxxxx_1: ns = s20;
            16'b010100_x_xx_xxxxxx_0: ns = s21;
            16'b010101_x_xx_xxxxxx_1: ns = s21;
            16'b010101_x_xx_xxxxxx_0: ns = s22;
            16'b010110_x_xx_xxxxxx_1: ns = s22;
            16'b010110_x_xx_xxxxxx_0: ns = s41;

            // rez = x * a + y * b
            16'b010111_x_xx_xxxxxx_x: ns = s24;
            16'b011000_x_xx_xxxxxx_x: ns = s25;
            16'b011001_x_xx_xxxxxx_x: ns = s26;
            16'b011010_x_xx_xxx0xx_x: ns = s23;
            16'b011010_x_xx_xxx1xx_x: ns = s27;
            16'b011011_x_xx_xxxx0x_x: ns = s24;
            16'b011011_x_xx_xxxx1x_x: ns = s28;
            16'b011100_x_xx_xxxxx0_x: ns = s25;
            16'b011100_x_xx_xxxxx1_x: ns = s29;
            16'b011101_x_xx_xxxxxx_x: ns = s30;
            16'b011110_x_xx_xxxxxx_x: ns = s31;
            16'b011111_x_xx_xxxxxx_x: ns = s32;
            16'b100000_x_xx_0xxxxx_x: ns = s29;
            16'b100000_x_xx_1xxxxx_x: ns = s33;
            16'b100001_x_xx_x0xxxx_x: ns = s30;
            16'b100001_x_xx_x1xxxx_x: ns = s34;
            16'b100010_x_xx_xx0xxx_x: ns = s31;
            16'b100010_x_xx_xx1xxx_x: ns = s35;
            16'b100011_x_xx_xxxxxx_1: ns = s35;
            16'b100011_x_xx_xxxxxx_0: ns = s36;
            16'b100100_x_xx_xxxxxx_1: ns = s36;
            16'b100100_x_xx_xxxxxx_0: ns = s37;
            16'b100101_x_xx_xxxxxx_1: ns = s37;
            16'b100101_x_xx_xxxxxx_0: ns = s38;
            16'b100110_x_xx_xxxxxx_1: ns = s38;
            16'b100110_x_xx_xxxxxx_0: ns = s39;
            16'b100111_x_xx_xxxxxx_1: ns = s39;
            16'b100111_x_xx_xxxxxx_0: ns = s40;
            16'b101000_x_xx_xxxxxx_1: ns = s40;
            16'b101000_x_xx_xxxxxx_0: ns = s41;

            // return rez and restart
            16'b101001_x_xx_xxxxxx_x: ns = s42;
            16'b101010_0_xx_xxxxxx_x: ns = s42;
            16'b101010_1_xx_xxxxxx_x: ns = s00;
        endcase

    always@(cs or start or x0 or y0 or fcnt or wr)
        casex(cs)
            6'b000000: out = 12'b0_000000_000_00;
            6'b000001: out = 12'b1_000000_000_00;
            6'b000010: out = 12'b0_000000_000_00;

            //------------- CASE 1 -------------
            6'b000100: out = 12'b0_100000_000_00;
            6'b000101: out = 12'b0_010000_000_00;
            6'b000110: out = 12'b0_001000_000_00;

            6'b000111: out = 12'b0_000000_000_00;

            6'b001010: out = 12'b0_000000_011_10;
            6'b001011: out = 12'b0_000000_100_10;
            6'b001100: out = 12'b0_000000_101_10;

            //------------- CASE 2 -------------
            6'b001110: out = 12'b0_000100_000_00;
            6'b001111: out = 12'b0_000010_000_00;
            6'b010000: out = 12'b0_000001_000_00;

            6'b010001: out = 12'b0_000000_000_00;

            6'b010100: out = 12'b0_000000_000_10;
            6'b010101: out = 12'b0_000000_001_10;
            6'b010110: out = 12'b0_000000_010_10;

            //------------- CASE 3 -------------
            6'b010111: out = 12'b0_000100_000_00;
            6'b011000: out = 12'b0_000010_000_00;
            6'b011001: out = 12'b0_000001_000_00;

            6'b011010: out = 12'b0_000000_000_00;

            6'b011101: out = 12'b0_100000_000_00;
            6'b011110: out = 12'b0_010000_000_00;
            6'b011111: out = 12'b0_001000_000_00;

            6'b100000: out = 12'b0_000000_000_00;

            6'b100011: out = 12'b0_000000_000_10;
            6'b100100: out = 12'b0_000000_001_10;
            6'b100101: out = 12'b0_000000_010_10;
            6'b100110: out = 12'b0_000000_011_10;
            6'b100111: out = 12'b0_000000_100_10;
            6'b101000: out = 12'b0_000000_101_10;

            //-------------- PRINT -------------
            6'b101001: out = 12'b0_000000_000_01;
        endcase
endmodule

module sum(clk, reset, plrez, in, out);
    input clk, reset, plrez;
    input [15:0] in;
    output reg [15:0] out;

    always@(posedge clk)
        casex({reset, plrez})
            2'b1x: out = 16'b0;
            2'b01: out = out + in;
        endcase
endmodule

module reg8(clk, pl, reset, di, dot, di_0);
input clk, reset, pl;
    input [7:0] di;
    output reg [7:0] dot;
    output di_0;
   
    always @(posedge clk)
      if(reset)
        dot <= 8'b0;
      else
        if(pl)
          dot <= di;
    assign di_0 = (di == 8'b0);
endmodule

module reg16(clk, pl, reset, di, dot);
    input clk, reset, pl;
    input [15:0] di;
    output reg [15:0] dot;
   
    always @(posedge clk)
      if(reset)
        dot <= 16'b0;
      else
        if(pl)
          dot <= di;
endmodule

module mux_1_6(reg11, reg12, reg13, reg21, reg22, reg23, sel, out);

    input [15:0] reg11, reg12, reg13, reg21, reg22, reg23;
    input [2:0] sel;
    output reg [15:0] out;

    always @(sel)
    case(sel)
        3'b000: out = reg11;
        3'b001: out = reg12;
        3'b010: out = reg13;
        3'b011: out = reg21;
        3'b100: out = reg22;
        3'b101: out = reg23;
    endcase

endmodule

module top_module(x, y, out, start, pl, reset, clk_100MHz);
    input reset, pl, clk_100MHz, start;
    input [7:0] x;
    input [7:0] y;

    wire [15:0] sumator;

    wire [15:0] reg11, reg12, reg13, reg21, reg22, reg23;
    wire [7:0] reg_x, reg_y;
    wire x0, y0;
    reg enable1, enable2;
    wire [11:0] cmd;
    wire [5:0] fcnt;
    wire [15:0] out_mux;

    wire [15:0] dot11, dot12, dot13, dot21, dot22, dot23;
    reg [15:0] aux;
    reg val = 1'b1;
   
    always@(posedge clk_100MHz)
        aux = 16'b11111111_00000000;
   
    output [15:0] out;

    reg8(clk_100MHz, pl, reset, x, reg_x, x0);
    reg8(clk_100MHz, pl, reset, y, reg_y, y0);
    reg16(clk_100MHz, val, reset, aux, out);


    fsm(clk_100MHz, reset, start, x0, y0, fcnt, wr, cmd);

    always @(cmd [4] or cmd[5] or cmd[6])
    casex({cmd[4], cmd[5], cmd[6]})
        3'b1xx,3'bx1x, 3'bxx1: enable1 <= 1'b1;
        default: enable1 <= 1'b0;
    endcase
    always @(cmd[1] or cmd[2] or cmd[3])
    casex({cmd[1], cmd[2], cmd[3]})
        3'b1xx,3'bx1x, 3'bxx1: enable2 <= 1'b1;
        default: enable2 <= 1'b0;
    endcase
 
    cnt3_1(clk_100MHz, start, enable1, fcnt[0], fcnt[1], fcnt[2]);
    cnt3_2(clk_100MHz, start, enable2, fcnt[3], fcnt[4], fcnt[5]);

    RSHL(clk_100MHz, reset, cmd[0], reg_x, dot11, cmd[1]);
    RSHL(clk_100MHz, reset, cmd[0], reg_x, dot12, cmd[2]);
    RSHL(clk_100MHz, reset, cmd[0], reg_x, dot13, cmd[3]);

    RSHL(clk_100MHz, reset, cmd[0], reg_y, dot21, cmd[4]);
    RSHL(clk_100MHz, reset, cmd[0], reg_x, dot22, cmd[5]);
    RSHL(clk_100MHz, reset, cmd[0], reg_x, dot23, cmd[6]);


    mux_1_6(dot11, dot12, dot13, dot21, dot22, dot23, cmd[9:7], out_mux);
    sum(clk_100MHz, cmd[0], plrez, in, sumator);

    reg16(clk_100MHz, out[0], reset, sumator, out);

endmodule