#' Perform peak detection using XCMS
#'
#' Detects peaks in raw MS files using XCMS matchedFilter algorithm.
#'
#' @param raw_files Character vector of raw data files (mzXML/mzML format).
#' @param workdir Output directory for peak CSV files (default: "./").
#' @param docker Docker image ID for execution environment (optional).
#'
#' @return Invisibly returns NULL. Outputs CSV peak files in \code{workdir},
#'         one per input file (named using original basename).
#'
#' @details Uses either:
#' \enumerate{
#'   \item Docker container execution (if \code{docker} provided)
#'   \item Native R environment via \code{REnv::rlang_interop()}
#' }
#' 
#' @note Files are only processed if output CSV doesn't exist or is empty.
const xcms_findPeaks = function(raw_files, workdir = "./", docker = NULL) {
    let xcms_work = normalizePath( workdir);
    let run_xcms = function() {
        library(xcms);

        print("processing raw data files:");
        print(raw_files);
        cat("\n\n");

        # function for call xcms method in native R environment

        for (file in raw_files) {
            print(sprintf("findPeaks: %s", file));

            let peakfile <- sub("\\..*$", "", basename(file));
            peakfile <- file.path(xcms_work, sprintf("%s.csv", peakfile));

            if (!(file.exists(peakfile) && length(readLines(peakfile)) > 1)) {
                let data   <- xcmsRaw(file);
                let xpeaks <- findPeaks(data,method="matchedFilter",fwhm=15);
                
                xpeaks <- as.data.frame(xpeaks);
            
                print(sprintf("    => %s", peakfile));
                # dump peaks data
                write.csv(xpeaks, peakfile, row.names = FALSE);
            }
        }
    }

    if (nchar(docker) > 0) {
        let vols = list();
        let rawdata_dir = unique(dirname(raw_files));

        for(dir in rawdata_dir) {
            vols[[dir]] <- dir;
        }

        # run via docker environment
        Darwinism::run_rlang_interop(
            run_xcms, 
            image = docker, 
            source = [], 
            debug = getOption("debug", default = FALSE), 
            workdir = workdir, 
            mount = vols
        );
    } else {
        # just call system
        REnv::rlang_interop(run_xcms, 
            source = [], 
            debug = getOption("debug", default = FALSE), 
            workdir = workdir,
            print_code = TRUE);
    }

    invisible(NULL);
}