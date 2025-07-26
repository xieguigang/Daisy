#' Parse the cfm-id 4.0 spectra predicts result
#' 
#' @return a tuple list object that contains the prediction output, includes data slots with names:
#' 
#' 1. metadata the metadata of the prediction data inputs
#' 2. spectrum the predicts spectrum in different energy
#' 3. annotation the ms2 spectra peak annotation result 
#' 
#' @details 
#' 
#' PMass is the precursor mz of [M+H]+ or [M-H]-
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

#' Parse the ms2 spectrum fragment annotation information
#' 
#' @param lines the multiple lines of the text data
#' 
const .parse_annotation4 = function(lines) {
    lines = lapply(lines, l -> strsplit(l));

    data.frame(
        mz        = as.numeric(sapply(lines, i -> i[2])),
        peak_anno = sapply(lines, i -> i[3])
    );
}

#' Parse the ms2 predicted spectrum data
#' 
#' @param lines the multiple lines of the text data
#' 
#' @return ms2 spectrum data in multiple level of the collision energy
#' 
const .parse_spectrum4 = function(lines) {
    lines 
    |> split(line -> line == $"energy\d+") 
    |> which(block -> length(block) > 0) 
    |> lapply(Daisy::parseMS)
    ;
}

#' Parse the annotation metadata
#' 
#' @param lines the multiple lines of the text data
#' 
const .parse_metadata4 = function(lines) {
    let parse = lines 
    |> trim(" #") 
    |> tagvalue("=", as.list = TRUE)
    ;

    parse;
}