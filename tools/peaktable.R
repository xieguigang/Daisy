require(Daisy);

const workdir = ?"--workdir" || "./";
const max_rtwin = ?"--rtwin" || 15.0;

file.path(workdir,"xcms") |> Daisy::__peak_alignment(max_rtwin, workdir);