imports "Parallel" from "snowFall";

#' Run untargetted annotation for gc-ms
#' 
const gcms_tof_annotation = function(rawdir, peaktable, 
    libtype   = [1,-1], 
    outputdir = "./", 
    ppm_cutoff = 20,
    lib_files = NULL,  
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
    result |> make_msms_plot(file.path(outputdir,"plotMs"));
}

const __gcms_file_annotation = function(filepath, peaktable,work_pars) {
    let outputdir = work_pars$outputdir;
    let checkfile = file.path(outputdir,`${basename(filepath)}.csv`);

    if (!file.exists(checkfile)) {
        if (is.null(work_pars$libfiles)) {
            # default internal
            let msp = system.file("data/MoNA-export-GC-MS_Spectra.msp", package = "Daisy");

            Daisy::__gcms_annotation(filepath, peaktable, 
                libname = basename(msp),
                libs = Daisy::gcms_mona_msp(msp, libtype = work_pars$libtype), 
                argv = work_pars);
            Daisy::__gcms_annotation(filepath, peaktable, 
                libname = "biocad_registry",
                libs = Daisy::local_gcms_lib(), 
                argv = work_pars);

        } else {
            # load external msp file
            for(let libfile in work_pars$libfiles) {
                # processing a single rawdata file
                Daisy::__gcms_annotation(filepath, peaktable, 
                    libname = basename(libfile),
                    libs = Daisy::gcms_mona_msp(libfile, libtype = work_pars$libtype), 
                    argv = work_pars);
            }
        }

        # merge library result
        let tempfiles = file.path(work_pars$outputdir,"tmp",basename(filepath)) |> list.files(pattern = "*.csv");
        let tempdata = as.list(tempfiles, basename(tempfiles)) |> lapply(path -> read.csv(path, row.names = NULL, check.names = FALSE));
        let union = bind_rows(tempdata);

        write.csv(union, file = checkfile, row.names = FALSE);
    }
}

#' run single gcms annotation
#' 
const __gcms_annotation = function(rawfile, peaktable, libname, libs, argv) {
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
        file = file.path(tmp, basename(rawfile), `${libname}.csv`), 
        row.names = FALSE);
}