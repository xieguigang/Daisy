require(Daisy);

Daisy::make_annotation(
    files = file.path(@dir, "0001.mzXML"), 
    peakfile = file.path(@dir, "ms1.csv"), 
    libtype = 1, 
    ms1ppm = 15, 
    export_dir = file.path(@dir, "result_outputs"),
    debug = TRUE
);