#' Run metabolite annotation search
#' 
#' @param files the file path to the rawdata files or a directory path that 
#'    should contains the avaiable mass spectrum data files.
#' @param peakfile the file path to the xcms peaktable file.
#' 
#' @details the input raw data files could be in data formats of:
#'   1. open source: mzXML, mzML
#'   2. panomix mzkit format: mzPack, PeakMs2
#' 
const make_annotation = function(files, peakfile, libtype = [1,-1], ms1ppm = 15, export_dir = "./", debug = FALSE) {
    let workflow = list(peakfile, libtype, ms1ppm, export_dir);

    if (dir.exists(files)) {
        files <- list.files(files, pattern = ["*.mzXML", "*.mzML", "*.mzPack", "*.PeakMs2"]);
    }

    print("get raw data files for run annotations:");
    print(basename(files));

    # run for each rawdata files
    if (debug) {
        for(let file in files) {
            dasy_task(file, as.list(workflow));
        }
    } else {
        stop("not implements!");
    }

    export_report(files, export_dir);
}