#' load gcms library in mona msp file format
#' 
#' @param mspfile the filepath to the msp library file
#' 
#' @return a cluster tree of the reference spectrum for make spectrum 
#'   similarity search.
#' 
const gcms_mona_msp = function(mspfile) {
    imports "massbank" from "mzkit";
    imports "annotation" from "mzkit";

    let mona = massbank::read.MoNA(mspfile, is_gcms =TRUE,lazy=FALSE);
    let library = annotation::library_from_mona(mona = mona);

    library;
}