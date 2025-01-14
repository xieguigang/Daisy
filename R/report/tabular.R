#' A helper function for make list to tabular report
#' 
const tabular = function(list, keys) {
    let df = data.frame();

    for(let name in keys) {
        df[, name] <- list@{name};
    }

    return(df);
}