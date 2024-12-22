imports "Parallel" from "snowFall";

#' Run untargetted annotation for gc-ms
#' 
const gcms_tof_annotation = function(rawdir, peaktable, 
    libtype   = [1,-1], 
    outputdir = "./", 
    ppm_cutoff = 20,
    lib_files = NULL, # system.file("data/MoNA-export-GC-MS_Spectra.msp", package = "Daisy"), 
    n_threads = 8,
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
            let checkfile = file.path(outputdir,`${basename(file)}.csv`);

            if (!file.exists(checkfile)) {
                file |> __gcms_annotation(peaktable, work_pars);
            }            
        }
    } else {
        # run in parallel for production
        Parallel::parallel(
            filepath    = rawfiles, 
            n_threads   = n_threads, 
            ignoreError = TRUE) {

            require(Daisy);

            let outputdir = work_pars$outputdir;
            let checkfile = file.path(outputdir,`${basename(filepath)}.csv`);

            if (!file.exists(checkfile)) {
                # processing a single rawdata file
                Daisy::__gcms_annotation(filepath, peaktable, 
                    libs =  __load_gcms_libs(work_pars), 
                    argv = work_pars);
            }
        }
    }

    let result = __merge_samples(`${work_pars$outputdir}/${basename(rawfiles)}.csv`, work_pars);
    
    result |> write.csv(file = file.path(outputdir, "anno.csv"));
    result |> make_msms_plot(file.path(outputdir,"plotMs"));
}

const __gcms_annotation = function(rawfile, peaktable, libs, argv) {
    let outputdir = argv$outputdir;
    let tmp = file.path(outputdir,"tmp");
    let top = as.integer(argv$top || 9);
    let ions = Daisy::read_gcmsdata(rawfile, peaktable);
    
    print("make spectrum alignment search...");

    let result = lapply(ions, function(i) {
        libs |> top_candidates(i, top = top);
    });

    result <- unlist(result);

    let reference_id = candidate_ids(result);   
    let scores = as.data.frame(result);
    let annotation = load_metadata(libs, reference_id );
    let xrefs = [annotation]::xref;
    let cas_id = sapply(xrefs, a -> .Internal::first([a]::CAS));

    annotation <- data.frame(
        ID = [annotation]::ID,
        name = [annotation]::name,
        formula = [annotation]::formula,
        exact_mass = [annotation]::exact_mass,
        CAS = cas_id,
        KEGG = [xrefs]::KEGG,
        chebi = [xrefs]::chebi,
        HMDB = [xrefs]::HMDB,
        kingdom = [annotation]::kingdom,
        super_class = [annotation]::super_class,
        class = [annotation]::class,
        sub_class = [annotation]::sub_class,
        molecular_framework = [annotation]::molecular_framework
    );
    result <- cbind(annotation, scores);

    write.csv(result, 
        file = file.path(outputdir,`${basename(rawfile)}.csv`), 
        row.names = FALSE);
}