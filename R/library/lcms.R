#' load lcms library database
#' 
const __load_lcms_libs = function(argv = list(libfiles = NULL, libtype = [1,-1])) {
    let libs = (argv$libfiles) || "/opt/libs/MoNA/";
    let libtype = .Internal::first(as.integer(argv$libtype || 1));
    let libfile = ifelse(libtype == 1, "lib.pos.pack", "lib.neg.pack");
    let metadb = file.path(libs, "metadata.dat");
    let mapfile = file.path(libs, "mapping.json");

    libfile <- file.path(libs, libfile);
    libfile <- spectrumTree::open(libfile, dotcutoff = 0.6, adducts = get_adducts(libtype));
    mapfile <- JSON::json_decode(readText(mapfile));
    metadb <- annotation::open_repository(metadb, mode = "read", mapping = mapfile);

    list(libs = libfile, metadb = metadb);
}