`timescale 1ns/1ps

module tb;

  reg clk = 0, sys_rst = 0;
  reg [15:0] din = 0;
  wire [15:0] dout;

  top dut(clk, sys_rst, din, dout);

  always #5 clk = ~clk;  // 10ns clock period

  // Instruction memory
  reg [15:0] instr_mem [0:255];  // Adjust size as needed
  integer i, instr_count;

  initial begin
    // Reset sequence
    sys_rst = 1;
    repeat (3) @(posedge clk);
    sys_rst = 0;

    // Load instructions from file
    $readmemb("inst_data.mem", instr_mem);  // Use $readmemh if file is in hex

    // Apply instructions one-by-one
    for (i = 0; i < 256; i = i + 1) begin
      @(posedge clk);
      din <= instr_mem[i];
    end

    // Wait and stop
    #100;
    $finish;
  end

endmodule
