#' Parse MS2 spectrum data from text block
#' 
#' @description 
#' Processes a block of text containing MS2 spectrum data, extracting m/z and intensity values.
#' 
#' @param block Character vector where each element contains a pair of whitespace-separated numeric values (m/z and intensity).
#' 
#' @return A dataframe containing two columns:
#' \itemize{
#'   \item \code{mz} - Numeric vector of fragment m/z values
#'   \item \code{into} - Numeric vector of corresponding intensity values
#' }
#' 
#' @details 
#' Each line in the input block should contain exactly two numeric values separated by whitespace.
#' The first value is parsed as m/z, the second as intensity. Non-numeric entries will result in NA values.
#' 
#' @examples 
#' \dontrun{
#' block <- c("100.0 500", "150.2 2500")
#' parseMS(block)
#' }
const parseMS = function(block) {
    const matrix    = as.vector(block) |> lapply(line -> as.numeric(strsplit(line, "\s+")));
    const mz        = sapply(matrix, r -> r[1]);
    const intensity = sapply(matrix, r -> r[2]);

    data.frame(
        "mz"   = mz, 
        "into" = intensity
    );
}
