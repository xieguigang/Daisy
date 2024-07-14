require(Daisy);

Daisy::union_posneg(pos = file.path(@dir, "result_outputs/pos/annotation_result.csv"), neg = file.path(@dir, "result_outputs/neg/annotation_result.csv"))
|> write.csv(file = file.path(@dir, "result_outputs/annotation.csv" ), row.names = FALSE)
;