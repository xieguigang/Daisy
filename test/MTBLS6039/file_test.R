require(Daisy);

setwd(@dir);

dasy_task(file = "./pos/L1.PeakMs2", args = list(
        export_dir = "./result_outputs/pos", 
        peakfile   = "./pos.csv",
        ms1_da     = 0.1, 
        rt_winsize = 10, 
        library_dir = "E:\biodeep\mona\libs",
        libtype    = 1, 
        ms1ppm     = 15));