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
   function dasy_task(file: any, args: any): object;
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
     * @param libtype default value Is ``[1, -1]``.
     * @param ms1ppm default value Is ``15``.
     * @param output default value Is ``./``.
   */
   function metadna(peaks_ms2: any, libtype?: any, ms1ppm?: any, output?: any): object;
   /**
     * @param cache_enable default value Is ``true``.
   */
   function read_rawfile(file: any, cache_enable?: any): object;
}
