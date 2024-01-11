module wasm_accelerator();
    logic [63:0] instruction;  // width?
    logic [127:0] instr_ptr;  // struct to define which 1. func 2. instr ptr to fetch
    logic allow_globs, allow_ftcr, allow_ctrl, allow_bp; // protectors
    logic [127:0] global_value, val0, val1, ftype;
    logic [31:0] fidx; // func index to get type
    logic [63:0] current_bp; // current base pointer for stack of recent func. 0 by default?

    function_types_storage funks( .allow(allow_funcs), .value(ftype), .index(fidx) );
    globals_storage_unit globs( .allow(allow_globs), .value(global_value), .instr(instruction));  // writes or reads
    stack stk( .allow(allow_stk), .read_offset(offset), .value_in(val0), .value_out0(val0), .value_out1(val1) .instr(stack_instr) );
    fetcher_unit ftcr(.instr_out(instruction), .instr_ptr(instr_ptr));  // fetches instructions according to instr ptr
    control_unit ctrl(.fetched_instr(instruction), .controlled_ip(instr_ptr));  // takes instruction and moves instr pointer for fetcher read. Internally branch predictor. for ifs, loops, jumps, calls

    base_ptr_unit bp( .ftype(ftype), .allow(allow_bp), .bp_out(current_bp) ); // unit for controlling bp offset for a function calling


endmodule