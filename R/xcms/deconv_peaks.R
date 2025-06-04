#' method for export peakstable for both lcms and gcms
#' 
const deconv_peaks = function(rawfiles, workdir = "./", 
                              max_rtwin = 15, 
                              docker = NULL, 
                              n_threads = 8,
                              call_xcms = TRUE) {

    let xcms_out = file.path(workdir,"xcms");
    
    if (as.logical(call_xcms)) {
        let batch = rawfiles |> split(size = (length(rawfiles) / n_threads) - 1);
        let docker_id = docker;

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

    xcms_out |> __peak_alignment(max_rtwin, workdir);
}

const __peak_alignment = function(xcms_out, max_rtwin = 15, workdir="./") {
    let peakfiles = list.files(xcms_out, pattern = "*.csv");
    let peaktable = mzkit::make_peak_alignment(
        peakfiles = peakfiles, 
        max_rtwin = max_rtwin,
        mzdiff = 0.01
    );
    let rt_shifts = attr(peaktable, "rt.shift");

    write.csv(peaktable, file = file.path(workdir, "peaktable.csv"));
    write.csv(rt_shifts, file = file.path(workdir, "rt_shifts.csv"), 
        row.names = TRUE);

    let peakmeta = data.frame(
        mz = [peaktable]::mz, mzmin = [peaktable]::mzmin, mzmax = [peaktable]::mzmax,
        rt = [peaktable]::rt, rtmin = [peaktable]::rtmin, rtmax = [peaktable]::rtmax,
        RI = [peaktable]::RI,
        npeaks = [peaktable]::npeaks,
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