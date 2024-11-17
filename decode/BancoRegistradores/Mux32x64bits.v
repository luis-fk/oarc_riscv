module Mux32x64bits #(parameter BITS = 64) (din, s, dout);

    input [31:0][BITS - 1:0] din;

    input [4:0] s;
    output [63:0] dout;

    assign dout = s == 0 ? din[0] :
                  s == 1 ? din[1] :
                  s == 2 ? din[2] :
                  s == 3 ? din[3] :
                  s == 4 ? din[4] :
                  s == 5 ? din[5] :
                  s == 6 ? din[6] :
                  s == 7 ? din[7] :
                  s == 8 ? din[8] :
                  s == 9 ? din[9] :
                  s == 10 ? din[10] :
                  s == 11 ? din[11] :
                  s == 12 ? din[12] :
                  s == 13 ? din[13] :
                  s == 14 ? din[14] :
                  s == 15 ? din[15] :
                  s == 16 ? din[16] :
                  s == 17 ? din[17] :
                  s == 18 ? din[18] :
                  s == 19 ? din[19] :
                  s == 20 ? din[20] :
                  s == 21 ? din[21] :
                  s == 22 ? din[22] :
                  s == 23 ? din[23] :
                  s == 24 ? din[24] :
                  s == 25 ? din[25] :
                  s == 26 ? din[26] :
                  s == 27 ? din[27] :
                  s == 28 ? din[28] :
                  s == 29 ? din[29] :
                  s == 30 ? din[30] :
                  din[31];

    
endmodule