require(Daisy);

# script for build local reference database
let mspfiles   = list.files("./MONA/", pattern = "*.msp");
let lib_export = "../data/MoNA/";

for(let file in mspfiles) {
    let load_mona = read.MoNA(file);

    print(`processing source library file: ${file}...`);

}