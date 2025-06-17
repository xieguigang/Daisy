#' make unique annotation result
#' 
const report_unique = function(result) {
    let keys = colnames(result);
    let unique_name = `${result$metabolite_id}_${result$adducts}`;    

    # make unique name
    # by pickup top score ion
    result[,"unique_key"] = unique_name;
    result = result |> groupBy("unique_key");
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
    let score = (as.numeric(result$npeaks) / max(as.numeric(result$npeaks))) + 
    (as.numeric(result$intensity ) / max(as.numeric(result$intensity ))) + 
    (as.numeric(result$forward) + 
     as.numeric(result$reverse) + 
     as.numeric(result$jaccard) + 
     as.numeric(result$entropy));

    let formula_ranking = math::rank_adducts(
        formula = result$formula, 
        adducts = result$adducts, 
        max_score = 2
    );

    score = score / (as.numeric(result$ppm) + 0.1);
    score = score / (as.numeric(result$msi_level));
    score = score * formula_ranking;

    print("view of the ion ranking score:");
    print(score);

    score;
}