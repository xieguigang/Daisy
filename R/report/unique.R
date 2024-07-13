#' make unique annotation result
#' 
const report_unique = function(result) {
    # make unique name
    # by pickup top score ion
    result = result |> groupBy("name");
    result = lapply(result, function(ions) {
        let files = length(unique(ions$rawfile));
        ions = ions[order(ions$rank, decreasing = TRUE), ];
        ions[, "supports"] = files;
        ions[1,,drop = TRUE];
    });
    result = tabular(result);

    # make unique ion
    # by pickup top score name
    result = result |> groupBy("xcms_id");
    result = lapply(result, function(meta) {
        meta[, "rank"] = as.numeric(meta$rank) * as.numeric(meta$supports);
        meta = meta[order(meta$rank, decreasing = TRUE), ];
        meta[1,,drop = TRUE];
    });

    tabular(result);
}

const tabular = function(result) {
    data.frame(
        xcms_id	= result@xcms_id,
        mz = result@mz,
        rt = result@rt,
        intensity = result@intensity,
        KEGG = result@KEGG,
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
        supports = result@supports,
        alignment = result@alignment,
        row.names = result@xcms_id
    );
}

const rank_score = function(result) {
    (as.numeric(result$forward) + 
     as.numeric(result$reverse) + 
     as.numeric(result$jaccard) + 
     as.numeric(result$entropy)) / (as.numeric(result$ppm) + 0.1);
}