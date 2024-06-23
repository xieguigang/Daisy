require(Darwinism);
require(Daisy);

imports "memory_query" from "Darwinism";

# script for build local reference database
let mspfiles   = list.files("./MONA/", pattern = "*.msp");
let lib_export = "../data/MoNA/";
let refmet     = "./refmet.csv"
|> read.csv(row.names = NULL, check.names = FALSE)
|> memory_query::load()
|> hashindex(["refmet_name","pubchem_cid"])
|> valueindex(exactmass = "number")
;
let lib.pos    = spectrumTree::new(file.path(lib_export, "lib.pos.pack"), type = "Pack");
let lib.neg    = spectrumTree::new(file.path(lib_export, "lib.neg.pack"), type = "Pack");

for(let file in mspfiles) {
    let load_mona = read.MoNA(file, lazy = FALSE, verbose = FALSE);

    print(`processing source library file: ${file}...`);

}

close(lib.pos);
close(lib.neg);