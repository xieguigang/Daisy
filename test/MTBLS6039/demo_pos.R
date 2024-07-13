require(Daisy);

Daisy::make_annotation(
    files = file.path(@dir, "pos"), 
    peakfile = file.path(@dir, "pos.csv"), 
    libtype = 1, 
    ms1ppm = 15, 
    export_dir = file.path(@dir, "result_outputs","pos"),
    debug = TRUE
);