#!/usr/bin/env Rscript
library(tximport)

## Command args: tx2gene and quant directories
args = commandArgs(trailingOnly = TRUE)

tx2gene = read.table(args[1], header = T)
runName = args[2]
species = args[3]
featInfo = read.csv(args[4])
qMethod = args[5]
quantPath = args[-c(1,2,3,4,5)]

if (qMethod == 'salmon' | qMethod == 'star_salmon' | qMethod == 'salmon_single') {
	files <- list.files(quantPath, pattern = "quant.sf", recursive = T, full.names = T)
	sampleNames <- basename(dirname( files ))
	names(files) <- sampleNames

	txi <- tximport(files, type = 'salmon', tx2gene = tx2gene)
	out <- list(
		ex = as.data.frame(txi$abundance),
		counts = as.data.frame(txi$counts),
		featInfo = featInfo
	)
} else {
	stop("ERROR: quant method not found. How'd you get here?")
}

saveRDS(out, file = paste(species, runName, qMethod, "quant.rds", sep = "_"))
