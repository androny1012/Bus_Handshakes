testbentch_module = tb_Handshake_Type3
testbentch_file = $(testbentch_module).sv
rtl_file = ../rtl/*.v
gtkw_file = $(testbentch_module).gtkw

compile:
	iverilog -g2012 -o $(testbentch_module).vvp $(rtl_file) $(testbentch_file)

run:
	vvp -n $(testbentch_module).vvp -lxt2

wave:
	vvp -n $(testbentch_module).vvp -lxt2

    ifneq "$(wildcard $(gtkw_file))" ""
	    gtkwave $(gtkw_file)
    else
	    gtkwave $(testbentch_module).vcd
    endif

all: compile wave

# clear middle files
clean:
	rm -rf *.vvp *vcd *.gtkw
