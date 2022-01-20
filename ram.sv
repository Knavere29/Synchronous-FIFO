module ram #(parameter MEM_WIDTH = 8, MEM_DEPTH = 8)(
input clk,
input wrEn,                           // should be high for data to write on memory
input rdEn,                           // should be high for data to read from memory
input [$clog2(MEM_DEPTH)-1:0] wrAddr,
input [$clog2(MEM_DEPTH)-1:0] rdAddr,
input [MEM_WIDTH-1:0] wrData,
output logic [MEM_WIDTH-1:0] rdData
);

// memory
logic [MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0];

// write 
always@(posedge clk) begin
	if(wrEn)
		mem[wrAddr] <= wrData;
end

//read
always@(posedge clk) begin
	if(rdEn)
		rdData <= mem[rdAddr];
end

endmodule