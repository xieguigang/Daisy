require(Darwinism);
require(Daisy);

imports "memory_query" from "Darwinism";
imports "formula" from "mzkit";

# script for build local reference database
let mspfiles   = list.files("./MONA/", pattern = "*.msp");
let lib_export = "../data/MoNA/";
let refmet     = read.csv("./refmet.csv",row.names = NULL, check.names = FALSE);
let lib.pos    = spectrumTree::new(file.path(lib_export, "lib.pos.pack"), type = "Pack");
let lib.neg    = spectrumTree::new(file.path(lib_export, "lib.neg.pack"), type = "Pack");

refmet[, "id"] = `RefMet_${1:nrow(refmet)}`;
refmet <- refmet
|> memory_query::load()
|> hashindex(["refmet_name","pubchem_cid"])
|> valueindex(exactmass = "number")
;

let metalib = NULL;

for(let file in mspfiles) {
    let load_mona = read.MoNA(file, lazy = FALSE, verbose = FALSE);
    let library = NULL;

    print(`processing source library file: ${file}...`);

    for(let spec in tqdm(load_mona)) {
        let spec_data = [spec]::GetSpectrumPeaks;
        let metadata  = [spec]::MetaReader;
        let library_sepc = ifelse(as.integer([spec]::libtype) == 1, lib.pos, lib.neg);
        let metabo_name  = [metadata]::name;
        let exact_mass   = formula::eval([metadata]::formula);
        let filter = refmet |> select(
            refmet_name = metabo_name, 
            # [M+H]+, [M+Na]+, [M-H]-, [M+H-H2O]+
            between("exactmass", [exact_mass - 30, exact_mass + 30]));

        if (([spec]::ms_level == 2) && (nrow(filter) > 0)) {
            filter = filter[1,];
            filter[, "libname"] = [spec]::ID;
            filter[, "cas"] = paste([metadata]::CAS, sep = "; ") || "-";
            filter[, "hmdb"] = [metadata]::hmdb;
    
            library <- rbind(library, filter);
            library_sepc 
            |> addBucket(spec_data,ignore_error = TRUE,
                uuid = [spec]::ID,formula = [metadata]::formula,
                name = metabo_name);
        }
    }

    library[, "library"] <- basename(file);
    metalib <- rbind( metalib, library); 
}

close(lib.pos);
close(lib.neg);

write.csv(metalib, file = file.path(lib_export, "metadata.csv"), 
    row.names = FALSE);