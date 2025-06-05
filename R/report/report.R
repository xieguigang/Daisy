
#' export report table and spectrum alignment mirror plot
#' 
const export_report = function(files, export_dir = "./") {
    let names = basename(files);
    let result = NULL;
    let visual_dir = file.path(export_dir, "spectral_aligns");

    print("read samples files and merge result table...");

    for(let file in tqdm(`${export_dir}/${names}/result.csv`)) {
        print(file);
        
        if (file.exists(file)) {
            file = read.csv(file, row.names = NULL, check.names = FALSE);
            result = rbind(result, file);
        } else {
            warning(`missing sample annotation: ${file}`);
        }

        invisible(NULL);
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
const make_msms_plot = function(result, visual_dir = "./") {
    for(let hit in tqdm(as.list(result, byrow = TRUE))) {
        let safe_filename = normalizeFileName(hit$name, 
                                    alphabetOnly = FALSE, 
                                    replacement = "_", 
                                    shrink = TRUE,
                                    maxchars = 64)
        ;
        let title_str = `${hit$name} ${hit$adducts || "-"} ${round(hit$mz,3)}@${round(hit$rt/60,1)}min`;
        let save_pdffile = file.path(visual_dir, `${hit$xcms_id}@${safe_filename}.svg`);
        let save_pngfile = file.path(visual_dir, `${hit$xcms_id}@${safe_filename}.png`);
        let align_data = parse.spectrum_alignment(hit$alignment);
        let make_mirror = function() {
            plot(align_data,
                title = title_str,
                legend_layout = "none",
                bar_width = 2,
                color1 = "green",
                color2 = "blue",
                label_into = 0.2,
                label_mz = "F4",
                grid_x = TRUE
            );
        }

        svg(file = save_pdffile) {
            make_mirror(); 
        };
        bitmap(file = save_pngfile) {
            make_mirror(); 
        };
    }

    invisible(NULL);
}