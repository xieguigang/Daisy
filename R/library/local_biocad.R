
#' Open local annotation library file
#' 
#' @return IMetaDb
#' 
const open_biocad_local = function() {
    imports "annotation" from "mzkit";

    let file = system.file("data/biocad_registry.dat", package = "Daisy");
    let repo = annotation::open_repository(file, mode = "read");

    return(repo);
}

const open_local_gcms_EI = function() {
    imports "spectrumTree" from "mzkit";

    let file = system.file("data/EI_pos.pack", package = "Daisy");
    let repo = spectrumTree::open(file);

    return(repo);
}

const local_gcms_lib = function() {
    imports "annotation" from "mzkit";

    # create clr library object
    annotation::load_local(
        open_biocad_local(), 
        open_local_gcms_EI(),
        tqdm_verbose = FALSE
    );
}