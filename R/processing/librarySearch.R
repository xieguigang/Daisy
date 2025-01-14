const call_librarysearch = function(peaks_ms2, libfiles = NULL, libtype = [1,-1], output = "./") {
    let [libs, metadb ] = __load_lcms_libs(list(libfiles = libfiles, libtype = libtype));
    let result = lapply(tqdm(peaks_ms2), function(sample) {
        libs 
        |> query(sample, top_hits = 9) 
        |> as.annotation_result(metadb)
        ;
    });

    unlist(result)
    |> as.data.frame()
    |> write.csv(file.path(output, "libsdata.csv"),row.names = FALSE)
    ;
}