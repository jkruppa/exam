## ------------------------------------------------------------
## by J.Kruppa on Wednesday, June 24, 2020 (10:45)
pacman::p_load(tidyverse, readxl, plyr, stringi, magrittr, fs)
## small script to compile all rnw or tex files
exam_path <- file.path(path_home(), "Documents/GitHub/exam")
source(file.path(exam_path, "source/runKnitr.R"))
## number of versions
n_version <- 1
semester <- "year/2022_SoSe"

## loop over the versions
l_ply(1:n_version, function(i) {
  ## get the files for the exercieses...
  exam_file <- list.files(getwd(), pattern = "Rnw", full.names =TRUE)
  ## copy dir
  copy_dir <- file.path(semester)
  dir.create(copy_dir, showWarnings = FALSE)
  ## run knitr
  runKnitr(exam_file, copy.dir = copy_dir, force = TRUE)
  ## rename file to version
  file.rename(list.files(semester, full.names = TRUE,
                         pattern = "[a-z].pdf"),
              str_replace(list.files(semester, full.names = TRUE,
                         pattern = "[a-z].pdf"),
                         ".pdf", str_c("_", i, ".pdf")))
})
