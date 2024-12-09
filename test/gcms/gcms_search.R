require(Daisy);

setwd(@dir);

let peakdata = "./peaktable.csv"; # read.csv("./peaktable.csv", row.names = 1, check.names = FALSE);
let rawfiles = list.files("./rawdata", pattern = "*.mzML");

gcms_tof_annotation("./rawdata", "./peaktable.csv", 
    libtype   = 1, 
    outputdir = "./", 
    # lib_files = system.file("data/MoNA-export-GC-MS_Spectra.msp", package = "Daisy"), 
    n_threads = 16,
    debug = TRUE
);