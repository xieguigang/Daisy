require(Daisy);

let peakfile = "M:\project\blood_20250617_LLMs\lcms_output\tmp\workflow_tmp\rawdata\pos\peakmeta.csv";
let peaks = read.xcms_peaks(peakfile,
        tsv = file.ext(peakfile) == "txt",
        general_method = FALSE);