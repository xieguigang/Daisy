require(Daisy);

Daisy::make_annotation(
    files = file.path(@dir, "demo_data"), 
    peakfile = file.path(@dir, "demo_data/peaktable.csv"), 
    libtype = 1, 
    ms1ppm = 15, 
    export_dir = file.path(@dir, "result_outputs"),
    debug = TRUE
);