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

    let opt_cache_enable = TRUE;

    # get a collection of the mzkit peakms2 clr object
    # the precursor of the ms2 spectrum has not changed to ms1 peaks ion
    args$rawdata = read_rawfile(file, cache_enable = opt_cache_enable);
    args$filename = basename(file);
    args$export_dir = file.path(args$export_dir, args$filename);
    # get peak table data
    args$peaks = read.xcms_peaks(args$peakfile,
        tsv = file.ext(args$peakfile) == "txt",
        general_method = FALSE);

    let metadna_exports = file.path(args$export_dir, "metadna");
    let library_exports = file.path(args$export_dir, "libsearch");
    let dia_output = `${metadna_exports}/metaDNA.csv`; 
    let dda_output = `${library_exports}/libsdata.csv`;
    let ms1_da = args$ms1_da || 0.1;
    let rt_winsize = args$rt_winsize || 10;

    if (length(readLines(dda_output)) == 0 || !opt_cache_enable) {
        # run reference library search
        call_librarysearch(
            peaks_ms2 = args$rawdata, 
            libfiles = NULL, 
            libtype = args$libtype, 
            ms1ppm = args$ms1ppm, 
            output = library_exports);
    } else {
        print("use the cached dda library search result!");
    }

    if (length(readLines(dia_output)) == 0 || !opt_cache_enable) {
        # run metadna at last
        call_metadna(
            peaks_ms2 = args$rawdata, 
            libtype = args$libtype, 
            ms1ppm = args$ms1ppm, 
            output = metadna_exports);
    } else {
        print("use the cached metadna annotation result!");
    }

    let metadna_result = dia_output
    |> read.csv(row.names = NULL, check.names = FALSE) 
    # the annotation result dataframe required of mz and rt field
    |> peak_alignment(args$peaks, 
        mzdiff = ms1_da, 
        rt_win = rt_winsize)
    ;
    
    let dda_result = dda_output
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