// export R# source type define for javascript/typescript language
//
// package_source=Daisy

declare namespace Daisy {
   module _ {
      /**
      */
      function onLoad(): object;
      /**
      */
      function parse_annotation4(lines: any): object;
      /**
      */
      function parse_metadata4(lines: any): object;
      /**
      */
      function parse_spectrum4(lines: any): object;
   }
   /**
   */
   function __gcms_annotation(rawfile: any, ions: any, libname: any, libs: any, argv: any): object;
   /**
   */
   function __gcms_file_annotation(filepath: any, peaktable: any, work_pars: any): object;
   /**
     * @param argv default value Is ``Call "list"("libfiles" <- NULL, "libtype" <- [1, -1])``.
   */
   function __load_gcms_libs(argv?: any): object;
   /**
     * @param argv default value Is ``Call "list"("libfiles" <- NULL, "libtype" <- [1, -1], "waters" <- False)``.
     * @param load_spectrum default value Is ``true``.
     * @param map_name default value Is ``null``.
     * @param target_idset default value Is ``null``.
   */
   function __load_lcms_libs(argv?: any, load_spectrum?: any, map_name?: any, target_idset?: any): object;
   /**
   */
   function __merge_samples(results: any, argv: any): object;
   /**
     * @param max_rtwin default value Is ``15``.
     * @param workdir default value Is ``./``.
   */
   function __peak_alignment(xcms_out: any, max_rtwin?: any, workdir?: any): object;
   /**
   */
   function build_cfmid3_library(cfmid: any, libfile: any): object;
   /**
     * @param libdir default value Is ``./MoNA``.
     * @param metabolites default value Is ``null``.
   */
   function build_mona_lcms(repo: any, libdir?: any, metabolites?: any): object;
   /**
     * @param libfiles default value Is ``null``.
     * @param libtype default value Is ``[1, -1]``.
     * @param output default value Is ``./``.
     * @param waters default value Is ``false``.
     * @param target_idset default value Is ``null``.
   */
   function call_librarysearch(peaks_ms2: any, libfiles?: any, libtype?: any, output?: any, waters?: any, target_idset?: any): object;
   /**
     * @param libtype default value Is ``[1, -1]``.
     * @param ms1ppm default value Is ``15``.
     * @param output default value Is ``./``.
   */
   function call_metadna(peaks_ms2: any, libtype?: any, ms1ppm?: any, output?: any): object;
   /**
     * @param save_dir default value Is ``./``.
     * @param image_id default value Is ``wishartlab/cfmid:latest``.
   */
   function cfmid4_task(data: any, save_sh: any, save_dir?: any, image_id?: any): object;
   /**
     * @param args default value Is ``Call "list"("export_dir" <- "./",
     *       "peakfile" <- "./peaksdata.csv",
     *       "library_dir" <- NULL,
     *       "ms1_da" <- 0.1,
     *       "rt_winsize" <- 10,
     *       "libtype" <- 1,
     *       "ms1ppm" <- 15,
     *       "waters" <- False,
     *       "metadna" <- True)``.
   */
   function dasy_task(file: any, args?: any): object;
   /**
     * @param workdir default value Is ``./``.
     * @param max_rtwin default value Is ``15``.
     * @param docker default value Is ``null``.
     * @param n_threads default value Is ``8``.
     * @param call_xcms default value Is ``true``.
   */
   function deconv_peaks(rawfiles: any, workdir?: any, max_rtwin?: any, docker?: any, n_threads?: any, call_xcms?: any): object;
   /**
     * @param export_dir default value Is ``./``.
     * @param do_plot default value Is ``true``.
   */
   function export_report(files: any, export_dir?: any, do_plot?: any): object;
   /**
     * @param ms1ppm default value Is ``10``.
     * @param profiles default value Is ``Call "list"("C" <- [1, 100],
     *       "H" <- [3, 200],
     *       "O" <- [0, 50],
     *       "N" <- [0, 50],
     *       "S" <- [0, 50],
     *       "P" <- [0, 50])``.
     * @param mass_range default value Is ``[50, 1200]``.
   */
   function formula_annotation(peaks: any, ms1ppm?: any, profiles?: any, mass_range?: any): object;
   /**
     * @param libtype default value Is ``[1, -1]``.
   */
   function gcms_mona_msp(mspfile: any, libtype?: any): object;
   /**
     * @param libtype default value Is ``[1, -1]``.
     * @param outputdir default value Is ``./``.
     * @param ppm_cutoff default value Is ``20``.
     * @param lib_files default value Is ``null``.
     * @param n_threads default value Is ``8``.
     * @param do_plot default value Is ``true``.
     * @param debug default value Is ``false``.
   */
   function gcms_tof_annotation(rawdir: any, peaktable: any, libtype?: any, outputdir?: any, ppm_cutoff?: any, lib_files?: any, n_threads?: any, do_plot?: any, debug?: any): object;
   /**
     * @param ionMode default value Is ``[1, -1]``.
   */
   function get_adducts(ionMode?: any): object;
   /**
   */
   function local_gcms_lib(): object;
   /**
     * @param libtype default value Is ``[1, -1]``.
     * @param ms1ppm default value Is ``15``.
     * @param export_dir default value Is ``./``.
     * @param library_dir default value Is ``null``.
     * @param n_threads default value Is ``8``.
     * @param waters default value Is ``false``.
     * @param metadna default value Is ``true``.
     * @param do_plot default value Is ``true``.
     * @param id_range default value Is ``null``.
     * @param debug default value Is ``false``.
   */
   function make_annotation(files: any, peakfile: any, libtype?: any, ms1ppm?: any, export_dir?: any, library_dir?: any, n_threads?: any, waters?: any, metadna?: any, do_plot?: any, id_range?: any, debug?: any): object;
   /**
     * @param visual_dir default value Is ``./``.
   */
   function make_msms_plot(result: any, visual_dir?: any): object;
   /**
   */
   function metadna_report(metadna_result: any, metadb: any, args: any): object;
   /**
   */
   function open_biocad_local(): object;
   /**
   */
   function open_local_gcms_EI(): object;
   /**
   */
   function parse_cfmid4_predicts(str_output: any): object;
   /**
   */
   function parseMS(block: any): object;
   /**
     * @param mzdiff default value Is ``0.01``.
     * @param rt_win default value Is ``15``.
     * @param ms1ppm default value Is ``15``.
     * @param libtype default value Is ``[1, -1]``.
   */
   function peak_alignment(metadna: any, peaktable: any, mzdiff?: any, rt_win?: any, ms1ppm?: any, libtype?: any): object;
   /**
   */
   function rank_score(result: any): object;
   /**
   */
   function read_gcmsdata(rawfile: any, peaktable: any): object;
   /**
     * @param cache_enable default value Is ``true``.
   */
   function read_rawfile(file: any, cache_enable?: any): object;
   /**
   */
   function report_unique(result: any): object;
   /**
     * @param libfiles default value Is ``null``.
     * @param map_name default value Is ``null``.
   */
   function resolve_metadb(libfiles?: any, map_name?: any): object;
   /**
   */
   function tabular(list: any, keys: any): object;
   /**
     * @param rt_shifts default value Is ``15``.
   */
   function tabular_annotation(result: any, rt_shifts?: any): object;
   /**
   */
   function union_posneg(pos: any, neg: any): object;
   /**
     * @param workdir default value Is ``./``.
     * @param docker default value Is ``null``.
   */
   function xcms_findPeaks(raw_files: any, workdir?: any, docker?: any): object;
}
