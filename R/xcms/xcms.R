#' a simple tool for make extract peaks data via xcms
#' 
const xcms_findPeaks = function(raw_files, workdir = "./", docker = NULL) {
    let xcms_work = normalizePath( workdir);
    let run_xcms = function() {
        library(xcms);

        print("processing raw data files:");
        print(raw_files);
        cat("\n\n");

        for (file in raw_files) {
            print(sprintf("findPeaks: %s", file));

            let data   <- xcmsRaw(file);
            let xpeaks <- findPeaks(data,method="matchedFilter",fwhm=15);
            
            xpeaks <- as.data.frame(xpeaks);
            file <- sub("\\..*$", "", basename(file));
            file <- file.path(xcms_work, sprintf("%s.csv", file));
        
            print(sprintf("    => %s", file));
            # dump peaks data
            write.csv(xpeaks, file, row.names = FALSE);
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
}