SHELL=/bin/bash -o pipefail

SRC   = src
INCL  = ../include
BUILD = build

NAME = wasmachine
DEPS = $(SRC)/genrom.sv $(SRC)/$(NAME).sv

VENDOR_DEPS = -y ../deps/fpu/double_to_float \
			  -y ../deps/fpu/float_to_double \
			  -y ../deps/LEB128

IVERILOG = iverilog -g2012 -I $(SRC) -I $(INCL) -y $(SRC) $(VENDOR_DEPS) $(parameters)
GTKWAVE  = gtkwave
VVP      = vvp -N

RED=\033[0;31m
GREEN=\033[0;32m
NC=\033[0m

ECHO = echo -e

all: test $(NAME).bin

clean:
	rm -rf *.bin *.txt *.blif $(BUILD) *~

update-dependencies:
	git submodule update --remote

.PHONY: all clean update-dependencies

ifndef VERBOSE
.SILENT:
endif

#
# General test objectives
#
test           : test/stack test/SuperStack test/genrom test/core
test/genrom    : $(BUILD)/genrom_tb.vcd
test/stack     : $(BUILD)/stack_tb.vcd
test/SuperStack: $(BUILD)/SuperStack_tb.vcd
test/%         : $(BUILD)/%_tb.vcd

$(BUILD)/%_tb.vcd: $(BUILD)/%_tb
	( \
		cd $(BUILD) && $(VVP) ../$< | \
		(grep -v -e "opened for output" \
						 -e "Not enough words in the file for the requested range" \
		|| true) \
	) \
	&& $(ECHO) "$(GREEN)ok$(NC)" \
	|| ($(ECHO) "$(RED)FAIL$(NC)" && exit 1)

$(BUILD)/%_tb: test/%_tb.sv $(SRC)/%.sv test/assert.svh src/core.sv src/genrom.sv src/stack.sv src/SuperStack.sv
	$(ECHO) -n $<"... "
	mkdir -p $(@D)
	$(IVERILOG) -I test $^ -o $@

view/%: test/%
	$(GTKWAVE) $(BUILD)/$(@F)_tb.vcd test/$(@F)_tb.gtkw


# core
test/core: test/core/control_flow_operators test/core/call_operators \
		   test/core/parametric_operators test/core/variable_access \
		   test/core/constants test/core/comparison_operators \
		   test/core/numeric_operators test/core/conversions \
		   test/core/reinterpretations

test/core/control_flow_operators: test/core/block test/core/loop test/core/if \
								  test/core/else test/core/br test/core/br_if \
								  test/core/br_table test/core/return
test/core/block: $(BUILD)/core/block_tb.vcd
test/core/loop: $(BUILD)/core/loop_tb.vcd
test/core/if: test/core/if1 test/core/if2
test/core/if1: $(BUILD)/core/if1_tb.vcd
test/core/if2: $(BUILD)/core/if2_tb.vcd
test/core/else: test/core/else1 test/core/else2
test/core/else1: $(BUILD)/core/else1_tb.vcd
test/core/else2: $(BUILD)/core/else2_tb.vcd
test/core/br: $(BUILD)/core/br_tb.vcd
test/core/br_if: $(BUILD)/core/br_if_tb.vcd
test/core/br_table: test/core/br_table1 test/core/br_table2 test/core/br_table3
test/core/br_table1: $(BUILD)/core/br_table1_tb.vcd
test/core/br_table2: $(BUILD)/core/br_table2_tb.vcd
test/core/br_table3: $(BUILD)/core/br_table3_tb.vcd
test/core/return: $(BUILD)/core/return_tb.vcd

test/core/call_operators: test/core/call
test/core/call : test/core/call1 test/core/call2
test/core/call1: $(BUILD)/core/call1_tb.vcd
test/core/call2: $(BUILD)/core/call2_tb.vcd

test/core/parametric_operators: test/core/drop test/core/select
test/core/drop   : $(BUILD)/core/drop_tb.vcd
test/core/select : test/core/select1 test/core/select2 test/core/select3
test/core/select1: $(BUILD)/core/select1_tb.vcd
test/core/select2: $(BUILD)/core/select2_tb.vcd
test/core/select3: $(BUILD)/core/select3_tb.vcd

test/core/variable_access: test/core/get_local1 test/core/get_local2 \
						  test/core/set_local test/core/tee_local
test/core/get_local1: $(BUILD)/core/get_local1_tb.vcd
test/core/get_local2: $(BUILD)/core/get_local2_tb.vcd
test/core/set_local: $(BUILD)/core/set_local_tb.vcd
test/core/tee_local: $(BUILD)/core/tee_local_tb.vcd

test/core/constants: test/core/f32.const test/core/f64.const test/core/i32.const \
	                  test/core/i64.const
test/core/f32.const: $(BUILD)/core/f32.const_tb.vcd
test/core/f64.const: $(BUILD)/core/f64.const_tb.vcd
test/core/i32.const: $(BUILD)/core/i32.const_tb.vcd
test/core/i64.const: $(BUILD)/core/i64.const_tb.vcd

test/core/comparison_operators: test/core/i32.eqz test/core/i32.eq \
							   test/core/i32.ne test/core/i64.eqz \
							   test/core/i64.eq test/core/i64.ne
test/core/i32.eqz : test/core/i32.eqz1 test/core/i32.eqz2
test/core/i32.eqz1: $(BUILD)/core/i32.eqz1_tb.vcd
test/core/i32.eqz2: $(BUILD)/core/i32.eqz2_tb.vcd
test/core/i32.eq : test/core/i32.eq1 test/core/i32.eq2
test/core/i32.eq1: $(BUILD)/core/i32.eq1_tb.vcd
test/core/i32.eq2: $(BUILD)/core/i32.eq2_tb.vcd
test/core/i32.ne : test/core/i32.ne1 test/core/i32.ne2
test/core/i32.ne1: $(BUILD)/core/i32.ne1_tb.vcd
test/core/i32.ne2: $(BUILD)/core/i32.ne2_tb.vcd
test/core/i64.eqz : test/core/i64.eqz1 test/core/i64.eqz2
test/core/i64.eqz1: $(BUILD)/core/i64.eqz1_tb.vcd
test/core/i64.eqz2: $(BUILD)/core/i64.eqz2_tb.vcd
test/core/i64.eq : test/core/i64.eq1 test/core/i64.eq2
test/core/i64.eq1: $(BUILD)/core/i64.eq1_tb.vcd
test/core/i64.eq2: $(BUILD)/core/i64.eq2_tb.vcd
test/core/i64.ne : test/core/i64.ne1 test/core/i64.ne2
test/core/i64.ne1: $(BUILD)/core/i64.ne1_tb.vcd
test/core/i64.ne2: $(BUILD)/core/i64.ne2_tb.vcd

test/core/numeric_operators: test/core/i32.add test/core/i32.sub test/core/i64.add \
							test/core/i64.sub
test/core/i32.add: $(BUILD)/core/i32.add_tb.vcd
test/core/i32.sub: $(BUILD)/core/i32.sub_tb.vcd
test/core/i64.add: $(BUILD)/core/i64.add_tb.vcd
test/core/i64.sub: $(BUILD)/core/i64.sub_tb.vcd

test/core/conversions: test/core/f32.demote-f64
test/core/f32.demote-f64: $(BUILD)/core/f32.demote-f64_tb.vcd

test/core/conversions: test/core/i32.wrap-i64
test/core/i32.wrap-i64: $(BUILD)/core/i32.wrap-i64_tb.vcd

test/core/reinterpretations: test/core/i32.reinterpret-f32 \
							test/core/i64.reinterpret-f64 \
							test/core/f32.reinterpret-i32 \
							test/core/f64.reinterpret-i64
test/core/i32.reinterpret-f32: $(BUILD)/core/i32.reinterpret-f32_tb.vcd
test/core/i64.reinterpret-f64: $(BUILD)/core/i64.reinterpret-f64_tb.vcd
test/core/f32.reinterpret-i32: $(BUILD)/core/f32.reinterpret-i32_tb.vcd
test/core/f64.reinterpret-i64: $(BUILD)/core/f64.reinterpret-i64_tb.vcd


$(BUILD)/core/%_tb.vcd: $(BUILD)/core/%_tb $(BUILD)/core/%.hex
	( \
		cd $(BUILD)/core && $(VVP) ../../$< | \
		(grep -v -e "opened for output" \
						 -e "Not enough words in the file for the requested range" \
		|| true) \
	) \
	&& $(ECHO) "$(GREEN)ok$(NC)" \
	|| ($(ECHO) "$(RED)FAIL$(NC)" && exit 1)

$(BUILD)/core/%.hex:
	mkdir -p $(@D)
	cp test/core/$(@F) $(BUILD)/core

$(BUILD)/core/%_tb: test/core/%_tb.sv $(SRC)/core.sv test/assert.svh src/core.sv  src/genrom.sv  src/stack.sv  src/SuperStack.sv
	$(ECHO) -n $<"... "
	mkdir -p $(@D)
	$(IVERILOG) -I test $^ -o $@

view/core/%: test/core/%
	$(GTKWAVE) $(BUILD)/core/$(@F)_tb.vcd test/core/core_tb.gtkw


# genrom
$(BUILD)/genrom_tb.vcd: $(BUILD)/genrom_tb
	cp test/genrom.hex $(BUILD)
	( \
		cd $(BUILD) && $(VVP) ../$< | \
		(grep -v -e "opened for output" \
						 -e "Not enough words in the file for the requested range" \
		|| true) \
	) \
	&& $(ECHO) "$(GREEN)ok$(NC)" \
	|| ($(ECHO) "$(RED)FAIL$(NC)" && exit 1)


# Sintesis complete
$(NAME).bin: resources/$(NAME).pcf $(DEPS) test/prog.list

	#-- Sintesis
	yosys -p "synth_ice40 -blif $(NAME).blif" $(DEPS)

	#-- Place & route
	arachne-pnr -d 1k -p resources/$(NAME).pcf $(NAME).blif -o $(NAME).txt

	#-- Generar binario final, listo para descargar en fgpa
	icepack $(NAME).txt $(NAME).bin
