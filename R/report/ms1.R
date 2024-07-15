#' MS1 annotation of the peaks
#' 
#' @param peaks the mzkit peakSet object, ms1 peaks table.
#' 
const ms1_anno = function(peaks, ms1ppm = 10, libtype = [1,-1]) {
    let adducts = get_adducts(libtype); 
}