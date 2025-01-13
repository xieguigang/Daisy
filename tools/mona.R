require(Daisy);

let mona_msp_repo = ?"--mona" || stop("A directory path that contains multiple mona database msp file must be provided!");
let lib_output = ?"--output" || normalizePath(file.path(mona_msp_repo,"libs"));
let list_repo_files = list.files(mona_msp_repo, pattern = "*.msp");

print("Start to build mona reference library:");
print(mona_msp_repo);
print(`  -> ${lib_output}`);
print("library files:");
print(basename(list_repo_files));

Daisy::build_mona_lcms(list_repo_files, lib_output);