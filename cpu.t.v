// `timescale 1 ns / 1 ps
`include "cpu.v"
`define DELAY 10000

module testCPU();
  reg clk; //Declare clock

  reg begintest = 0; //Set high to begin testing register file
  reg endtest = 0; //Set high to signal test completion
  reg dutpassed = 1; //Indicates whether register file passed tests

  //Order of tests: ours (bleep_vim), dazedandconfused, jumpingfoxes, ninja, sree, storemoney
  wire[31:0] hanoi = 32'd270; //test 0
  wire[31:0] fib = 32'd58; //test 1
  wire[31:0] yeet = 32'd119; //test 2
  wire[31:0] test_1 = 32'hf; //test 3
  wire[31:0] test_3 = 32'd42; //test 4
  wire[31:0] slt = 32'd1; //test 5

  //Simple tests
  wire[31:0] branch_test = 32'd4; //test 6
  wire[31:0] jump_test = 32'd8; //test 7
  wire[31:0] simple_sl = 32'd3; //test 8
  wire[31:0] simple_test = 32'd4; //test 9
  wire[31:0] slt_test = 32'd1; //test 10
  wire[31:0] sw_test = 32'h13; //test 11

  //Instantiate dut
  cpu dut(.clk(clk));

  //Declare inputs
  reg [1023:0] mem_text_fn;
  reg[3:0] test_num;
  reg [1023:0] file_out;

//Set up clock
initial clk = 0;

always #100 clk=!clk;

//Read in the memory location
  initial begin
  if (! $value$plusargs("mem_text_fn=%s", mem_text_fn)) begin
	    $display("ERROR: memory location not provided. Provide +mem_text_fn=[path to .text memory image] argument");
	    $finish();
        end
//Read in the test number
  if (! $value$plusargs("test_num=%d", test_num)) begin
    $display("ERROR: Test name not specified. Provide +test_num=[test_num] argument");
    $finish();
    end
//Read in the vcd file we want to write to
    if (! $value$plusargs("file_out=%s", file_out)) begin
      $display("ERROR: Test file output (.vcd) not specified. Provide +file_out=[file_out] argument");
      $finish();
      end

      //Read into the datamemory
    $readmemh(mem_text_fn, dut.dm.mem,0);

    //Prep dumpfile
    $dumpfile(file_out);
    $dumpvars();

    $display("Starting test number (in binary): %b or %d", test_num, test_num);


    //Note beginning of test
    begintest = 1;
    #10000000;  //Wait a while to let the CPU do as it needs to
    dutpassed = 1;

    if(test_num == 0) begin //If we're test 0, check it against "hanoi"
      if(dut.rf.reg2.qout != hanoi) begin
      $display("Test failed: Tower of Hanoi answer unexpected; expected %b but got %b", hanoi, dut.rf.reg2.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg2.qout===32'bX) begin
      $display("Test (hanoi) is X");
      dutpassed = 0;
      end
    end

    if(test_num == 1) begin //If we're test 1, check against fibinacci
      if(dut.rf.reg2.qout != fib) begin
      $display("Test failed: Fibinacci answer unexpected; expected %b but got %b", fib, dut.rf.reg2.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg2.qout===32'bX) begin
      $display("Test (fib) is X");
      dutpassed = 0;
      end
    end
    if(test_num == 2) begin //If we're test 2, check against yeet
      if(dut.rf.reg8.qout != yeet) begin
      $display("Test failed: Yeet answer unexpected; expected %b but got %b", yeet, dut.rf.reg8.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg8.qout===32'bX) begin
      $display("Test (yeet) is X");
      dutpassed = 0;
      end
    end
    if(test_num == 3) begin //If we're test 3, check against test_1
      if(dut.rf.reg8.qout != test_1) begin
      $display("Test failed: test_1 answer unexpected; expected %b but got %b", test_1, dut.rf.reg8.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg8.qout===32'bX) begin
      $display("Test (test_1) is X");
      dutpassed = 0;
      end
    end
    if(test_num == 4) begin //If we're test 4, check against test_3
      if(dut.rf.reg11.qout != test_3) begin
      $display("Test failed: test_3 answer unexpected; expected %b but got %b", test_3, dut.rf.reg11.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg11.qout===32'bX) begin
      $display("Test (test_3) is X");
      dutpassed = 0;
      end
    end
    if(test_num == 5) begin //If we're test 5, check against slt
      if(dut.rf.reg2.qout != slt) begin
      $display("Test failed: Slt answer unexpected; expected %b but got %b", slt, dut.rf.reg2.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg2.qout===32'bX) begin
      $display("Test (slt) is X");
      dutpassed = 0;
      end
    end
    if(test_num== 6) begin
      if(dut.rf.reg2.qout != branch_test) begin
      $display("Test failed: branch_test answer unexpected; expected %b but got %b", branch_test, dut.rf.reg2.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg2.qout===32'bX) begin
      $display("Test (branch_test) is X");
      dutpassed = 0;
      end
    end
    if(test_num== 7) begin
      if(dut.rf.reg2.qout != jump_test) begin
      $display("Test failed: jump_test answer unexpected; expected %b but got %b", jump_test, dut.rf.reg2.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg2.qout===32'bX) begin
      $display("Test (jump_test) is X");
      dutpassed = 0;
      end
    end
    if(test_num== 8) begin
      if(dut.rf.reg2.qout != simple_sl) begin
      $display("Test failed: simple_sl answer unexpected; expected %b but got %b", simple_sl, dut.rf.reg2.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg2.qout===32'bX) begin
      $display("Test (simple_sl) is X");
      dutpassed = 0;
      end
    end
    if(test_num== 9) begin
      if(dut.rf.reg2.qout != simple_test) begin
      $display("Test failed: simple_test answer unexpected; expected %b but got %b", simple_test, dut.rf.reg2.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg2.qout===32'bX) begin
      $display("Test (simple_test) is X");
      dutpassed = 0;
      end
    end
    if(test_num== 10) begin
      if(dut.rf.reg2.qout != slt_test) begin
      $display("Test failed: slt_test answer unexpected; expected %b but got %b", test_num, dut.rf.reg2.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg2.qout===32'bX) begin
      $display("Test (slt_test) is X");
      dutpassed = 0;
      end
    end
    if(test_num== 11) begin
      if(dut.rf.reg2.qout != sw_test) begin
      $display("Test failed: sw_test answer unexpected; expected %b but got %b", sw_test, dut.rf.reg2.qout);
      dutpassed = 0;
      end
      if(dut.rf.reg2.qout===32'bX) begin
      $display("Test (sw_test) is X");
      dutpassed = 0;
      end
    end

    //Note if the device under test passed
    endtest = 1;
    $display("DUT passed? %b", dutpassed);
    $finish();
  end

endmodule
