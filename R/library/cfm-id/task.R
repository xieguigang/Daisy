#' Generate a parallel task bash script for running CFM-ID 4.0 predictions
#'
#' This function creates a bash script to execute CFM-ID 4.0 mass spectrum predictions 
#' in parallel via Docker containers. It processes molecular structures in SMILES format,
#' generates unique working directories, and only runs predictions for molecules whose 
#' results don't already exist.
#'
#' @param data A `dataframe` containing molecular structures and unique identifiers. 
#' Must include:
#'   - Row names: Unique molecule reference IDs (used as identifiers)
#'   - Column named `smiles`: Molecular structures in SMILES format
#' @param save_sh Path (string) to save the generated bash script. 
#'   Example: "/scripts/cfm_predictions.sh"
#' @param save_dir Output directory for prediction results (default: current directory).
#'   Will be normalized to absolute path. Directory structure follows:
#'   `save_dir/.cfmid4/hash1/hash2/molecule_id/`
#' @param image_id Docker image ID for CFM-ID execution (default: "wishartlab/cfmid:latest")
#'
#' @section Key Features:
#' - Auto-skips molecules if both positive ([M+H]+) and negative ([M-H]-) mode result files exist
#' - Generates Docker commands for parallel execution
#' - Creates nested directories using MD5 hash subpaths to avoid filesystem overload
#' - Progress tracking via `tqdm` (if installed)
#'
#' @section Generated Script:
#' The output bash script will contain Docker commands with:
#' - Volume mounts binding host working directories to container
#' - CFM-ID parameters for both ionization modes ([M+H]+ and [M-H]-)
#' - Output redirection to molecule-specific files
#'
#' @return No return value. Writes executable bash script to `save_sh`.
#'
#' @examples
#' \dontrun{
#' data <- data.frame(smiles = c("CCO", "CCN"), 
#'                   row.names = c("ethanol", "ethylamine"))
#' cfmid4_task(data, 
#'             save_sh = "predictions.sh",
#'             save_dir = "~/cfm_results",
#'             image_id = "my_cfmid_image:4.0")
#' }
#'
#' @note Requires:
#'   - Docker installed and configured
#'   - `tqdm` package for progress tracking (optional but recommended)
#'   - Directory write permissions in `save_dir`
#' 
#' @references CFM-ID 4.0 documentation: \url{https://cfmid.wishartlab.com/}
#' 
let cfmid4_task = function(data, save_sh, save_dir = "./", image_id = "wishartlab/cfmid:latest") {
    data[,"xref_id"] = rownames(data);
    data             = as.list(data, byrow = TRUE);
    save_dir         = normalizePath(save_dir);

    lapply(tqdm(data), function(metabo) {
        let id      = metabo$xref_id;
        let smiles  = metabo$smiles;
        let workdir = `${save_dir}/.cfmid4/${substr(md5(id), 8,9)}/${substr(md5(id), 18,19)}/${id}/`;
        let pos     = `${workdir}/predicts_[M+H]+.txt`;
        let neg     = `${workdir}/predicts_[M-H]-.txt`;

        dir.create(workdir);
        
        if (all(sapply([pos, neg], x -> file.exists(x)))) {
            # should not run again if all exists
            "";
        } else {
            # `docker run --rm=true -v "${workdir}:/cfmid/public/" -it -w "/cfmid/public/" wishartlab/cfmid:latest java -jar /cfmid/msrb-fragmenter.jar -ismi "${smiles}" -o /cfmid/public/output.txt`;
            [
                `docker run --rm=true -v "/mnt/cfmid/${workdir}:/cfmid/public/" -w "/cfmid/public/" ${image_id} cfm-predict "${smiles}" 0.001 /trained_models_cfmid4.0/[M-H]-/param_output.log /trained_models_cfmid4.0/[M-H]-/param_config.txt 1 /cfmid/public/predicts_[M-H]-.txt`,
                `docker run --rm=true -v "/mnt/cfmid/${workdir}:/cfmid/public/" -w "/cfmid/public/" ${image_id} cfm-predict "${smiles}" 0.001 /trained_models_cfmid4.0/[M+H]+/param_output.log /trained_models_cfmid4.0/[M+H]+/param_config.txt 1 /cfmid/public/predicts_[M+H]+.txt`
            ];
        }
    })
    |> unlist()
    |> unlist()
    |> writeLines(con = save_sh)
    ;
}