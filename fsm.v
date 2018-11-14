//------------------------------------------------------------------------
// Finite State Machine
//------------------------------------------------------------------------
`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

module fsm (
input clk,
input [5:0] opcode,
input [5:0] funct,
output reg PCWE, IorD, MemWE, IRWrite, RegSr,
output reg RegWE, ALUSrcA, Branch, BEQSel,
output reg [2:0] ALUOP,
output reg [1:0] RegDest, MemToReg, ALUSrcB, PCSrc
);
// state constants
parameter Fetch = 5'd0;
parameter Decode = 5'd1;
parameter MemAddr = 5'd2;
parameter MemRead = 5'd3;
parameter MemWriteBack = 5'd4;
parameter MemWrite = 5'd5;
parameter Execute = 5'd6;
parameter ALUWriteBack = 5'd7;
parameter BEQ = 5'd8;
parameter BNE = 5'd9;
parameter ADDIExecute = 5'd10;
parameter ADDIWriteBack = 5'd11;
parameter Jump = 5'd12;
parameter JR = 5'd13;
parameter JALWriteBack = 5'd14;
parameter JALJump = 5'd15;

// state variables
reg[4:0] state;
reg count;

// map state to output
always @ (posedge clk)
begin
  if (state === 5'dx) begin
    state <= Fetch;
  end
  case(state)
    Fetch : begin
      if (opcode === 6'dx) begin
        state <= Fetch;
        PCWE <= 1;
        IorD <= 0;
        MemWE <= 0;
        IRWrite <= 0;
        RegDest <= 2'd0;
        RegSr <= 1;
        MemToReg <= 2'd0;
        RegWE <= 0;
        ALUSrcA <= 0;
        ALUSrcB <= 2'd1;
        ALUOP <= `ADD;
        PCSrc <= 2'd0;
        Branch <= 0;
        BEQSel <= 0;
        count <= 0;
      end else begin
        state <= Decode;
        PCWE <= 0;
        IorD <= 0;
        MemWE <= 0;
        IRWrite <= 1;
        RegDest <= 2'd0;
        RegSr <= 1;
        MemToReg <= 2'd0;
        RegWE <= 0;
        ALUSrcA <= 0;
        ALUSrcB <= 2'd3;
        ALUOP <= `ADD;
        PCSrc <= 2'd0;
        Branch <= 0;
        BEQSel <= 0;
        count <= 0;
      end
    end
    Decode : begin
      if (count == 0) begin
        state <= Decode;
        PCWE <= 0;
        IorD <= 0;
        MemWE <= 0;
        IRWrite <= 1;
        RegDest <= 2'd0;
        RegSr <= 1;
        MemToReg <= 2'd0;
        RegWE <= 0;
        ALUSrcA <= 0;
        ALUSrcB <= 2'd3;
        ALUOP <= `ADD;
        PCSrc <= 2'd0;
        Branch <= 0;
        BEQSel <= 0;
        count <= 1;
      end else begin
        if (opcode == 6'h23 || opcode == 6'h2b) begin //lw +sw
          state <= MemAddr;
          PCWE <= 0;
          IorD <= 0;
          MemWE <= 0;
          IRWrite <= 0;
          RegDest <= 2'd0;
          RegSr <= 1;
          MemToReg <= 2'd0;
          RegWE <= 0;
          ALUSrcA <= 1;
          ALUSrcB <= 2'd2;
          ALUOP <= `ADD;
          PCSrc <= 2'd0;
          Branch <= 0;
          BEQSel <= 0;
        end else if (opcode == 6'h0 && (funct == 6'h20 || funct == 6'h22 || funct == 6'h2a)) begin //r
          state <= Execute;
          PCWE <= 0;
          IorD <= 0;
          MemWE <= 0;
          IRWrite <= 0;
          RegDest <= 2'd0;
          RegSr <= 1;
          MemToReg <= 2'd0;
          RegWE <= 0;
          ALUSrcA <= 1;
          ALUSrcB <= 2'd0;
          if (funct == 6'h20) begin //add
            ALUOP <= `ADD;
          end else if (funct == 6'h22) begin //sub
            ALUOP <= `SUB;
          end else if (funct == 6'h2a) begin //slt
            ALUOP <= `SLT;
          end
          PCSrc <= 2'd0;
          Branch <= 0;
          BEQSel <= 0;
        end else if (opcode == 6'h5) begin //bne
          state <= BNE;
          PCWE <= 0;
          IorD <= 0;
          MemWE <= 0;
          IRWrite <= 0;
          RegDest <= 2'd0;
          RegSr <= 1;
          MemToReg <= 2'd0;
          RegWE <= 0;
          ALUSrcA <= 1;
          ALUSrcB <= 2'd0;
          ALUOP <= `SUB;
          PCSrc <= 2'd1;
          Branch <= 1;
          BEQSel <= 1;
        end else if (opcode == 6'h4) begin //beq
          state <= BEQ;
          PCWE <= 0;
          IorD <= 0;
          MemWE <= 0;
          IRWrite <= 0;
          RegDest <= 2'd0;
          RegSr <= 1;
          MemToReg <= 2'd0;
          RegWE <= 0;
          ALUSrcA <= 1;
          ALUSrcB <= 2'd0;
          ALUOP <= `SUB;
          PCSrc <= 2'd1;
          Branch <= 1;
          BEQSel <= 0;
        end else if (opcode == 6'h8 || opcode == 6'he) begin //addi+xori
          state <= ADDIExecute;
          PCWE <= 0;
          IorD <= 0;
          MemWE <= 0;
          IRWrite <= 0;
          RegDest <= 2'd0;
          RegSr <= 1;
          MemToReg <= 2'd0;
          RegWE <= 0;
          ALUSrcA <= 1;
          ALUSrcB <= 2'd2;
          if (opcode == 6'h8) begin
            ALUOP <= `ADD;
          end else if (opcode == 6'he) begin
            ALUOP <= `XOR;
          end
          PCSrc <= 2'd0;
          Branch <= 0;
          BEQSel <= 0;
        end else if (opcode == 6'h2) begin //jump
          state <= Jump;
          PCWE <= 1;
          IorD <= 0;
          MemWE <= 0;
          IRWrite <= 0;
          RegDest <= 2'd0;
          RegSr <= 1;
          MemToReg <= 2'd0;
          RegWE <= 0;
          ALUSrcA <= 0;
          ALUSrcB <= 2'd0;
          ALUOP <= `ADD;
          PCSrc <= 2'd2;
          Branch <= 0;
          BEQSel <= 0;
        end else if (opcode == 0 && funct == 6'h8) begin //jr
          state <= JR;
          PCWE <= 1;
          IorD <= 0;
          MemWE <= 0;
          IRWrite <= 0;
          RegDest <= 2'd0;
          RegSr <= 0;
          MemToReg <= 2'd0;
          RegWE <= 0;
          ALUSrcA <= 0;
          ALUSrcB <= 2'd0;
          ALUOP <= `ADD;
          PCSrc <= 2'd3;
          Branch <= 0;
          BEQSel <= 0;
        end else if (opcode == 6'h3) begin //jal
          state <= JALWriteBack;
          PCWE <= 0;
          IorD <= 0;
          MemWE <= 0;
          IRWrite <= 0;
          RegDest <= 2'd2;
          RegSr <= 1;
          MemToReg <= 2'd2;
          RegWE <= 1;
          ALUSrcA <= 0;
          ALUSrcB <= 2'd1;
          ALUOP <= `ADD;
          PCSrc <= 2'd0;
          Branch <= 0;
          BEQSel <= 0;
        end
      end
    end
    MemAddr : begin
      if (opcode == 6'h23) begin //lw
        state <= MemRead;
        PCWE <= 0;
        IorD <= 1;
        MemWE <= 0;
        IRWrite <= 0;
        RegDest <= 2'd0;
        RegSr <= 1;
        MemToReg <= 2'd0;
        RegWE <= 0;
        ALUSrcA <= 0;
        ALUSrcB <= 2'd0;
        ALUOP <= `ADD;
        PCSrc <= 2'd0;
        Branch <= 0;
        BEQSel <= 0;
      end else begin
        state <= MemWrite;
        PCWE <= 0;
        IorD <= 1;
        MemWE <= 1;
        IRWrite <= 0;
        RegDest <= 2'd0;
        RegSr <= 1;
        MemToReg <= 2'd0;
        RegWE <= 0;
        ALUSrcA <= 0;
        ALUSrcB <= 2'd0;
        ALUOP <= `ADD;
        PCSrc <= 2'd0;
        Branch <= 0;
        BEQSel <= 0;
      end
    end
    MemRead : begin
      state <= MemWriteBack;
      PCWE <= 0;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 0;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd1;
      RegWE <= 1;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd0;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
    end
    MemWriteBack: begin
      state <= Fetch;
      PCWE <= 1;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 1;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 0;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd1;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
      count <= 0;
    end
    MemWrite : begin
      state <= Fetch;
      PCWE <= 1;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 1;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 0;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd1;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
      count <= 0;
    end
    Execute : begin
      state <= ALUWriteBack;
      PCWE <= 0;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 0;
      RegDest <= 2'd1;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 1;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd0;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
    end
    ALUWriteBack : begin
      state <= Fetch;
      PCWE <= 1;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 1;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 0;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd1;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
      count <= 0;
    end
    BEQ : begin
      state <= Fetch;
      PCWE <= 1;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 1;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 0;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd1;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
      count <= 0;
    end
    BNE : begin
      state <= Fetch;
      PCWE <= 1;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 1;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 0;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd1;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
      count <= 0;
    end
    ADDIExecute : begin
      state <= ADDIWriteBack;
      PCWE <= 0;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 0;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 1;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd0;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
      count <= 0;
    end
    ADDIWriteBack : begin
      state <= Fetch;
      PCWE <= 1;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 1;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 0;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd1;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
      count <= 0;
    end
    Jump : begin
      state <= Decode;
      PCWE <= 0;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 1;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 0;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd1;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
      count <= 0;
    end
    JR : begin
      state <= Decode;
      PCWE <= 0;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 1;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 0;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd1;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
      count <= 0;
    end
    JALWriteBack : begin
      state <= JALJump;
      PCWE <= 1;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 0;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 0;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd0;
      ALUOP <= `ADD;
      PCSrc <= 2'd2;
      Branch <= 0;
      BEQSel <= 0;
    end
    JALJump : begin
      state <= Decode;
      PCWE <= 0;
      IorD <= 0;
      MemWE <= 0;
      IRWrite <= 1;
      RegDest <= 2'd0;
      RegSr <= 1;
      MemToReg <= 2'd0;
      RegWE <= 0;
      ALUSrcA <= 0;
      ALUSrcB <= 2'd1;
      ALUOP <= `ADD;
      PCSrc <= 2'd0;
      Branch <= 0;
      BEQSel <= 0;
      count <= 0;
    end
  endcase
end

endmodule
