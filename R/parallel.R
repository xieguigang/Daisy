#' A annotation task for a single rawdata file
#' 
#' @param file the file path character vector of the rawdata file, should 
#'    be in file format of mzkit supported mzXML/mzML/mzPack. 
#' @param args the workflow arguments for run this annotation.
#' 
const dasy_task = function(file, args = list(
        export_dir  = "./", 
        peakfile    = "./peaksdata.csv",
        library_dir = NULL,
        ms1_da      = 0.1, 
        rt_winsize  = 10, 
        libtype     = 1, 
        ms1ppm      = 15,
        waters      = FALSE,
        metadna     = TRUE)) {

    let opt_cache_enable = TRUE;

    # get a collection of the mzkit peakms2 clr object
    # the precursor of the ms2 spectrum has not changed to ms1 peaks ion
    args$rawdata = read_rawfile(file, cache_enable = opt_cache_enable);
    args$filename = basename(file);
    args$export_dir = file.path(args$export_dir, args$filename);
    # get peak table data
    args$peaks = read.xcms_peaks(args$peakfile,
        tsv = file.ext(args$peakfile) == "txt",
        general_method = FALSE);

    let metadna_exports = file.path(args$export_dir, "metadna");
    let library_exports = file.path(args$export_dir, "libsearch");
    let dia_output = `${metadna_exports}/metaDNA.csv`; 
    let dda_output = `${library_exports}/libsdata.csv`;
    let ms1_da = args$ms1_da || 0.1;
    let rt_winsize = args$rt_winsize || 10;
    let metadna_search = args$metadna;

    if (args$waters) {
        # there is a bug of the precursor ion info in waters rawdata
        # no precursor for make kegg metabolite matches
        metadna_search = FALSE;
    }

    if (length(readLines(dda_output,strict=FALSE)) == 0 || !opt_cache_enable) {
        # run reference library search
        call_librarysearch(
            peaks_ms2 = args$rawdata, 
            libfiles = args$library_dir, 
            libtype = args$libtype, 
            ms1ppm = args$ms1ppm, 
            output = library_exports,
            waters = args$waters);
    } else {
        print("use the cached dda library search result!");
    }

    if (metadna_search) {
        if (length(readLines(dia_output,strict=FALSE)) == 0 || !opt_cache_enable) {
            # run metadna at last
            call_metadna(
                peaks_ms2 = args$rawdata, 
                libtype = args$libtype, 
                ms1ppm = args$ms1ppm, 
                output = metadna_exports);
        } else {
            print("use the cached metadna annotation result!");
        }
    } else {
        print("skip of the metadna networking search.");
    }

    let ms1ppm = as.numeric(args$ms1ppm ||15);
    let metadna_result = dia_output
    |> read.csv(row.names = NULL, check.names = FALSE);

    metadna_result <- data.frame(
        metabolite_id = metadna_result$KEGGId,
        name = metadna_result$name,
        formula = metadna_result$formula,
        exact_mass = metadna_result$exactMass,
        chebi = "",
        pubchem = "",
        cas = "",
        kegg = metadna_result$KEGGId,
        hmdb = "",
        lipidmaps = "",
        mesh = "",
        inchikey = "",
        inchi = "",
        smiles = "",
        kingdom = "",
        super_class = "",
        class = "",
        sub_class = "",
        molecular_framework = "",
        forward = metadna_result$forward,
        reverse = metadna_result$reverse,
        jaccard = metadna_result$jaccard,
        entropy = metadna_result$entropy,
        mz = metadna_result$mz,
        rt = metadna_result$rt,
        intensity = metadna_result$intensity,
        evidence = metadna_result$reaction,
        alignment = metadna_result$alignment
    ) 
    # the annotation result dataframe required of mz and rt field
    |> Daisy::peak_alignment(args$peaks, 
        mzdiff = ms1_da, 
        rt_win = rt_winsize,
        ms1ppm = ms1ppm, libtype = args$libtype )
    ;
    
    let dda_result = dda_output
    |> read.csv(row.names = NULL, check.names = FALSE) 
    # the annotation result dataframe required of mz and rt field
    |> Daisy::peak_alignment(args$peaks, 
        mzdiff = ms1_da, 
        rt_win = rt_winsize,
        ms1ppm = ms1ppm, libtype = args$libtype)
    ;

    print("inspect of the reference library search result:");
    str(dda_result);

    print("inspect of the metadna result:");
    str(metadna_result);

    metadna_result[, "source"] = "metadna";
    dda_result[,"source"] = "reference_library";
    
    let result = rbind(dda_result, metadna_result);

    result[, "rawfile"] = args$filename; 

    write.csv(result, file = file.path(args$export_dir, "result.csv"), 
        row.names = FALSE);
}