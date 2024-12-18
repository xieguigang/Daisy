
#' Open local annotation library file
#' 
#' @return IMetaDb
#' 
const open_biocad_local = function() {
    imports "annotation" from "mzkit";

    let file = system.file("data/biocad_registry.dat", package = "Daisy");
    let repo = annotation::open_repository(file);

    return(repo);
}

const open_local_gcms_EI = function() {
    
}