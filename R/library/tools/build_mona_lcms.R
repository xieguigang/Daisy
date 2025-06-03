imports "massbank" from "mzkit";
imports "spectrumTree" from "mzkit";
imports "annotation" from "mzkit";

#' build lcms reference library for MoNA LC-MS dataset
#' 
#' @param repo a local directory path that contains multiple msp data files that 
#'    could be download from the MoNA database. 
#' 
const build_mona_lcms = function(repo, libdir = "./MoNA", metabolites = NULL) {
    # load the spectrum reference database files
    let spectra = read.MoNA(repo, lazy = FALSE);
    let metadata = open_repository(file.path(libdir,"metadata.dat"), mode = "write");
    let libpos = spectrumTree::new(file.path(libdir,"lib.pos.pack"), "Pack");
    let libneg = spectrumTree::new(file.path(libdir,"lib.neg.pack"), "Pack");

    if (is.null(metabolites)) {
        # extract the metabolite information 
        # from the external spectrum reference database files
        metabolites <- extract_mona_metabolites(mona = spectra)
    }

    attr(metabolites, "mapping")
    |> JSON::json_encode()
    |> writeLines(con = file.path(libdir,"mapping.json"))
    ;

    print("write metabolite database...");
    write_metadata(metadata, meta = metabolites);

    print("write reference spectrum database...");
    for(let spec in tqdm(spectra)) {
        if (nchar([spec]::formula) > 0) {
            ifelse(is_positive(spec), libpos, libneg) |> write_mona(spec);
        }
    }

    close(libpos);
    close(libneg);
    close(metadata);

    print(" ~Job done!");
}