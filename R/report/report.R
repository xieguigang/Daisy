const export_report = function(files, export_dir = "./") {
    let names = basename(files);
    let result = NULL;
    let visual_dir = file.path(export_dir, "spectral_aligns");

    for(let file in `${export_dir}/${names}/result.csv`) {
        file = read.csv(file, row.names = NULL, check.names = FALSE);
        result = rbind(result, file);
    }

    result[, "mz"] = round(result$mz, 4);
    result[, "rank"] = rank_score(result);

    # make unique
    result = report_unique(result);
    
    write.csv(result, 
        file = file.path(export_dir, "annotation_result.csv"),
        row.names = FALSE);

    # make ms/ms alignment plot
    result |> make_msms_plot(visual_dir);
}

#' plot visual of the spectrum alignment
#' 
export make_msms_plot = function(result, visual_dir = "./") {
    for(let hit in as.list(result, byrow = TRUE)) {
        svg(file = file.path(visual_dir, `${hit$xcms_id}@${normalizeFileName(hit$name, 
                                    alphabetOnly = FALSE, 
                                    replacement = "_", 
                                    shrink = TRUE,
                                    maxchars = 64)}.svg`)) {

            parse.spectrum_alignment(hit$alignment) |> plot(
                title = `${hit$name} ${hit$precursorType} ${hit$mz}@${round(hit$rt/60,1)}min`,
                legend_layout = "none",
                bar_width = 2,
                color1 = "green",
                color2 = "blue",
                label_into = 0.2,
                label_mz = "F4",
                grid_x = TRUE
            );
        }
    }

    invisible(NULL);
}