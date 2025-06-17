require(Daisy);

let files <- list.files("M:\project\blood_20250617_LLMs\Positive", pattern = ["*.mzXML", "*.mzML", "*.mzPack", "*.PeakMs2"]);


    export_report(files, export_dir= "M:\project\blood_20250617_LLMs\lcms_output\tmp\workflow_tmp\daisy_pos", do_plot = FALSE);