#' make peak alignment of the ms2 annotation result with peaktable
#' 
#' @details a common method for handling of the ion feature annotation result
#' 
const peak_alignment = function(metadna, peaktable, mzdiff = 0.01, rt_win = 15, ms1ppm = 15, libtype = [1,-1]) {
    let alignments = list();
    let hit_result = NULL;
    let offset = 0;

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
            hit_result$npeaks = [peak]::npeaks;
            hit_result$into = [peak]::into;
            alignments[[`${hit_result$xcms_id}-${hit$metabolite_id}-${offset = offset + 1}`]] = hit_result;
        }
    }

    libtype <- .Internal::first(as.integer(libtype || 1));
    libtype <- get_adducts(libtype);

    let query_mz = alignments@mz;
    let exact_mass = formula::eval(alignments@formula);
    let adducts = lapply(tqdm(exact_mass), function(mass, i) {
        find_precursor(mass, mz = query_mz[i],
            libtype = libtype,
            da = 0.3,
            safe = TRUE);
    });
    let check_ms1 = sum(alignments@into > 0) > 0;

    alignments <- data.frame(
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
        xcms_id = alignments@xcms_id,
        mz = query_mz,
        rt = alignments@rt,
        intensity = {
            if (check_ms1) {
                alignments@into;
            } else {
                alignments@intensity;
            }
        },
        npeaks = alignments@npeaks,
        adducts = adducts@precursor_type,
        theoretical_mz = adducts@theoretical,
        ppm = adducts@ppm,
        evidence = alignments@evidence,
        alignment = alignments@alignment
    );
    alignments <- alignments[nchar(alignments$adducts)>0,];
    alignments <- alignments[as.numeric(alignments$ppm)<ms1ppm, ];
    alignments;
}