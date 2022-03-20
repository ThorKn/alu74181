all: alu74181.vvp
	vvp alu74181.vvp

alu74181.vvp: test/tb.v src/alu74181.v
	iverilog -o $@ $?

clean:
	rm alu74181.vvp alu74181.vcd
