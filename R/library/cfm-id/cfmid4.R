#' Parse CFM-ID 4.0 spectral prediction output
#'
#' @description 
#' Processes complete output from CFM-ID 4.0 predictions, extracting metadata, 
#' spectrum data at different energy levels, and peak annotations.
#'
#' @param str_output Character string containing the full CFM-ID prediction output text.
#'
#' @return A named list containing three components:
#' \itemize{
#'   \item \code{metadata} - List of key-value pairs from the prediction metadata header
#'   \item \code{spectrum} - List of dataframes, each containing MS2 spectrum data for an energy level
#'   \item \code{annotation} - Dataframe containing peak annotations
#' }
#'
#' @details 
#' Output structure must contain:
#' 1. Metadata lines starting with "#" at beginning
#' 2. Spectrum data block (whitespace separated m/z-intensity pairs)
#' 3. Annotation block (whitespace separated m/z-annotation pairs)
#' 
#' The precursor mass (PMass) in metadata represents [M+H]+ or [M-H]- ion.
#' 
const parse_cfmid4_predicts = function(str_output) {
    let lines = textlines(str_output);
    let i     = lines == $"[#].+";
    let meta  = lines[i];

    lines = lines[!i];

    let blocks   = split(lines, l -> l == ""); 
    let spectrum = as.vector(blocks[1]);
    let annos    = as.vector(blocks[2]);

    print(`metadata lines:`);
    print(meta);
    print("get spectrum predictions:");
    str(spectrum);
    print("get annotation text of the peaks:");
    str(annos);

    list(
        metadata   = .parse_metadata4(meta),
        spectrum   = .parse_spectrum4(spectrum),
        annotation = .parse_annotation4(annos)
    );
}

#' Parse MS2 fragment annotations
#'
#' @description 
#' Processes fragment annotation lines from CFM-ID output, extracting m/z values and peak annotations.
#' 
#' @param lines Character vector where each element contains whitespace-separated values 
#' (expected format: peak_index, m/z value, annotation text).
#' 
#' @return Dataframe containing:
#' \itemize{
#'   \item \code{mz} - Numeric vector of fragment m/z values
#'   \item \code{peak_anno} - Character vector of corresponding peak annotations
#' }
#' 
#' @details 
#' Input lines should contain at least three whitespace-separated columns. 
#' Second column is parsed as m/z, third column as annotation text.
#' 
const .parse_annotation4 = function(lines) {
    lines = lapply(lines, l -> strsplit(l));

    data.frame(
        mz        = as.numeric(sapply(lines, i -> i[2])),
        peak_anno = sapply(lines, i -> i[3])
    );
}

#' Parse multi-energy spectra blocks
#'
#' @description 
#' Splits spectrum data into collision energy-specific blocks and parses each block.
#'
#' @param lines Character vector of spectrum data lines, with energy headers ("energyX") 
#' separating different collision energy blocks.
#'
#' @return List of dataframes, each dataframe contains spectrum data for one collision energy level.
#' 
#' @details 
#' Energy headers must match the pattern "energy\\d+" (e.g., "energy0"). 
#' Blocks without valid headers will be ignored.
#' 
const .parse_spectrum4 = function(lines) {
    lines 
    |> split(line -> line == $"energy\d+") 
    |> which(block -> length(block) > 0) 
    |> lapply(Daisy::parseMS)
    ;
}

#' Parse metadata from header lines
#'
#' @description 
#' Processes metadata lines from CFM-ID output header, converting key-value pairs to a list.
#'
#' @param lines Character vector of metadata lines (each starting with "#" prefix)
#'
#' @return Named list containing metadata parameters. 
#' Keys are derived from text before "=", values are converted to appropriate types.
#' 
#' @details 
#' Performs automatic type conversion:
#' \itemize{
#'   \item Numeric values converted to numeric type
#'   \item "TRUE/FALSE" converted to logical
#'   \item Other values remain as character strings
#' }
#' 
const .parse_metadata4 = function(lines) {
    let parse = lines 
    |> trim(" #") 
    |> tagvalue("=", as.list = TRUE)
    ;

    parse;
}