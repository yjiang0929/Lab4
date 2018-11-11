// this is a cpu

`include "regfile.v"
`include "dataMemory.v"
`include "alu.v"
`include "mux.v"
`include "signExt.v"
`include "fsm.v"

module cpu(
	input clk
	// output reg[31:0] cpuout[1023:0]
);

	wire [31:0] Da, Db, Dw, dmOut, IorDout, regOutClk, aluRes, signImm, srcA, srcB, nextPc;
	wire zeroFlag pcEnable, beqFlag;


  //DFFs
	reg [31:0] pc;  // Program counter is registers; the last 2 bits are ignored because we always run words
	initial pc <=0; // Initialize at 0
	always @(posedge clk) if (pcEnable) begin pc <= nextPc; end// Update every clock cycle

  reg[31:0] instructionClk;
  initial instructionClk <= 0;
  always @(posedge clk) instructionClk <= dmOut;

  reg[31:0] dataClk;
  initial dataClk <= 0;
  always @(posedge clk) dataClk <= dmOut;

  reg[31:0] aluClk;
  initial aluClk <= 0;
  always @(posedge clk) aluClk <= aluRes;

  reg[31:0] daClk;
  initial daClk <= 0;
  always @(posedge clk) daClk <= Da;

  reg[31:0] dbClk;
  initial dbClk <= 0;
  always @(posedge clk) dbClk <= Db;


	// These are driven by the decoder
	wire PCWE, MemWE, IRWrite, RegWE, Branch, BEQSel, IorD, ALUSrcA, PCSrc, PCWE;
  wire[1:0] RegDest, MemToReg, ALUSrcB;
  wire[2:0] ALUOP;
  //Mux controllers
  wire RegSrc;


  wire [4:0] regIn1, regIn2, regIn3;

  regIn2 <= instructionClk[20:16];

  fsm fsm(.clk(clk), .opcode(instructionClk[31:26]), .funct(instructionClk[5:0]), .PCWE(PCWE), .IorD(IorD), .MemWE(MemWE), 
    .IRWrite(IRWrite), .RegSr(RegSrc), .RegWE(RegWE), .ALUSrcA(ALUSrcA), .Branch(Branch), .BEQSel(BEQSel),
    .ALUOP(ALUOP), .RegDest(RegDest), .MemToReg(MemToReg), .ALUSrcB(ALUSrcB), .PCSrc(PCSrc));

  mux2 iOrDmux(.in1(pc), .in2(aluClk), .out(IorDout), .select(IorD));

  dataMemory dm(.clk(clk), .regWE(MemWE), .dataAddr(IorDout), .dataIn(dbClk), .dataOut(dmOut));

  mux2 #(5) regSRCmux(.in1(5'b11111), .in2(instructionClk[25:21]), .out(regIn1), .select(RegSrc));

  mux3 #(5) regDestmux(.in1(instructionClk[20:16]), .in2(instructionClk[15:11]), .in3(5'b11111), .out(regIn3), .select(RegDest));

  mux3 memToRegmux(.in1(aluClk), .in2(dataClk), .in3(aluRes), .out(Dw), .select(MemToReg)); //aluRES = pc + 4

  regfile rf(.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), .ReadRegister1(regIn1), .ReadRegister2(regIn2), .WriteRegister(regIn3); .regWrite(RegWE), .clk(clk));

  mux2 aluSrcAmux(.in1(pc), .in2(daClk), .out(srcA), .select(ALUSrcA));

  signExt se(.in(instructionClk[15:0]), .out(signImm));

  wire [31:0] shiftSignImm <= {signImm[29:0], 2'b0};

  mux4 aluSrcBmux(.in1(dbClk), .in2(32'd4), .in3(signImm), .in4(shiftSignImm), .out(srcB), .select(ALUSrcB));

  alu alu(.result(aluRes), _, .zero(zeroFlag), _, .operandA(srcA), .operandB(srcB), .command(ALUOP));

  wire[31:0] concatInstruct <= {pc[31:28], instructionClk[25:0], 2'b0};

  mux4 pcSrcmux(.in1(aluRes), .in2(aluClk), .in3(concatInstruct), .in4(daClk), .out(nextPc), .select(PCSrc));

  mux2 #(1) beqSelmux(.in1(zeroFlag), .in2(!zeroFlag), .out(beqFlag), .select(BEQSel));

  wire temp = and(beqFlag, Branch);

  pcEnable = or(temp, PCWE);



endmodule
