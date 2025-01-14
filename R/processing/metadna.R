imports "metadna" from "mzDIA";
imports "mzweb" from "mzkit";
imports ["assembly", "data", "math"] from "mzkit";

#' run metadna algorithm
#' 
#' @param peaks_ms2 a collection of the spectrum in ms2 level
#' 
const call_metadna = function(peaks_ms2, libtype = [1,-1], ms1ppm = 15, output = "./") {
    options(verbose = TRUE);

    let metadna = metadna(
        ms1ppm    = tolerance(ms1ppm, "ppm"),
        dotcutoff = 0.5,
        mzwidth   = tolerance(0.3, "da"),
        allowMs1  = FALSE
    )
    |> range(get_adducts(libtype))
    |> load.kegg(GCModeller::kegg_compounds(rawList = TRUE, reference_set = FALSE))
    |> load.kegg_network(GCModeller::kegg_reactions())
    ;
    let infer = metadna |> DIA.infer(
        seeds  = NULL,
        sample = peaks_ms2
    )
    ;
    let unique_result = metadna |> as.table(infer, unique = TRUE);

    metadna 
    |> as.table(infer) 
    |> write.csv(file = `${output}/metaDNA_all.csv`)
    ;
    infer 
    |> metadna::result.alignment(unique_result)
    |> xml
    |> writeLines(con = `${output}/metaDNA_infer.XML`)
    ;

    write.csv(unique_result, file = `${output}/metaDNA.csv`);
}

