#' Run metabolite annotation search
#' 
#' @param files the file path to the rawdata files or a directory path that 
#'    should contains the avaiable mass spectrum data files.
#' @param peakfile the file path to the xcms peaktable file.
#' @param libtype the ion polarity mode of the rawdata files, should be an
#'    integer vector of 1 for positive and -1 for negative raw data.
#' @param export_dir a character vector of the directory path for output 
#'    the annotation result files.
#' @param n_threads the number of the cpu threads for run for the 
#'    parallel compute.
#' 
#' @details the input raw data files could be in data formats of:
#'   1. open source: mzXML, mzML
#'   2. panomix mzkit format: mzPack, PeakMs2
#' 
const make_annotation = function(files, peakfile, libtype = [1,-1], ms1ppm = 15, 
                                 export_dir  = "./", 
                                 library_dir = NULL,
                                 n_threads   = 8, 
                                 waters      = FALSE,
                                 metadna     = TRUE,
                                 do_plot     = TRUE,
                                 id_range    = NULL,
                                 debug       = FALSE) {

    let workflow = list(
        peakfile, libtype, ms1ppm, export_dir, library_dir, 
        waters, 
        metadna,
        id_range
    );

    if (dir.exists(files)) {
        files <- list.files(files, pattern = ["*.mzXML", "*.mzML", "*.mzPack", "*.PeakMs2"]);
    }

    print("get raw data files for run annotations:");
    print(basename(files));
    print("run daisy annotation with cpu processor threads:");
    print(n_threads);

    # run for each rawdata files
    if (debug || as.integer(n_threads) == 1) {
        # run in sequantial for debug
        for(let file in files) {
            dasy_task(file, as.list(workflow));
        }
    } else {
        # run in parallel for production
        Parallel::parallel(raw_file = files, n_threads = n_threads, 
                ignoreError = FALSE, 
                debug = FALSE,
                log_tmp = `${export_dir}/tmp/.local_debug/parallel_slave/`) {            

            let filepath <- unlist(raw_file);
            let result_table = file.path(workflow$export_dir, basename(filepath), "result.csv");

            if (!file.exists(result_table)) {
                require(Daisy);

                sink(file = file.path(workflow$export_dir, "tmp", "logs", `${basename(filepath)}.log`));            
                # view verbose debug echo 
                print(` -> ${filepath}`);
                str(workflow);

                # processing a single rawdata file
                Daisy::dasy_task(filepath, workflow);

                sink();
            }
        }
    }

    export_report(files, export_dir, do_plot = do_plot);
}