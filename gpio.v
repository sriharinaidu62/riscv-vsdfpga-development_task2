module gpio (
    input  wire        clk,
    input  wire        reset,
    input  wire        we,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    output wire [31:0] gpio_out
);

    reg [31:0] gpio_reg;

    always @(posedge clk) begin
        if (reset)
            gpio_reg <= 32'b0;
        else if (we)
            gpio_reg <= wdata;
    end

    assign rdata    = gpio_reg;
    assign gpio_out = gpio_reg;

endmodule
