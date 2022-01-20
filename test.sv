`timescale 1ns/1ps

module test();

logic clk = 1'b0;
logic resetN = 1'b0;
logic fifoWrEn = 1'b0;
logic fifoRdEn = 1'b0;
logic [7:0] fifoWrData;
logic [7:0] fifoRdData;
logic fifoFull;
logic fifoEmpty;
logic [3:0] fifoDataCount;

fifo #(.FIFO_WIDTH(8), .FIFO_DEPTH(8)) F1(
.clk(clk),
.resetN(resetN),
.fifoWrEn(fifoWrEn),
.fifoRdEn(fifoRdEn),
.fifoWrData(fifoWrData),
.fifoRdData(fifoRdData),
.fifoFull(fifoFull),
.fifoEmpty(fifoEmpty),
.fifoDataCount(fifoDataCount)
);

task RESET;
resetN = 1'b0;
fifoWrEn = 1'b0;
fifoRdEn = 1'b0;
endtask

task READ;
resetN = 1'b1;
fifoWrEn = 1'b0;
fifoRdEn = 1'b1;
endtask

task WRITE;
resetN = 1'b1;
fifoWrEn = 1'b1;
fifoRdEn = 1'b0;
fifoWrData = $urandom_range(0,255);
endtask


initial forever #5 clk = ~clk;

initial begin
	RESET();
	#20 WRITE();
	#10 WRITE();
	#10 WRITE();
	#10 WRITE();
	#10 WRITE();
	#10 WRITE();
	#10 WRITE();
	#10 WRITE();
	#10 WRITE();
	#10 READ();
	#10 READ();
	#10 READ();
	#10 READ();
	#10 READ();
	#10 READ();
	#10 READ();
	#10 READ();
	#10 READ();
	#10 WRITE();
	#10 WRITE();
	#10 WRITE();
	#10 RESET();
	#10 READ();
	#10 WRITE();
	#30 $finish;
end

endmodule