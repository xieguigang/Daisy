#' make peak alignment of the ms2 annotation result with peaktable
#' 
#' @details a common method for handling of the ion feature annotation result
#' 
const peak_alignment = function(metadna, peaktable, mzdiff = 0.01, rt_win = 15) {
    let alignments = list();
    let hit_result = NULL;

    for(let hit in tqdm(as.list(metadna, byrow = TRUE))) {
        let peaks = peaktable |> find_xcms_ionPeaks(mz  = hit$mz, rt = hit$rt,
            mzdiff = mzdiff,
            rt_win = rt_win); 

        # no ion peaks matched result will be ignores at here
        for(peak in peaks) {
            hit_result = as.list(hit);
            hit_result$xcms_id = [peak]::ID;
            hit_result$mz = [peak]::mz;
            hit_result$rt = [peak]::rt;
            alignments[[`${hit_result$xcms_id}-${hit$metabolite_id}`]] = hit_result;
        }
    }

    let exact_mass = formula::eval(alignments@formula);

    data.frame(
        metabolite_id = alignments@metabolite_id,
        name = alignments@name,
        formula = alignments@formula,
        exact_mass = exact_mass,
        chebi = alignments@chebi,
        pubchem = alignments@pubchem,
        cas = alignments@cas,
        kegg = alignments@kegg,
        hmdb = alignments@hmdb,
        lipidmaps = alignments@lipidmaps,
        mesh = alignments@mesh,
        inchikey = alignments@inchikey,
        inchi = alignments@inchi,
        smiles = alignments@smiles,
        kingdom = alignments@kingdom,
        super_class = alignments@super_class,
        class = alignments@class,
        sub_class = alignments@sub_class,
        molecular_framework = alignments@molecular_framework,
        forward = alignments@forward,
        reverse = alignments@reverse,
        jaccard = alignments@jaccard,
        entropy = alignments@entropy,
        mz = alignments@mz,
        rt = alignments@rt,
        intensity = alignments@intensity,
        evidence = alignments@evidence,
        alignment = alignments@alignment
    );
}