#' Convert named list to tabular data frame
#' 
#' This helper function transforms a named list into a structured data frame 
#' by mapping specified keys to columns. Ideal for converting nested list 
#' structures into rectangular data formats.
#'
#' @param list A named list containing the data to be converted. Each element 
#'        should correspond to a column in the output data frame.
#' @param keys Character vector specifying the names of list elements to extract 
#'        as columns. Must match existing names in `list`.
#'
#' @return A [data.frame] object where: 
#'         - Column names correspond to `keys`
#'         - Each column contains values from `list` elements
#'         - Row count matches the length of list elements
#'
#' @examples
#' # Basic usage
#' my_list <- list(name = c("Alice", "Bob"), age = c(28, 32))
#' tabular(my_list, keys = c("name", "age"))
#' 
#' # Partial key mapping
#' tabular(my_list, keys = "name")
#'
#' @note 
#' 1. All elements specified in `keys` must exist in `list`
#' 2. List elements should be vectors of equal length to avoid recycling
#' 3. Uses base R data.frame operations for compatibility
#' 
#' @export
#' @keywords internal
#' @family data transformation functions
const tabular = function(list, keys) {
    let df = data.frame();

    for(let name in keys) {
        df[, name] <- list@{name};
    }

    return(df);
}