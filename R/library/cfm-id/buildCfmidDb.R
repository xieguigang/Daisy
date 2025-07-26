const buildCfmidDb = function(cfmid, libfile) {
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