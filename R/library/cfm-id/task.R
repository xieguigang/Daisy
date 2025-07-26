#' Helper script for export task bash script for run cfm-id 4.0 prediction parallel task
#' 
#' @param data a dataframe that contains the molecule structure data for run prediction, should contains at least one data fields:
#'    - smiles: the molecule structure data in smiles format
#'    and the row names of the dataframe should be the molecule unique reference id
#' @param save_sh the bash script file path for save the generated script text. the parallel task will run upon this script file
#' @param save_dir the directory path for save the cfm-id 4.0 mass spectrum prediction result
#' @param image_id the docker image id for run the task
#' 
#' @return this function has no returns value.
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