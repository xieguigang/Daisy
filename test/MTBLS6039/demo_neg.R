require(Daisy);

Daisy::make_annotation(
    files = file.path(@dir, "neg"), 
    peakfile = file.path(@dir, "neg.csv"), 
    libtype = 1, 
    ms1ppm = 15, 
    export_dir = file.path(@dir, "result_outputs","neg"),
    debug = TRUE
);