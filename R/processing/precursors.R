#' precursor adducts provider for the workflow
#' 
let get_adducts = function(ionMode = [1,-1]) {
	if (ionMode == 1) {
		["[M]+", "[M+H]+", "[M+H-H2O]+", "[M+NH4]+"];
	} else {
		["[M]-", "[M-H]-", "[M-H2O-H]-", "[M+HCOO]-", "[M+CH3COO]-"];
	}
}