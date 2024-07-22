imports "metadna" from "mzDIA";
imports "mzweb" from "mzkit";
imports ["assembly", "data", "math"] from "mzkit";

#' run metadna algorithm
#' 
#' @param peaks_ms2 a collection of the spectrum in ms2 level
#' 
const call_metadna = function(peaks_ms2, libtype = [1,-1], ms1ppm = 15, output = "./") {
    options(verbose = TRUE);

    let metadna = metadna(
        ms1ppm    = tolerance(ms1ppm, "ppm"),
        dotcutoff = 0.5,
        mzwidth   = tolerance(0.3, "da"),
        allowMs1  = FALSE
    )
    |> range(get_adducts(libtype))
    |> load.kegg(GCModeller::kegg_compounds(rawList = TRUE, reference_set = FALSE))
    |> load.kegg_network(GCModeller::kegg_reactions())
    ;
    let infer = metadna |> DIA.infer(
        seeds  = NULL,
        sample = peaks_ms2
    )
    ;
    let unique_result = metadna |> as.table(infer, unique = TRUE);

    metadna 
    |> as.table(infer) 
    |> write.csv(file = `${output}/metaDNA_all.csv`)
    ;
    infer 
    |> metadna::result.alignment(unique_result)
    |> xml
    |> writeLines(con = `${output}/metaDNA_infer.XML`)
    ;

    write.csv(unique_result, file = `${output}/metaDNA.csv`);
}

#' make peak alignment of the metadna result with peaktable
#' 
const peak_alignment = function(metadna, peaktable, mzdiff = 0.01, rt_win = 15) {
    let alignments = list();
    let hit_result = NULL;

    for(let hit in as.list(metadna, byrow = TRUE)) {
        let peaks = peaktable |> find_xcms_ionPeaks(mz  = hit$mz, rt = hit$rt,
            mzdiff = mzdiff,
            rt_win = rt_win); 

        # no ion peaks matched result will be ignores at here
        for(peak in peaks) {
            hit_result = as.list(hit);
            hit_result$xcms_id = [peak]::ID;
            hit_result$mz = [peak]::mz;
            hit_result$rt = [peak]::rt;
            alignments[[`${hit_result$xcms_id}-${hit$query_id}`]] = hit_result;
        }
    }

    data.frame(
        xcms_id = alignments@xcms_id,
        mz = alignments@mz,
        rt = alignments@rt,
        intensity = alignments@intensity,
        KEGG = alignments@KEGGId,
        exactMass = alignments@exactMass,
        formula = alignments@formula,
        name = alignments@name,
        precursorType = alignments@precursorType,
        mzCalc = alignments@mzCalc,
        ppm = alignments@ppm,
        forward	= alignments@forward,
        reverse = alignments@reverse,
        jaccard = alignments@jaccard,
        entropy = alignments@entropy,
        pvalue	= alignments@pvalue,
        alignment = alignments@alignment,
        row.names = alignments@xcms_id
    );
}