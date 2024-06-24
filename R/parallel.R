const dasy_task = function(file, args) {
    args$rawdata = read_rawfile(file, cache_enable = TRUE);
    args$filename = basename(file);
    args$export_dir = file.path(args$export_dir, args$filename);
    args$peaks = read.xcms_peaks(args$peakfile,
        tsv = file.ext(args$peakfile) == "txt",
        general_method = TRUE);
    
    # run metadna at last
    call_metadna(
        peaks_ms2 = args$rawdata, 
        libtype = args$libtype, 
        ms1ppm = args$ms1ppm, 
        output = file.path(args$export_dir, "metadna"));
}