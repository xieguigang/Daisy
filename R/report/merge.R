#' merge annotation result of each sample file
#' 
const __merge_samples = function(results, argv) {
    results <- lapply(tqdm(results), function(path) {
        let result = read.csv(path, row.names = NULL, check.names = FALSE);
        result[,"sample"] = basename(path);
        result;
    });
    results <- bind_rows(results);
    results[, "unique_id"] = `${results$ID}-${results$query_id}`;

    let cols = colnames(results);

    results <- groupBy(results, "unique_id");
    results <- lapply(tqdm(results), function(align) {
        let rank = as.numeric(align$forward) +
            as.numeric(align$reverse) +as.numeric(align$jaccard) +as.numeric(align$entropy);
        
        align[,"supports"] <- nrow(align);
        align[,"rank"] <- nrow(align) * rank;
        align <- align[order( rank , decreasing = TRUE ),];
        align[1,,drop=TRUE];
    });

    let merge = data.frame(
        row.names = names(results),
        unique_id = names(results)
    );

    for(name in cols) {
        merge[,name]<- results@{name};
    }

    let ppm_cutoff = as.numeric(argv$ppm_cutoff);
    let libtype = as.integer(argv$libtype);
    # let adducts = as.list(results,byrow=TRUE) 
    # |> tqdm()
    # |> lapply(function(r) {
    #     find_precursor(r$exact_mass, r$mz,safe=TRUE, libtype = libtype);
    # });

    # merge[,"adducts"] <- adducts@precursor_type;
    # merge[,"ppm"] <- as.numeric(adducts@ppm);
    merge[,"rank"] <- results@rank;
    merge[,"supports"] <- results@supports;

    # merge <- merge[merge$ppm < ppm_cutoff,];
    # merge <- merge[nchar(merge$adducts)>0,];
    # merge[,"rank"] = (merge$rank) / (merge$ppm); 

    merge <- rank_unique(merge, "query_id", merge$rank);
    merge <- rank_unique(merge, "ID", merge$rank);
    merge[,"ID"] = NULL;
    merge[,"unique_id"] =NULL;
    merge[,"xcms_id"] = merge$query_id;
    merge[,"query_id"] = NULL;
    merge[,"alignment"] = merge$alignment_str;
    merge[,"alignment_str"] = NULL;

    print(merge);

    merge;
}