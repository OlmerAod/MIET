module ad79x8_interface	( sclk, dout, start_transfer, data_in, data_out, cs, din	);
									
input 						sclk;
input							dout;							
input							start_transfer;
input				[15:0]	data_in;
output			[15:0]	data_out;
output	reg				cs = 1'b1;
output						din;

reg [15:0]	control_register = 0;
reg [3:0]	sclk_count = 4'b1111;
reg [15:0] 	data;
assign din 			= control_register[15];
assign data_out 	= start_transfer ? data : 0;

always@(negedge sclk) 
begin
		control_register <= control_register << 1;
	
		if(start_transfer)
			begin
				cs <= 1'b0;
				control_register <= data_in;
			end
		
		if (!cs)
			begin
				sclk_count <= sclk_count - 1;
				data <= data << 1;
				data[0] <= dout;
			end
		
		if (!sclk_count)
			cs <= 1'b1;
end

endmodule
