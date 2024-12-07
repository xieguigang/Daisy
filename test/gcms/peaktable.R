require(mzkit);

setwd(@dir);

let peaksdata = mzkit::make_peak_alignment(peakfiles = list.files("xcms", pattern = "*.csv"), max_rtwin = 15,mzdiff = 0.01);

write.csv(peaksdata, file = "./peaktable.csv");