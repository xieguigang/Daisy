#' make peak alignment of the ms2 annotation result with peaktable
#' 
#' @details a common method for handling of the ion feature annotation result
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