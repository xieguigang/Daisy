sink(file = 'rlang_interop.log', split = TRUE);

# no dependecy rscript was required!

# --------end of load deps----------

raw_files <- c('/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_022_To103.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_033_To122.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_034_To137.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_038_To145.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_047_To140.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_051_To115.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_055_To108.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_059_To127.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_076_To141.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_079_To104.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_081_To124.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_091_To132.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_108_To106.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_109_To102.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_110_To111.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_120_To101.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_134_To125.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_137_To114.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_174_To147.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_179_To109.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_187_To119.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_205_To148.mzML');
library(xcms);
for(file in raw_files) {
xcms_work <- './xcms';
   print(sprintf('findPeaks: %s', file));
   data = xcmsRaw(file);
   xpeaks = findPeaks(data);
   xpeaks = as.data.frame(xpeaks);
   file = sub('\\..*$', '', basename(file));
   write.csv(xpeaks, file = file.path(xcms_work, sprintf('%s.csv', file)), row.names = FALSE);
            }

sink();