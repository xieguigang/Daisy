require(Daisy);

let posneg = Daisy::union_posneg(pos = file.path(@dir, "result_outputs/pos/annotation_result.csv"), 
neg = file.path(@dir, "result_outputs/neg/annotation_result.csv"));

write.csv(posneg, file = file.path(@dir, "result_outputs/annotation.csv" ), row.names = FALSE);

make_msms_plot(posneg, visual_dir = file.path(@dir, "result_outputs/annotated_spectral_plots" ));