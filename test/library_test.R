require(Daisy);

imports "metadb" from "mzkit";

let lib = Daisy::open_biocad_local();

str(lib |> getMetadata("1") |> as.list());