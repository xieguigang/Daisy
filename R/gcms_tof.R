#' Run untargetted annotation for gc-ms
#' 
const gcms_tof_annotation = function(rawdir, peaktable, 
    libtype   = [1,-1], 
    outputdir = "./", 
    ppm_cutoff = 20,
    lib_files = NULL,  
    n_threads = 8,
    do_plot = TRUE,
    debug = FALSE) {

    let rawfiles = list.files(rawdir, 
        pattern = ["*.mzXML", 
                   "*.mzML", 
                   "*.mzPack"]);
    let work_pars = list(
        libtype = .Internal::first(as.integer(libtype)),
        outputdir = normalizePath(outputdir),
        libfiles = lib_files,
        ppm_cutoff = as.numeric(ppm_cutoff)
    ); 
    
    str(work_pars);

    if (debug || (n_threads == 1)) {
        for(let file in rawfiles) {
            Daisy::__gcms_file_annotation(file,peaktable,work_pars);      
        }
    } else {
        # run in parallel for production
        Parallel::parallel(
            filepath    = rawfiles, 
            n_threads   = n_threads, 
            ignoreError = TRUE) {

            require(Daisy);

            Daisy::__gcms_file_annotation(filepath,peaktable,work_pars);
        }
    }

    let result = __merge_samples(`${work_pars$outputdir}/${basename(rawfiles)}.csv`, work_pars);
    
    result |> write.csv(file = file.path(outputdir, "anno.csv"));

    if (do_plot) {
        result |> make_msms_plot(file.path(outputdir,"plotMs"));
    }    
}