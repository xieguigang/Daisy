#' A annotation task for a single rawdata file
#' 
#' @param file the file path character vector of the rawdata file, should 
#'    be in file format of mzkit supported mzXML/mzML/mzPack. 
#' @param args the workflow arguments for run this annotation.
#' 
const dasy_task = function(file, args = list(
        export_dir = "./", 
        peakfile   = "./peaksdata.csv",
        ms1_da     = 0.1, 
        rt_winsize = 10, 
        libtype    = 1, 
        ms1ppm     = 15)) {

    # get a collection of the mzkit peakms2 clr object
    # the precursor of the ms2 spectrum has not changed to ms1 peaks ion
    args$rawdata = read_rawfile(file, cache_enable = TRUE);
    args$filename = basename(file);
    args$export_dir = file.path(args$export_dir, args$filename);
    # get peak table data
    args$peaks = read.xcms_peaks(args$peakfile,
        tsv = file.ext(args$peakfile) == "txt",
        general_method = FALSE);

    let metadna_exports = file.path(args$export_dir, "metadna");
    let library_exports = file.path(args$export_dir, "libsearch");
    let ms1_da = args$ms1_da || 0.1;
    let rt_winsize = args$rt_winsize || 10;

    # run reference library search
    call_librarysearch(
        peaks_ms2 = args$rawdata, 
        libfiles = NULL, 
        libtype = args$libtype, 
        ms1ppm = args$ms1ppm, 
        output = library_exports);

    # run metadna at last
    call_metadna(
        peaks_ms2 = args$rawdata, 
        libtype = args$libtype, 
        ms1ppm = args$ms1ppm, 
        output = metadna_exports);

    let metadna_result = `${metadna_exports}/metaDNA.csv` 
    |> read.csv(row.names = NULL, check.names = FALSE) 
    # the annotation result dataframe required of mz and rt field
    |> peak_alignment(args$peaks, 
        mzdiff = ms1_da, 
        rt_win = rt_winsize)
    ;
    
    let dda_result = `library_exports/libsdata.csv`
    |> read.csv(row.names = NULL, check.names = FALSE) 
    # the annotation result dataframe required of mz and rt field
    |> peak_alignment(args$peaks, 
        mzdiff = ms1_da, 
        rt_win = rt_winsize)
    ;

    let result = rbind(dda_result, metadna_result);

    result[, "rawfile"] = args$filename; 

    write.csv(result, file = file.path(args$export_dir, "result.csv"), 
        row.names = FALSE);
}