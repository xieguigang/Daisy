#' load lcms library database
#' 
#' @return a tuple list of the reference library data:
#' 
#'  1. libs - the reference spectrum library
#'  2. metadb - the metabolite annotation repository 
#' 
const __load_lcms_libs = function(argv = list(libfiles = NULL, libtype = [1,-1], waters = FALSE)) {
    let libs = (argv$libfiles) || "/opt/libs/MoNA/";
    let libtype = .Internal::first(as.integer(argv$libtype || 1));
    let libfile = ifelse(libtype == 1, "lib.pos.pack", "lib.neg.pack");
    let metadb = file.path(libs, "metadata.dat");
    let mapfile = file.path(libs, "mapping.json");

    libfile <- file.path(libs, libfile);
    libfile <- spectrumTree::open(libfile, dotcutoff = 0.6, adducts = get_adducts(libtype));
    mapfile <- JSON::json_decode(readText(mapfile));
    metadb <- annotation::open_repository(metadb, mode = "read", mapping = mapfile);

    # 20250420 there is a precursor ion bug for proteowizard 
    # make conversion of the waters rawdata file
    if (as.logical(argv$waters)) {
        print("disable precursor filter for processing waters rawdata.");
        print("the library search job will be very long!");

        libfile |> discard_precursor_filter();
    }

    list(libs = libfile, metadb = metadb);
}