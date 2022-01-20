	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"MLP_tb"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"0.1 ms"
#	set run_time			"-all"

	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder_21bit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder_tree.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/counter.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/get_max.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/memories.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/MLP.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mult.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mux.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/PU.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/relu.v
#	vlog 	+acc -incr -source  +define+SIM 	$inc_path/implementation_option.vh
		
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

	vsim	-voptargs=+acc -debugDB $TB

	add wave -uns -group 	 	{TB}				sim:/$TB/*
#	add wave -uns -group 	 	{top}				sim:/$TB/uut/*	
	add wave -uns -group -r		{all}				sim:/$TB/*
	
	configure wave -signalnamewidth 2

	run $run_time 
	