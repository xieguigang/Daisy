const read_rawfile = function(files) {
    let read(file) = open.mzpack(file) |> ms2_peaks();

    files 
    |> lapply(path -> read(path))
    |> unlist()
    ;
}