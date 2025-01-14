require(Daisy);

setwd(@dir);

let args = list(
    rawdata = read_rawfile("./pos/L9.PeakMs2", cache_enable = TRUE),
    filename = "L9",
    export_dir = "./L9_test",
    # get peak table data
    peaks = read.xcms_peaks("./pos.csv",
        tsv = FALSE,
        general_method = FALSE)
);
let library_exports = args$export_dir;

call_librarysearch(
        peaks_ms2 = args$rawdata, 
        libfiles = "E:/biodeep/mona/libs", 
        libtype = 1, 
        ms1ppm = 15, 
        output = library_exports);