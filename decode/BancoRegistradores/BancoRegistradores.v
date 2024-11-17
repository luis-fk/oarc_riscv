module BancoRegistradores #(parameter BITS = 64) (
    Ra, Rb, clk, We, din, Rw, douta, doutb
);
    
    input clk;
    input [4:0] Ra;
    input [4:0] Rb;
    input [4:0] Rw;
    input We;
    input [BITS-1:0] din;
    output [BITS-1:0] douta;
    output [BITS-1:0] doutb;

    wire [31:0] load;
    wire [31:0][BITS-1:0] dout;

    /* Codificador */
    Codificador Encoder(.Rw(Rw), .We(We), .load(load));

    /* 32 Registradores */
    RegistradorZero x0(.out(dout[0])); //Registrador padrão em zero;
    Registrador x1(.clk(clk), .load(load[1]), .in(din), .out(dout[1]));
    Registrador x2(.clk(clk), .load(load[2]), .in(din), .out(dout[2]));
    Registrador x3(.clk(clk), .load(load[3]), .in(din), .out(dout[3]));
    Registrador x4(.clk(clk), .load(load[4]), .in(din), .out(dout[4]));
    Registrador x5(.clk(clk), .load(load[5]), .in(din), .out(dout[5]));
    Registrador x6(.clk(clk), .load(load[6]), .in(din), .out(dout[6]));
    Registrador x7(.clk(clk), .load(load[7]), .in(din), .out(dout[7]));
    Registrador x8(.clk(clk), .load(load[8]), .in(din), .out(dout[8]));
    Registrador x9(.clk(clk), .load(load[9]), .in(din), .out(dout[9]));
    Registrador x10(.clk(clk), .load(load[10]), .in(din), .out(dout[10]));
    Registrador x11(.clk(clk), .load(load[11]), .in(din), .out(dout[11]));
    Registrador x12(.clk(clk), .load(load[12]), .in(din), .out(dout[12]));
    Registrador x13(.clk(clk), .load(load[13]), .in(din), .out(dout[13]));
    Registrador x14(.clk(clk), .load(load[14]), .in(din), .out(dout[14]));
    Registrador x15(.clk(clk), .load(load[15]), .in(din), .out(dout[15]));
    Registrador x16(.clk(clk), .load(load[16]), .in(din), .out(dout[16]));
    Registrador x17(.clk(clk), .load(load[17]), .in(din), .out(dout[17]));
    Registrador x18(.clk(clk), .load(load[18]), .in(din), .out(dout[18]));
    Registrador x19(.clk(clk), .load(load[19]), .in(din), .out(dout[19]));
    Registrador x20(.clk(clk), .load(load[20]), .in(din), .out(dout[20]));
    Registrador x21(.clk(clk), .load(load[21]), .in(din), .out(dout[21]));
    Registrador x22(.clk(clk), .load(load[22]), .in(din), .out(dout[22]));
    Registrador x23(.clk(clk), .load(load[23]), .in(din), .out(dout[23]));
    Registrador x24(.clk(clk), .load(load[24]), .in(din), .out(dout[24]));
    Registrador x25(.clk(clk), .load(load[25]), .in(din), .out(dout[25]));
    Registrador x26(.clk(clk), .load(load[26]), .in(din), .out(dout[26]));
    Registrador x27(.clk(clk), .load(load[27]), .in(din), .out(dout[27]));
    Registrador x28(.clk(clk), .load(load[28]), .in(din), .out(dout[28]));
    Registrador x29(.clk(clk), .load(load[29]), .in(din), .out(dout[29]));
    Registrador x30(.clk(clk), .load(load[30]), .in(din), .out(dout[30]));
    Registrador x31(.clk(clk), .load(load[31]), .in(din), .out(dout[31]));

    /* Multiplexador A */
    Mux32x64bits MA(.din(dout), .s(Ra), .dout(douta));
    /* Multiplexador B */
    Mux32x64bits MB(.din(dout), .s(Rb), .dout(doutb));


endmodule