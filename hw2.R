rm(list=ls())
#JInwen Xu jxu587@wisc.edu
files = list.files("data")
list_of_data_frames = c()
require("FITSio")
ts1 <- readFrameFromFITS("cB58_Lyman_break.fit")$FLUX
results <- data.frame(distance=numeric(),filename=character(),i=numeric())
for (file in files[1:100]) {
  cat(sep="", "file=", file, "\n")
  path_to_file = paste(sep="", "data/", file)
  cat(sep="", "path_to_file=", path_to_file, "\n") 
  noisy = readFrameFromFITS(path_to_file)  
  ts2=noisy$flux
  ccf_result <- ccf(ts1, ts2,lag.max=1000,plot=TRUE)
  lag_at_max_correlation <- ccf_result$lag[which.max(ccf_result$acf)]
  distance=1-max(ccf_result$acf)
  results <- rbind(results, data.frame(distance=distance,filename=file,i=abs(lag_at_max_correlation)))
}
sortresults=results[order(results$distance),]
write.csv(sortresults, "hw2.csv", row.names=FALSE)
