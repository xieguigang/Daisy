imports "Parallel" from "snowFall";

#' Run untargetted annotation for gc-ms
#' 
const gcms_tof_annotation = function(rawdir, peaktable, 
    libtype   = [1,-1], 
    outputdir = "./", 
    ppm_cutoff = 20,
    lib_files = system.file("data/MoNA-export-GC-MS_Spectra.msp", package = "Daisy"), 
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
                    argv = work_pars);
            }
        }
    }

    `${work_pars$outputdir}/${basename(rawfiles)}.csv`
    |> __merge_samples(work_pars)
    |> write.csv(file = file.path(outputdir, "anno.csv"))
    ;
}

const __merge_samples = function(results, argv) {
    results <- lapply(tqdm(results), function(path) {
        let result = read.csv(path, row.names = NULL, check.names = FALSE);
        result[,"sample"] = basename(path);
        result;
    });
    results <- bind_rows(results);
    results[, "unique_id"] = `${results$ID}-${results$query_id}`;

    let cols = colnames(results);

    results <- groupBy(results, "unique_id");
    results <- lapply(tqdm(results), function(align) {
        let rank = as.numeric(align$forward) +
            as.numeric(align$reverse) +as.numeric(align$jaccard) +as.numeric(align$entropy);
        
        align[,"supports"] <- nrow(align);
        align[,"rank"] <- nrow(align) * rank;
        align <- align[order( rank , decreasing = TRUE ),];
        align[1,,drop=TRUE];
    });

    let merge = data.frame(
        row.names = names(results),
        unique_id = names(results)
    );

    for(name in cols) {
        merge[,name]<- results@{name};
    }

    let ppm_cutoff = as.numeric(argv$ppm_cutoff);
    let libtype = as.integer(argv$libtype);
    let adducts = as.list(results,byrow=TRUE) 
    |> tqdm()
    |> lapply(function(r) {
        find_precursor(r$exact_mass, r$mz,safe=TRUE, libtype = libtype);
    });

    merge[,"precursor_type"] <- adducts@precursor_type;
    merge[,"ppm"] <- as.numeric(adducts@ppm);
    merge[,"rank"] <- results@rank;
    merge[,"supports"] <- results@supports;

    merge <- merge[merge$ppm < ppm_cutoff,];
    merge <- merge[nchar(merge$precursor_type)>0,];
    merge[,"rank"] = (merge$rank) / (merge$ppm); 

    merge <- rank_unique(merge, "query_id", merge$rank);
    merge <- rank_unique(merge, "ID", merge$rank);
    merge[,"ID"] = NULL;
    merge[,"unique_id"] =NULL;

    print(merge);

    merge;
}

const __gcms_annotation = function(rawfile, peaktable, argv) {
    let outputdir = argv$outputdir;
    let tmp = file.path(outputdir,"tmp");
    let ions = Daisy::read_gcmsdata(rawfile, peaktable);
    let libs = Daisy::gcms_mona_msp(argv$libfiles, libtype = argv$libtype);
    let top = as.integer(argv$top || 9);

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