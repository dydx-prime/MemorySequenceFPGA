module fifo #(
    parameter WIDTH = 4,   // bit width of each element
    parameter DEPTH = 20   // number of entries
)(
    input               clk,
    input               reset,
	 input					fifo_reset,
    input               wr_en,      // write enable
    input               rd_en,      // read enable
    input  [WIDTH-1:0]  data_in,
    output [WIDTH-1:0]  data_out,
    output              full,
    output              empty
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    reg [$clog2(DEPTH)-1:0] wr_ptr;  // write pointer
    reg [$clog2(DEPTH)-1:0] rd_ptr;  // read pointer
    reg [$clog2(DEPTH):0]   count;   // number of items stored

    // Status flags
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    // Read (combinational output)
    assign data_out = mem[rd_ptr];

    // Write
    always @(posedge clk) begin
        if (!reset || fifo_reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
        end else begin
            // Write
            if (wr_en && !full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= (wr_ptr + 1) % DEPTH;
                count <= count + 1;
            end

            // Read
            if (rd_en && !empty) begin
                rd_ptr <= (rd_ptr + 1) % DEPTH;
                count <= count - 1;
            end

            // Simultaneous read and write
            if (wr_en && !full && rd_en && !empty) begin
                count <= count;  // count stays the same
            end
        end
    end

endmodule