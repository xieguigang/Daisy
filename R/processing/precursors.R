let get_adducts = function(ionMode = [1,-1]) {
	if (ionMode == 1) {
		["[M]+", "[M+H]+"];
	} else {
		["[M]-", "[M-H]-"];
	}
}