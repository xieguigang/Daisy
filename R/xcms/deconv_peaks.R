#' Perform peak detection and alignment for LC-MS/GC-MS data
#'
#' This function processes raw MS data files using parallelized XCMS peak detection 
#' (if enabled) and performs peak alignment across samples to generate a peak table.
#'
#' @param rawfiles Character vector of raw data files (mzXML or mzML format).
#' @param workdir Output directory for results (default: "./").
#' @param max_rtwin Maximum retention time window (seconds) for peak alignment (default: 15).
#' @param docker Docker image ID for XCMS execution environment (optional).
#' @param n_threads Number of threads for parallel processing (default: 8).
#' @param call_xcms Logical indicating whether to run XCMS peak detection (default: TRUE).
#'                 If FALSE, only alignment is performed using existing XCMS output.
#'
#' @return Invisibly returns NULL. Outputs the following files in \code{workdir}:
#' \itemize{
#'   \item \strong{peaktable.csv} - Aligned peak feature table
#'   \item \strong{rt_shifts.csv} - Retention time shift corrections
#'   \item \strong{peakmeta.csv} - Peak metadata (mz, RT, intensity, etc.)
#'   \item \strong{rt_shifts.pdf} - Visualization of retention time shifts
#'   \item \strong{peakset.pdf} - Peak distribution visualization
#' }
#' 
#' @details The processing pipeline involves two main steps:
#' \enumerate{
#'   \item \strong{XCMS Peak Detection:} When \code{call_xcms = TRUE}, runs 
#'         \code{xcms_findPeaks()} in parallel batches using matchedFilter algorithm.
#'   \item \strong{Peak Alignment:} Aligns peaks across samples using specified RT window 
#'         and outputs consolidated results.
#' }
#'
#' @seealso \code{\link{xcms_findPeaks}}, \code{\link{__peak_alignment}}
const deconv_peaks = function(rawfiles, workdir = "./", 
                              max_rtwin = 15, 
                              docker = NULL, 
                              n_threads = 8,
                              call_xcms = TRUE) {

    let xcms_out = file.path(workdir,"xcms");
    
    if (as.logical(call_xcms)) {
        let batch = rawfiles |> split(size = (length(rawfiles) / n_threads) - 1);
        let docker_id = docker;

        print("run xcms with n_threads:");
        str(n_threads);
        print("view rawdata file batch:");
        str(batch);

        # run in parallel for production
        Parallel::parallel(raw_file = batch, n_threads = n_threads, 
                ignoreError = FALSE, 
                debug = FALSE,
                log_tmp = `${xcms_out}/.local_debug/`) {

            require(Daisy);

            let filepath <- unlist(raw_file);

            # view verbose debug echo 
            print("get batch of rawdata files for processing:");
            print(` -> ${basename(filepath)}`);            

            # processing a batch list of rawdata file
            # findPeaks via xcms package
            Daisy::xcms_findPeaks(
                filepath, 
                workdir = unlist(xcms_out), 
                docker = unlist(docker_id)
            );
        }
    }

    print("call native R xcms job done! run peaktable assembly!");

    xcms_out |> __peak_alignment(max_rtwin, workdir);
}

#' (Internal) Perform peak alignment across samples
#'
#' Aligns detected peaks from multiple samples and generates output files.
#'
#' @param xcms_out Directory containing XCMS peak CSV files.
#' @param max_rtwin Maximum retention time window (seconds) for peak matching.
#' @param workdir Output directory for generated files (default: "./").
#'
#' @return Invisibly returns NULL. Generates:
#' \itemize{
#'   \item Consolidated peak table (peaktable.csv)
#'   \item Retention time shift data (rt_shifts.csv)
#'   \item Peak metadata (peakmeta.csv)
#'   \item Diagnostic plots (rt_shifts.pdf, peakset.pdf)
#' }
#' 
#' @keywords internal
const __peak_alignment = function(xcms_out, max_rtwin = 15, workdir="./") {
    let peakfiles = list.files(xcms_out, pattern = "*.csv");
    let peaktable = mzkit::make_peak_alignment(
        peakfiles = peakfiles, 
        max_rtwin = max_rtwin,
        mzdiff = 0.01
    );
    let rt_shifts = attr(peaktable, "rt.shift");
    let peaksarea = as.data.frame(peaktable, peaks_area = TRUE); 

    write.csv(peaktable, file = file.path(workdir, "peaktable.csv"));
    write.csv(rt_shifts, file = file.path(workdir, "rt_shifts.csv"), 
        row.names = TRUE);

    peaksarea <- apply(peaksarea, margin = "row", FUN = sum);

    print("sum peak area for each peak features:");
    print(peaksarea);

    let peakmeta = data.frame(
        mz = [peaktable]::mz, mzmin = [peaktable]::mzmin, mzmax = [peaktable]::mzmax,
        rt = [peaktable]::rt, rtmin = [peaktable]::rtmin, rtmax = [peaktable]::rtmax,
        RI = [peaktable]::RI,
        npeaks = [peaktable]::npeaks,
        into = peaksarea,
        row.names = [peaktable]::ID
    );

    print("view of the lcms peaks ROI metadata:");
    print(peakmeta, max.print = 6);

    write.csv(peakmeta, file = file.path(workdir, "peakmeta.csv"), 
        row.names = TRUE);

    pdf(file = file.path(workdir, "rt_shifts.pdf"), size = [4000, 2700], padding = [50 650 200 200]) {
        plot(rt_shifts, res = 1000, grid.fill = "white");
    }
    pdf(file = file.path(workdir, "peakset.pdf")) {
        plot(as.peak_set(peakmeta), scatter = TRUE, 
            dimension = "npeaks");
    }

    invisible(NULL);
}