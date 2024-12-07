sink(file = 'rlang_interop.log', split = TRUE);

# no dependecy rscript was required!

# --------end of load deps----------

n_threads <- 32;
raw_files <- c('/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_022_To103.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_033_To122.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_034_To137.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_038_To145.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_047_To140.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_051_To115.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_055_To108.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_059_To127.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_076_To141.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_079_To104.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_081_To124.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_091_To132.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_108_To106.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_109_To102.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_110_To111.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_120_To101.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_134_To125.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_137_To114.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_174_To147.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_179_To109.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_187_To119.mzML', '/media/rstudio/4EEFEC5F5C56A6DE/gcms_demo/rawdata/SAV_130416_205_To148.mzML');
name <- c('SAV_130416_022_To103', 'SAV_130416_033_To122', 'SAV_130416_034_To137', 'SAV_130416_038_To145', 'SAV_130416_047_To140', 'SAV_130416_051_To115', 'SAV_130416_055_To108', 'SAV_130416_059_To127', 'SAV_130416_076_To141', 'SAV_130416_079_To104', 'SAV_130416_081_To124', 'SAV_130416_091_To132', 'SAV_130416_108_To106', 'SAV_130416_109_To102', 'SAV_130416_110_To111', 'SAV_130416_120_To101', 'SAV_130416_134_To125', 'SAV_130416_137_To114', 'SAV_130416_174_To147', 'SAV_130416_179_To109', 'SAV_130416_187_To119', 'SAV_130416_205_To148');
groups <- 'sample';
method <- 'centWave';
export_file <- './xcms/gcms_peaks.csv';
library(xcms);
library(MSnbase);
library(MsExperiment);
library(BiocParallel);
n_threads = as.integer(n_threads);
print('construct the msdata reader...');
print('processing on rawdata files:');
print(basename(raw_files));
print('with data processor threads:');
print(n_threads);
register(bpstart(MulticoreParam(n_threads)));
pd = data.frame(sample_name = name, sample_group = groups, stringsAsFactors = FALSE);
ppm = 15;
snthresh = 3;
mzdiff = 0.01;
peakwidth = c(5, 30);
xset = NULL;
xset1 = NULL;
xset2 = NULL;
xset3 = NULL;
print('create xcms rawdata set...');
if( method == 'centWave' ) {
   xset = xcmsSet(raw_files, method = 'centWave', ppm = ppm, snthresh = snthresh, peakwidth = peakwidth, mzdiff = mzdiff, BPPARAM = MulticoreParam(n_threads));
}else {
   xset = xcmsSet(raw_files, method = 'matchedFilter', snthresh = snthresh, mzdiff = mzdiff, BPPARAM = MulticoreParam(n_threads));
}
print('make data peaks group...');
xset1 = group(xset, mzwid = 0.015, bw = 2, minfrac = 0.5);
print('make peaks alignments...');
if( length(raw_files) < 2 ) {
   xset3 = xset1;
}else {
adjust_method <- 'obiwarp';
   if( adjust_method == 'obiwarp' ) {
         xset2 = retcor(xset1, method = 'obiwarp', profStep = 1, plottype = c('deviation'));
   }   else {
         xset2 = retcor(xset1, method = 'loess', plottype = c('deviation'));
   }
   xset3 = group(xset2, mzwid = 0.015, bw = 2, minfrac = 0.5);
}
xset3_matrix = peakTable(xset3);
old_colnames = colnames(xset3_matrix);
old_colnames = old_colnames[!(old_colnames %in% 'pos')];
old_colnames = old_colnames[!(old_colnames %in% 'neg')];
rownames(xset3_matrix) <- groupnames(xset3);
xset3_matrix = xset3_matrix[, old_colnames];
print('get peaktable sample columns:');
print(old_colnames);
print('we have metabolite data features:');
print(rownames(xset3_matrix));
write.csv(xset3_matrix, file = export_file, quote = FALSE, row.names = TRUE);

sink();