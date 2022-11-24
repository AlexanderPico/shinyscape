# Load files and variables

library(plyr)

#Defaults and Parameters
supported.idTypes <- c("SYMBOL",  # editable list of supported idTypes (see keytypes per orgDb)
                       "ENSEMBL", 
                       "ENTREZID", 
                       "UNIPROT")
