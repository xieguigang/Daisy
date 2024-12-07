require(Daisy);

setwd(@dir);

let peakdata = read.csv("./peaktable.csv", row.names = 1, check.names = FALSE);
let rawfiles = list.files("./rawdata", pattern = "*.mzML");

