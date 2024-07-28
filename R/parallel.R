#' A annotation task for a single rawdata file
#' 
#' @param file the file path character vector of the rawdata file, should 
#'    be in file format of mzkit supported mzXML/mzML/mzPack. 
#' @param args the workflow arguments for run this annotation.
#' 
const dasy_task = function(file, args) {
    args$rawdata = read_rawfile(file, cache_enable = TRUE);
    args$filename = basename(file);
    args$export_dir = file.path(args$export_dir, args$filename);
    args$peaks = read.xcms_peaks(args$peakfile,
        tsv = file.ext(args$peakfile) == "txt",
        general_method = FALSE);

    let metadna_exports = file.path(args$export_dir, "metadna");
    let dda_result = NULL;

    # run metadna at last
    call_metadna(
        peaks_ms2 = args$rawdata, 
        libtype = args$libtype, 
        ms1ppm = args$ms1ppm, 
        output = metadna_exports);

    let metadna_result = `${metadna_exports}/metaDNA.csv` 
    |> read.csv(row.names = NULL, check.names = FALSE) 
    |> peak_alignment(args$peaks, 
        mzdiff = 0.01, rt_win = 15);

    let result = rbind(dda_result, metadna_result);

    result[, "rawfile"] = args$filename; 

    write.csv(result, file = file.path(args$export_dir, "result.csv"), 
        row.names = FALSE);
}