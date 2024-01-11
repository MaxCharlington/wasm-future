`include "assert.svh"


module cpu_tb();

  logic clk = 0;


  //
  // ROM
  //

  localparam MEM_ADDR    = 6;
  localparam MEM_EXTRA   = 4;
  localparam STACK_DEPTH = 7;

  logic  [      MEM_ADDR  :0] mem_addr;
  logic  [     MEM_EXTRA-1:0] mem_extra;
  logic  [      MEM_ADDR  :0] rom_lower_bound = 0;
  logic  [      MEM_ADDR  :0] rom_upper_bound = ~0;
  logic [2**MEM_EXTRA*8-1:0] mem_data;
  logic                      mem_error;

  genrom #(
    .ROMFILE("loop.hex"),
    .AW(MEM_ADDR),
    .DW(8),
    .EXTRA(MEM_EXTRA)
  )
  ROM (
    .clk(clk),
    .addr(mem_addr),
    .extra(mem_extra),
    .lower_bound(rom_lower_bound),
    .upper_bound(rom_upper_bound),
    .data(mem_data),
    .error(mem_error)
  );


  //
  // CPU
  //

  logic                  reset = 1;
  logic  [   MEM_ADDR:0] pc    = 17;
  logic  [STACK_DEPTH:0] index = 1;
  logic [         63:0] result;
  logic [          1:0] result_type;
  logic                 result_empty;
  logic [          3:0] trap;

  core #(
    .MEM_DEPTH(MEM_ADDR),
    .STACK_DEPTH(STACK_DEPTH)
  )
  dut
  (
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .index(index),
    .result(result),
    .result_type(result_type),
    .result_empty(result_empty),
    .trap(trap),
    .mem_addr(mem_addr),
    .mem_extra(mem_extra),
    .mem_data(mem_data),
    .mem_error(mem_error)
  );

  always #1 clk = ~clk;

  initial begin
    $dumpfile("loop_tb.vcd");
    $dumpvars(0, cpu_tb);

    #1
    reset <= 0;

    #247
    `assert(result, 3);
    `assert(result_empty, 0);

    $finish;
  end

endmodule
