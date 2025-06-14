const metadna_report = function(metadna_result, metadb, args) {
    let metadata = metadb |> getByKEGG(metadna_result$KEGGId);
    let xref = [metadata]::xref;
    let ms1_da = args$ms1_da || 0.1;
    let rt_winsize = args$rt_winsize || 10;
    let ms1ppm = as.numeric(args$ms1ppm ||15);

    data.frame(
        metabolite_id = [metadata]::ID,
        name = [metadata]::name,
        formula = [metadata]::formula,
        exact_mass = [metadata]::exact_mass,
        chebi = [xref]::chebi,
        pubchem = [xref]::pubchem,
        cas = sapply(xref, i -> .Internal::first([i]::CAS) || "NULL"),
        kegg = metadna_result$KEGGId,
        hmdb = [xref]::HMDB,
        lipidmaps = [xref]::lipidmaps,
        mesh = [xref]::MeSH,
        inchikey = "",
        inchi = "",
        smiles = [xref]::SMILES,
        kingdom = [metadata]::kingdom,
        super_class = [metadata]::super_class,
        class = [metadata]::class,
        sub_class = [metadata]::sub_class,
        molecular_framework = [metadata]::molecular_framework,
        forward = metadna_result$forward,
        reverse = metadna_result$reverse,
        jaccard = metadna_result$jaccard,
        entropy = metadna_result$entropy,
        mz = metadna_result$mz,
        rt = metadna_result$rt,
        intensity = metadna_result$intensity,
        evidence = metadna_result$reaction,
        alignment = metadna_result$alignment
    ) 
    # the annotation result dataframe required of mz and rt field
    |> Daisy::peak_alignment(args$peaks, 
        mzdiff = ms1_da, 
        rt_win = rt_winsize,
        ms1ppm = ms1ppm, libtype = args$libtype )
    ;
}