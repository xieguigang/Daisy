let get_adducts = function(ionMode = [1,-1]) {
	if (ionMode == 1) {
		["[M]+", "[M+H]+", "[M+H-H2O]+", "[M+NH4]+", "[M+Na]+", "[M+K]+"];
	} else {
		["[M]-", "[M-H]-", "[M-H2O-H]-", "[M+HCOO]-", "[M+CH3COO]-"];
	}
}