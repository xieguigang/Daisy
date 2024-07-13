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

    let metadna_result = `${metadna_exports}/metadna/metaDNA.csv` 
    |> read.csv(row.names = NULL, check.names = FALSE) 
    |> peak_alignment(metadna, args$peaks, 
        mzdiff = 0.01, rt_win = 15);

    let result = rbind(dda_result, metadna_result);

    write.csv(result, file = file.path(args$export_dir, "result.csv"), 
        row.names = FALSE);
}