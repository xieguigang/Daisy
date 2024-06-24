const dasy_task = function(file, args) {
    args$rawdata = read_rawfile(file, cache_enable = TRUE);
    args$filename = basename(file);
    args$peaks = read.xcms_peaks(args$peakfile,
        tsv = file.ext(args$peakfile) == "txt",
        general_method = TRUE);
    
}