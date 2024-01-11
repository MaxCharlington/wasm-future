`include "assert.svh"

`include "core.svh"


module cpu_tb();

  logic clk = 0;


  //
  // ROM
  //

  localparam MEM_ADDR  = 4;
  localparam MEM_EXTRA = 4;

  logic  [      MEM_ADDR  :0] mem_addr;
  logic  [     MEM_EXTRA-1:0] mem_extra;
  logic  [      MEM_ADDR  :0] rom_lower_bound = 0;
  logic  [      MEM_ADDR  :0] rom_upper_bound = ~0;
  logic [2**MEM_EXTRA*8-1:0] mem_data;
  logic                      mem_error;

  genrom #(
    .ROMFILE("i32.reinterpret-f32.hex"),
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

  parameter HAS_FPU = 1;
  parameter USE_64B = 1;

  logic         reset = 0;
  logic [63:0] result;
  logic [ 1:0] result_type;
  logic        result_empty;
  logic [ 3:0] trap;

  core #(
    .HAS_FPU(HAS_FPU),
    .USE_64B(USE_64B),
    .MEM_DEPTH(MEM_ADDR)
  )
  dut
  (
    .clk(clk),
    .reset(reset),
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
    $dumpfile("i32.reinterpret-f32_tb.vcd");
    $dumpvars(0, cpu_tb);

    if(HAS_FPU) begin
      #18
      `assert(result, 32'hc0000000);
      `assert(result_type, `i32);
      `assert(result_empty, 0);
    end
    else begin
      #12
      `assert(trap, `NO_FPU);
    end

    $finish;
  end

endmodule
