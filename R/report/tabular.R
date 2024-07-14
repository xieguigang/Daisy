
#' common method for make the annotation tabular outputs
#' 
const tabular = function(result) {
    data.frame(
        xcms_id	= result@xcms_id,
        mz = result@mz,
        rt = result@rt,
        intensity = result@intensity,
        KEGG = result@KEGG,
        CAS = result@CAS,
        hmdb = result@HMDB,
        exactMass = result@exactMass,
        formula = result@formula,
        name = result@name,
        precursorType = result@precursorType,
        mzCalc = result@mzCalc,
        ppm = result@ppm,
        forward = result@forward,
        reverse = result@reverse,
        jaccard = result@jaccard,
        entropy = result@entropy,
        pvalue = result@pvalue,
        rank = result@rank,
        rawfile = result@rawfile,
        ion_mode = result@ion_mode,
        supports = result@supports,
        alignment = result@alignment,
        row.names = result@xcms_id
    );
}