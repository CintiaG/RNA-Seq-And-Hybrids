setwd("/home/cintia/Documents/IPICYT/Tesis/bioinfo/rna-seq/01_rna_seq_data/source_data/")

MyTable <- read.csv("SraRunTable.txt",
                    stringsAsFactors = FALSE)

for (strain in unique(MyTable$strain)){
  write.table(MyTable[MyTable$strain == strain,]$Run, file = paste0(strain, "_SRR_list.txt"),
              col.names = FALSE, row.names = FALSE, quote = FALSE)
}
