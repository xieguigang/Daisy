require(Daisy);

const raw_dir = ?"--raw_dir" || "./";
const output_dir = ?"--outputdir" || "./";
const rawfiles = list.files(raw_dir, pattern = ["*.mzXML", "*.mzML"]);

print("processing of the raw data files:");
print(rawfiles);

Daisy::deconv_peaks(rawfiles, workdir = output_dir, 
                            max_rtwin = 15, 
                            docker = NULL, 
                            n_threads = 8,
                            call_xcms = TRUE);