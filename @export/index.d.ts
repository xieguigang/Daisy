// export R# source type define for javascript/typescript language
//
// package_source=Daisy

declare namespace Daisy {
   module _ {
      /**
      */
      function onLoad(): object;
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
   */
   function __merge_samples(results: any, argv: any): object;
   /**
     * @param libdir default value Is ``./MoNA``.
   */
   function build_mona_lcms(repo: any, libdir?: any): object;
   /**
   */
   function buildCfmidDb(cfmid: any, libfile: any): object;
   /**
     * @param libtype default value Is ``[1, -1]``.
     * @param ms1ppm default value Is ``15``.
     * @param output default value Is ``./``.
   */
   function call_metadna(peaks_ms2: any, libtype?: any, ms1ppm?: any, output?: any): object;
   /**
   */
   function dasy_task(file: any, args: any): object;
   /**
     * @param export_dir default value Is ``./``.
   */
   function export_report(files: any, export_dir?: any): object;
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
     * @param debug default value Is ``false``.
   */
   function gcms_tof_annotation(rawdir: any, peaktable: any, libtype?: any, outputdir?: any, ppm_cutoff?: any, lib_files?: any, n_threads?: any, debug?: any): object;
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
     * @param n_threads default value Is ``8``.
     * @param debug default value Is ``false``.
   */
   function make_annotation(files: any, peakfile: any, libtype?: any, ms1ppm?: any, export_dir?: any, n_threads?: any, debug?: any): object;
   /**
     * @param visual_dir default value Is ``./``.
   */
   function make_msms_plot(result: any, visual_dir?: any): object;
   /**
     * @param ms1ppm default value Is ``10``.
     * @param libtype default value Is ``[1, -1]``.
   */
   function ms1_anno(peaks: any, ms1ppm?: any, libtype?: any): object;
   /**
   */
   function open_biocad_local(): object;
   /**
   */
   function open_local_gcms_EI(): object;
   /**
     * @param mzdiff default value Is ``0.01``.
     * @param rt_win default value Is ``15``.
   */
   function peak_alignment(metadna: any, peaktable: any, mzdiff?: any, rt_win?: any): object;
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
   */
   function tabular(result: any): object;
   /**
   */
   function union_posneg(pos: any, neg: any): object;
}
