## ------------------------------------------------------------
## by J.Kruppa on Wednesday, June 24, 2020 (10:45)
pacman::p_load(tidyverse, readxl, plyr, stringi, magrittr,
               pdftools)
## small script to compile all rnw or tex files
source(file.path("C:/Users/jokruppa/source/runKnitr/runKnitr.R"))
## number of versions
n_version <- 2
semester <- file.path("archive", "2023_SoSe")
front_matter_file <- file.path("C:/Users/jokruppa/lehre/intern",
                               "Klausurdeckblatt_Praesenz_AuL_SoSe 2022.pdf")
exam_file <- file.path("C:/Users/jokruppa/Documents/GitHub/exam/exam_template.Rnw")
##
## loop over the students
l_ply(1:n_version, function(i) {
  ## copy exam file
  exam_name <- str_replace(getwd(), ".*lecture/(.*)/exam", "\\1") %>%
    str_replace_all("\\s", "_")
  temp_exam_file <- file.path(getwd(), str_c("Klausur_", exam_name, ".Rnw"))
  file.copy(exam_file, temp_exam_file)
  ## copy dir
  copy_dir <- file.path(semester)
  dir.create(copy_dir, showWarnings = FALSE, recursive = TRUE)
  ## run knitr
  runKnitr(temp_exam_file, copy.dir = copy_dir, force = TRUE)
  ## rename file to version
  out_knitr_file <- list.files(semester, full.names = TRUE,
                               pattern = "[a-z].pdf")
  joined_file <- file.path(semester, "tmp_joined_999.pdf")
  ## add the front matter
  pdf_combine(c(front_matter_file, out_knitr_file), output = joined_file)
  ## rename the file  
  file.rename(joined_file,
              str_replace(list.files(semester, full.names = TRUE,
                         pattern = "[a-z].pdf"),
                         ".pdf", str_c("_", i, ".pdf")))
  file.remove(out_knitr_file,
              list.files(getwd(), full.names = TRUE, pattern = exam_name))  
})
