module fifo #(parameter FIFO_WIDTH = 8, FIFO_DEPTH = 8)(
input clk,
input resetN,
input fifoWrEn,
input fifoRdEn,
input [FIFO_WIDTH-1:0] fifoWrData,
output [FIFO_WIDTH-1:0] fifoRdData,
output fifoFull,
output fifoEmpty,
output [$clog2(FIFO_DEPTH):0] fifoDataCount
);

// Internal write and read signal generation based on fifo full or not
logic wrEnInt, rdEnInt;

// pipline/elay the write data to match the internal write logic 
logic [FIFO_WIDTH-1:0]fifoWrDataP;

// data counter to declare fifo storage space
logic [$clog2(FIFO_DEPTH):0] dataCounter;

// fifo read and write validator
logic validFiFoWr,validFiFoRd;

// read and write pointer for fifo
logic [$clog2(FIFO_DEPTH)-1:0] rdPtr,wrPtr;

ram #(.MEM_WIDTH(FIFO_WIDTH), .MEM_DEPTH(FIFO_DEPTH)) R1(
.clk(clk),
.wrEn(wrEnInt),               // should be high for data to write on memory                    
.rdEn(rdEnInt),               // should be high for data to read from memory
.wrAddr(wrPtr),
.rdAddr(rdPtr),
.wrData(fifoWrDataP),
.rdData(fifoRdData)
);

// fifo read logic
always@(posedge clk) begin
	if(!resetN)
		rdEnInt <= 1'b0;
	else if(validFiFoRd)
		rdEnInt <= 1'b1;
	else
		rdEnInt <= 1'b0;
end

// fifo write logic
always@(posedge clk) begin
	if(!resetN)
		wrEnInt <= 1'b0;
	else if(validFiFoWr)
		wrEnInt <= 1'b1;
	else
		wrEnInt <= 1'b0;
end

// delay the write data to match the internal write logic
always@(posedge clk) begin
	fifoWrDataP <= fifoWrData;
end

// 
always@(posedge clk) begin
	if(!resetN)
		dataCounter = 1'b0;
	else if(validFiFoWr && !validFiFoRd)
		dataCounter = dataCounter + 1'b1;
	else if(validFiFoRd && !validFiFoWr)
		dataCounter = dataCounter - 1'b1;
end

// read and write logic based on fifo full and empty and 
assign validFiFoWr = fifoWrEn && !fifoFull;
assign validFiFoRd = fifoRdEn && !fifoEmpty;

// data count in fifo
assign fifoDataCount = dataCounter;

// fifo full and empty signal
assign fifoFull = (dataCounter==FIFO_DEPTH) ? 1'b1:1'b0;
assign fifoEmpty = (dataCounter==1'b0) ? 1'b1:1'b0;

// write pointer logic
always@(posedge clk) begin
	if(!resetN)
		wrPtr <= 0;
	else if(wrEnInt)
		wrPtr <= wrPtr + 1'b1;
end

// read pointer logic
always@(posedge clk) begin
	if(!resetN)
		rdPtr <= 0;
	else if(rdEnInt)
		rdPtr <= rdPtr + 1'b1;
end

endmodule