
#' Export Metabolomics Annotation Report with Spectrum Alignment Visuals
#' 
#' This function processes mass spectrometry annotation results from multiple sample files,
#' merges them into a consolidated report, generates spectrum alignment mirror plots for each hit,
#' and exports the results to specified directory. The function handles file I/O operations and
#' data processing in a pipeline workflow.
#'
#' @param files Character vector of file paths containing sample annotation results. 
#'   Each path should point to a sample directory containing `result.csv`[2,6](@ref).
#' @param export_dir Output directory path for saving consolidated report and visualizations. 
#'   Defaults to current working directory (`"./"`).
#'
#' @section Workflow Details:
#' 1. **File Processing**: 
#'    - Reads `result.csv` files from each sample directory
#'    - Handles missing files with warnings[6](@ref)
#' 2. **Data Consolidation**:
#'    - Merges all sample results into single data frame
#'    - Rounds m/z values to 4 decimal places
#'    - Calculates annotation confidence scores via `rank_score()`
#'    - Applies uniqueness filtering via `report_unique()`
#' 3. **Output Generation**:
#'    - Saves consolidated report as `annotation_result.csv`
#'    - Creates subdirectory `spectral_aligns` for mirror plots
#'    - Generates SVG/PNG spectrum alignment visuals via `make_msms_plot()`
#'
#' @return Invisibly returns `NULL`. Primary outputs are:
#'   - `export_dir/annotation_result.csv`: Consolidated report table
#'   - `export_dir/spectral_aligns/*`: Spectrum alignment plots (SVG/PNG)
#'
#' @note 
#' - Requires `result.csv` files in specific format (mz, rt, name, adducts, alignment, etc.)
#' - Depends on helper functions: `rank_score()`, `report_unique()`, `make_msms_plot()`[3](@ref)
#' - Uses progress tracking via `tqdm` for large file batches[1](@ref)
#'
#' @examples
#' \dontrun{
#' # Basic usage
#' export_report(files = c("sample1", "sample2"))
#' 
#' # Custom output directory
#' export_report(
#'   files = list.dirs("raw_data", recursive = FALSE),
#'   export_dir = "processed_results"
#' )}
#' 
#' @seealso 
#'   - [make_msms_plot()] for spectrum visualization details
#'   - [report_unique()] for uniqueness filtering logic
#' @export
const export_report = function(files, export_dir = "./", do_plot = TRUE) {
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

    if (do_plot) {
        # make ms/ms alignment plot
        result |> make_msms_plot(visual_dir);
    }
}

