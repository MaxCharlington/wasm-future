module genrom #(
  parameter AW = 4,  // Address width in bits
  parameter DW = 8,  // Data witdh in bits
  parameter EXTRA = 4
)
(
  input                          clk,
  input  logic [         AW  :0] addr,
  input  logic [      EXTRA-1:0] extra,        // Length of data to be fetch
  input  logic [         AW  :0] lower_bound,
  input  logic [         AW  :0] upper_bound,
  output logic [2**EXTRA*DW-1:0] data=0,       // Output data
  output logic                   error=0       // none / out of limits
);

  // Parameter: name of the file with the ROM content
  parameter ROMFILE = "prog.list";

  // Calc the number of total positions of memory
  localparam NPOS = 1 << (AW+1);

  // Memory
  logic [DW-1: 0] rom [0: NPOS-1];

  // Read the memory
  always @(posedge clk) begin
    error <= addr < lower_bound || addr > upper_bound;

    case (extra)
      0: data <=  rom[addr   ];
      1: data <= {rom[addr   ], rom[addr+ 1]};
      2: data <= {rom[addr   ], rom[addr+ 1], rom[addr+ 2]};
      3: data <= {rom[addr   ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3]};
      4: data <= {rom[addr   ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4]};
      5: data <= {rom[addr   ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5]};
      6: data <= {rom[addr   ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5], rom[addr+ 6]};
      7: data <= {rom[addr   ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5], rom[addr+ 6], rom[addr+ 7]};
      8: data <= {rom[addr   ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5], rom[addr+ 6], rom[addr+ 7],
                  rom[addr+ 8]};
      9: data <= {rom[addr   ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5], rom[addr+ 6], rom[addr+ 7],
                  rom[addr+ 8], rom[addr+ 9]};
      10: data <= {rom[addr  ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5], rom[addr+ 6], rom[addr+ 7],
                  rom[addr+ 8], rom[addr+ 9], rom[addr+10]};
      11: data <= {rom[addr  ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5], rom[addr+ 6], rom[addr+ 7],
                  rom[addr+ 8], rom[addr+ 9], rom[addr+10], rom[addr+11]};
      12: data <= {rom[addr  ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5], rom[addr+ 6], rom[addr+ 7],
                  rom[addr+ 8], rom[addr+ 9], rom[addr+10], rom[addr+11],
                  rom[addr+12]};
      13: data <= {rom[addr  ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5], rom[addr+ 6], rom[addr+ 7],
                  rom[addr+ 8], rom[addr+ 9], rom[addr+10], rom[addr+11],
                  rom[addr+12], rom[addr+13]};
      14: data <= {rom[addr  ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5], rom[addr+ 6], rom[addr+ 7],
                  rom[addr+ 8], rom[addr+ 9], rom[addr+10], rom[addr+11],
                  rom[addr+12], rom[addr+13], rom[addr+14]};
      15: data <= {rom[addr  ], rom[addr+ 1], rom[addr+ 2], rom[addr+ 3],
                  rom[addr+ 4], rom[addr+ 5], rom[addr+ 6], rom[addr+ 7],
                  rom[addr+ 8], rom[addr+ 9], rom[addr+10], rom[addr+11],
                  rom[addr+12], rom[addr+13], rom[addr+14], rom[addr+15]};
    endcase
  end

  // Load in memory the `ROMFILE` file. Values must be given in hexadecimal
  initial begin
    $readmemh(ROMFILE, rom);
  end

endmodule
