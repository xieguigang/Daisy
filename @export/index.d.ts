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
     * @param ionMode default value Is ``[1, -1]``.
   */
   function get_adducts(ionMode?: any): object;
   /**
     * @param libtype default value Is ``[1, -1]``.
     * @param ms1ppm default value Is ``15``.
     * @param export_dir default value Is ``./``.
     * @param debug default value Is ``false``.
   */
   function make_annotation(files: any, peakfile: any, libtype?: any, ms1ppm?: any, export_dir?: any, debug?: any): object;
   /**
     * @param visual_dir default value Is ``./``.
   */
   function make_msms_plot(result: any, visual_dir?: any): object;
   /**
     * @param mzdiff default value Is ``0.01``.
     * @param rt_win default value Is ``15``.
   */
   function peak_alignment(metadna: any, peaktable: any, mzdiff?: any, rt_win?: any): object;
   /**
   */
   function rank_score(result: any): object;
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
