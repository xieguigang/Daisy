const dasy_task = function(file, args) {
    args$rawdata = read_rawfile(file, cache_enable = TRUE);
    args$filename = basename(file);
    
}