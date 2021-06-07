setwd("/home/cintia/Documents/IPICYT/Tesis/bioinfo/rna-seq-analysis/04_ref_assembly/source_data")

GetString <- function(String){
  paste(paste0("source_data/", rep(MyTable[grep(pattern = String, x = MyTable$title),]$Run, times = 2), "_", rep(seq(1:2), each = 3), ".fastq"), collapse = ",")
}


MyTable <- read.csv("SraRunTable.txt",
                    stringsAsFactors = FALSE)

Strings <- c("TMW3287_15", "TMW3287_20", "TMW3681_15", "TMW3681_20")

Df <- NULL

for (i in Strings){
  WkString <- GetString(i)
  Df <- rbind(Df, WkString)
}

write.table(Df, file = "SRR_list.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)
