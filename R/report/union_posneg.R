#' make union of the pos+neg annotation outputs
#' 
const union_posneg = function(pos, neg) {
    if (is.character(pos)) {
        pos = read.csv(pos, row.names = NULL, check.names = FALSE);
    }
    if (is.character(neg)) {
        neg = read.csv(neg, row.names = NULL, check.names = FALSE);
    }

    pos[, "ion_mode"] = "pos";
    neg[, "ion_mode"] = "neg";

    let make_union = rbind(pos, neg);
    let metaList = make_union |> groupBy("name") |> lapply(function(meta) {
        # keep top rank score?
        meta = meta[order(as.numeric(meta$rank), decreasing = TRUE),];
        meta[1,,drop = TRUE];
    });

    # cast to tabular
    tabular(metaList);
}