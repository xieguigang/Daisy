#' Generate mirror plots for spectrum alignment results
#'
#' This function creates visualizations of mass spectrometry (MS/MS) spectrum alignment results,
#' producing mirror plots for each hit and saving them as SVG and PNG files. The plots display aligned
#' experimental and theoretical spectra with annotated m/z values.
#'
#' @param result A list or data frame containing spectrum alignment results. Each element must include:
#'   - `name`: Compound identifier (character).
#'   - `adducts`: Adduct information (character or `NA`).
#'   - `mz`: Mass-to-charge ratio (numeric).
#'   - `rt`: Retention time in seconds (numeric).
#'   - `xcms_id`: Unique XCMS identifier (character or numeric).
#'   - `alignment`: Spectrum alignment data (list or string).
#' @param visual_dir Character string specifying the output directory for plot files. Defaults to the
#'   current working directory (`"./"`).
#'
#' @return Invisibly returns `NULL`. The function primarily generates side effects by saving plot files
#'   to the specified directory. Files are named in the format: `{xcms_id}@{normalized_name}.svg/png`.
#'
#' @examples
#' # Example usage:
#' result <- list(
#'   list(
#'     name = "Compound1",
#'     adducts = "[M+H]+",
#'     mz = 456.123,
#'     rt = 300,
#'     xcms_id = "XCMS_001",
#'     alignment = "parsed_alignment_data"
#'   )
#' )
#' make_msms_plot(result, visual_dir = "./output_plots")
#'
#' @seealso
#'   - `normalizeFileName()` for filename sanitization.
#'   - `parse.spectrum_alignment()` for alignment data parsing.
#'
#' @export
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