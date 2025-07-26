#' Build Reference Spectrum Library from CFM-ID 3.0 Outputs
#'
#' This function scans CFM-ID 3.0 prediction files (*.txt) from a specified directory, 
#' converts them into EI mass spectra objects, and compiles them into a binary spectral library file.
#' The generated library adopts the "Pack" format for efficient storage and retrieval.
#'
#' @param cfmid Character string specifying the directory path containing CFM-ID 3.0 output files. 
#'              Files must be in TXT format with predicted spectra.
#' @param libfile Character string defining the output file path for the compiled spectral library. 
#'                Recommended file extension is `.spa` for compatibility with `mzkit` packages. 
#'
#' @return None (invisible `NULL`). The function's primary output is a binary library file 
#'         saved at the location specified by `libfile`. 
#' 
#' @section Operation Workflow:
#' 1. Scans the `cfmid` directory for TXT files
#' 2. Initializes a new "Pack"-type spectral library at `libfile`
#' 3. Converts each CFM-ID file into spectrum objects using `mzkit::read.cfmid_3_EI()`
#' 4. Adds spectra to the library with metadata (UUID = filename, placeholder formula "H")
#' 5. Closes the library connection to finalize file writing
#'
#' @note 
#' - Requires `mzkit` and `tqdm` packages installed
#' - CFM-ID files must contain valid EI spectral predictions
#' - Placeholder formula "H" is used; replace with actual formulas if available
#'
#' @importFrom mzkit read.cfmid_3_EI spectrumTree
#' @importFrom tqdm tqdm
#' @export
#'
#' @examples
#' \dontrun{
#' build_cfmid3_library(
#'   cfmid = "path/to/cfm_id_outputs",
#'   libfile = "reference_library.spa"
#' )}
const build_cfmid3_library = function(cfmid, libfile) {
    imports "spectrumTree" from "mzkit";

    # scan cfm-id files
    let scan_files = list.files(cfmid, pattern = "*.txt");

    print("scan for cfm-id output files:");
    print(basename(scan_files));

    libfile <- spectrumTree::new(libfile,type = "Pack");

    for(let file in tqdm(scan_files)) {
        let spec = mzkit::read.cfmid_3_EI(file);

        libfile |> addBucket(spec$spectral,
            uuid = basename(file),
            formula = "H",
            name = basename(file));
    }

    close(libfile);
}