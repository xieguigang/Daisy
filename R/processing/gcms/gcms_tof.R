

#' run single gcms annotation
#' 
const __gcms_annotation = function(rawfile, ions, libname, libs, argv) {
    let outputdir = argv$outputdir;
    let tmp = file.path(outputdir,"tmp");
    let top = as.integer(argv$top || 9);
        
    print(`[${libname}] make spectrum alignment search...`);

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