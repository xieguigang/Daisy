#' reference library search based spectrum annotation
#' 
const call_librarysearch = function(peaks_ms2, libfiles = NULL, libtype = [1,-1], output = "./", waters = FALSE) {
    # libs is the reference spectrum library
    # metadb is the metabolite annotation respotiory object
    let [libs, metadb ] = __load_lcms_libs(list(libfiles = libfiles, 
                                                libtype = libtype, 
                                                waters = waters)
    );
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

#' load the metabolite annotation data repository
#'
const resolve_metadb = function(libfiles = NULL, libtype = [1,-1], waters = FALSE) {
    let [libs, metadb ] = __load_lcms_libs(list(libfiles = libfiles, 
                                                libtype = libtype, 
                                                waters = waters),
        load_spectrum = FALSE
    );

    return(metadb );
}