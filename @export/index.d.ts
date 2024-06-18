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
     * @param export_dir default value Is ``./``.
   */
   function make_annotation(files: any, peakfile: any, libtype?: any, ms1ppm?: any, export_dir?: any): object;
   /**
     * @param libtype default value Is ``[1, -1]``.
   */
   function metadna(peaks_ms2: any, libtype?: any): object;
   /**
   */
   function read_rawfile(files: any): object;
}
