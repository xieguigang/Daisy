const export_report = function(files, export_dir) {
    let names = basename(files);
    let result = NULL;

    for(let file in `${export_dir}/${names}/result.csv`) {
        file = read.csv(file, row.names = NULL, check.names = FALSE);
        result = rbind(result, file);
    }

    # make unique
    write.csv(result, 
        file = file.path(export_dir, "annotation_result.csv"),
        row.names = NULL);

    # plot visual of the spectrum alignment
    
}