#' Run untargetted annotation for gc-ms
#' 
const gcms_tof_annotation = function(rawdir, peaktable, 
    libtype   = [1,-1], 
    outputdir = "./", 
    lib_files = system.file("data/MoNA-export-GC-MS_Spectra.msp", package = "Daisy"), 
    n_threads = 8,
    debug = FALSE) {

    let rawfiles = list.files(rawdir, 
        pattern = ["*.mzXML", 
                   "*.mzML", 
                   "*.mzPack"]);
    let work_pars = list(
        libtype = libtype,
        outputdir = normalizePath(outputdir),
        libfiles = lib_files
    ); 
    
    if (debug || (n_threads == 1)) {
        for(let file in rawfiles) {
            file |> __gcms_annotation(peaktable, work_pars);
        }
    } else {
        # run in parallel for production
        parallel(path = rawfiles, n_threads = n_threads, 
                 ignoreError = TRUE) {

            require(Daisy);
            # processing a single rawdata file
            Daisy::__gcms_annotation(path, peaktable, work_pars);
        }
    }
}

const __gcms_annotation = function(rawfile, peaktable, argv) {


}