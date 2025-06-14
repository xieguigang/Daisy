const metadna_report = function(metadna_result, metadb, args) {
    let metadata = metadb |> getByKEGG(metadna_result$KEGGId);
    
    data.frame(
        metabolite_id = metadna_result$KEGGId,
        name = metadna_result$name,
        formula = metadna_result$formula,
        exact_mass = metadna_result$exactMass,
        chebi = "",
        pubchem = "",
        cas = "",
        kegg = metadna_result$KEGGId,
        hmdb = "",
        lipidmaps = "",
        mesh = "",
        inchikey = "",
        inchi = "",
        smiles = "",
        kingdom = "",
        super_class = "",
        class = "",
        sub_class = "",
        molecular_framework = "",
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