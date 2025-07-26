#' Parse the ms2 spectrum data
#' 
#' @param block the multiple line of the text data 
#'
#' @return the parsed ms2 spectrum data in a dataframe object,
#'   contains two data fields: 
#'    - mz: the ms2 fragment mz data
#'    - into: the ms2 fragment intensity data 
#' 
const parseMS = function(block) {
    const matrix    = as.vector(block) |> lapply(line -> as.numeric(strsplit(line, "\s+")));
    const mz        = sapply(matrix, r -> r[1]);
    const intensity = sapply(matrix, r -> r[2]);

    data.frame(
        "mz"   = mz, 
        "into" = intensity
    );
}
