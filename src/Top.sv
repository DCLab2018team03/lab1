module Top(
	input i_clk,
	input i_rst,
	input i_start_0,
	input i_start_1,
	output logic [7:0] o_random_out,
	output logic o_mode
);

logic state;
logic [30:0] lfsr;
logic [63:0] counter;
logic [63:0] changed_count;
parameter IDLE = '0, RUN = '1;

always_ff @(posedge i_clk or negedge i_rst) begin
	if (!i_rst) begin
		state <= IDLE;
		lfsr <= 1;
		o_random_out <= 0;
	end 
	else begin
		if (i_start_0) begin
			o_mode <= 0;
			counter <= 0;
			changed_count <= 0;
			state <= RUN;
		end
		else if (i_start_1) begin
			o_mode <= 1;
			counter <= 0;
			changed_count <= 0;
			state <= RUN;
		end
		else if (state == RUN) begin
		    counter <= counter + 1;
			if (counter == changed_count) begin
				changed_count <= changed_count + 200000;
				if (o_mode == 0) o_random_out <= {4'b0000, lfsr[30:27]};
				else o_random_out <= lfsr[30:23];
				counter <= 0;
				if (changed_count == 10000000)
					state <= IDLE;
			end
		end
		lfsr <= {lfsr[28] ^ lfsr[0], lfsr[30:1]};
	end
end

endmodule
