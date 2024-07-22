#' rawdata file processor
#' 
const read_rawfile = function(file, cache_enable = TRUE) {
    let cache_file = file.path(dirname(file), `${basename(file)}.cache`);
    let load_raw = function() {
        # read rawdata file by a unify method
        let ms2data = open.mzpack(file) |> ms2_peaks();
        # cache file could be read from next run
        mzweb::write.cache(ms2data, cache_file);
        ms2data;
    }

    if (file.ext(file) == "peakms2") {
        # spectrum in ms2, which already been processed
        mzweb::read.cache(file);
    } else {
        if (cache_enable && file.exists(cache_file)) {
            # deal with the incorrect cache file
            try(ex -> mzweb::read.cache(cache_file)) {
                load_raw();
            };
        } else {
            load_raw();
        }
    }
}