imports "massbank" from "mzkit";
imports "spectrumTree" from "mzkit";
imports "annotation" from "mzkit";

#' build lcms reference library for MoNA LC-MS dataset
#' 
#' @param repo a local directory path that contains multiple msp data files that 
#'    could be download from the MoNA database. 
#' 
const build_mona_lcms = function(repo, libdir = "./MoNA") {
    let spectra = read.MoNA(repo, lazy = FALSE);
    let metabolites = extract_mona_metabolites(mona = spectra);
    let metadata = open_repository(file.path(libdir,"metadata.dat"), mode = "write");
    let libpos = spectrumTree::new(file.path(libdir,"lib.pos.pack"), "Pack");
    let libneg = spectrumTree::new(file.path(libdir,"lib.neg.pack"), "Pack");

    attr(metabolites, "mapping")
    |> JSON::json_encode()
    |> writeLines(con = file.path(libdir,"mapping.json"))
    ;

    write_metadata(metadata, meta = metabolites);

    close(metadata);
}