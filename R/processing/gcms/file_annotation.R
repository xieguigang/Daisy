

const __gcms_file_annotation = function(filepath, peaktable,work_pars) {
    let outputdir = work_pars$outputdir;
    let checkfile = file.path(outputdir,`${basename(filepath)}.csv`);

    if (!file.exists(checkfile)) {
        let ions = Daisy::read_gcmsdata(filepath, peaktable);

        if (is.null(work_pars$libfiles)) {
            # default internal
            let msp = system.file("data/MoNA-export-GC-MS_Spectra.msp", package = "Daisy");

            Daisy::__gcms_annotation(filepath, ions, 
                libname = basename(msp),
                libs = Daisy::gcms_mona_msp(msp, libtype = work_pars$libtype), 
                argv = work_pars);
            Daisy::__gcms_annotation(filepath, ions, 
                libname = "biocad_registry",
                libs = Daisy::local_gcms_lib(), 
                argv = work_pars);

        } else {
            # load external msp file
            for(let libfile in work_pars$libfiles) {
                # processing a single rawdata file
                Daisy::__gcms_annotation(filepath, ions, 
                    libname = basename(libfile),
                    libs = Daisy::gcms_mona_msp(libfile, libtype = work_pars$libtype), 
                    argv = work_pars);
            }
        }

        print("make result file union...");

        # merge library result
        let tempfiles = file.path(work_pars$outputdir,"tmp",basename(filepath)) |> list.files(pattern = "*.csv");
        let tempdata = as.list(tempfiles, basename(tempfiles)) |> lapply(path -> read.csv(path, row.names = NULL, check.names = FALSE));
        let union = bind_rows(tempdata);

        write.csv(union, file = checkfile, row.names = FALSE);
    } else {
        print("skip of the cached result file!");
    }
}