#' make unique annotation result
#' 
const report_unique = function(result) {
    let keys = colnames(result);

    # make unique name
    # by pickup top score ion
    result = result |> groupBy("metabolite_id");
    result = lapply(result, function(ions) {
        let files = length(unique(ions$rawfile));
        ions = ions[order(as.numeric(ions$rank), decreasing = TRUE), ];
        ions[, "supports"] = files;
        ions[1,,drop = TRUE];
    });
    result = tabular(result,keys );

    # make unique ion
    # by pickup top score name
    result = result |> groupBy("xcms_id");
    result = lapply(result, function(meta) {
        meta[, "rank"] = as.numeric(meta$rank) * (as.numeric(meta$supports) + 1);
        meta = meta[order(meta$rank, decreasing = TRUE), ];
        meta[1,,drop = TRUE];
    });

    tabular(result,keys );
}

#' formula for make rank score for each search candidates
#' 
const rank_score = function(result) {
    (as.numeric(result$npeaks) / max(as.numeric(result$npeaks))) + 
    (as.numeric(result$into) / max(as.numeric(result$into))) + 
    (as.numeric(result$forward) + 
     as.numeric(result$reverse) + 
     as.numeric(result$jaccard) + 
     as.numeric(result$entropy)) / (as.numeric(result$ppm) + 0.1);
}