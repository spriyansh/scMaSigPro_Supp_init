###########################################
## Author: Priyansh Srivastava ############
## Email: spriyansh29@gmail.com ###########
## Script: Automatic Cell type Inference ##
###########################################

set.seed(007)

suppressPackageStartupMessages(library(Seurat))
suppressPackageStartupMessages(library(SeuratDisk))
suppressPackageStartupMessages(library(Azimuth))

# Prefix
dirPath <- "/supp_data/Analysis_Public_Data/"

# Get folder names
rep_vec <- list.dirs(dirPath, full.names = F, recursive = F)
rep_vec <- rep_vec[rep_vec != "Azimuth_Human_BoneMarrow"]
names(rep_vec) <- rep_vec

# Run lapply
azimuth.list <- lapply(rep_vec, function(rep_i, inPath = dirPath, outPath = dirPath) {
  # Load seurat object
  sob <- LoadH5Seurat(file = paste0(inPath, rep_i, "/", rep_i, "_prs.h5seurat"))

  sob <- RunAzimuth(
    query = sob,
    reference = paste0(inPath, "Azimuth_Human_BoneMarrow")
  )

  # Add column
  sob@meta.data$cell_type <- sob@meta.data$predicted.celltype.l2

  # Save
  file_name <- paste(outPath, rep_i, paste(rep_i, "azimuth.RDS", sep = "_"), sep = "/")
  saveRDS(
    object = sob, file = file_name
  )

  return(sob)
})