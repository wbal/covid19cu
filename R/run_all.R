# Source this file

source("data-raw/covid19-cuba.json.R")

rmarkdown::render("vignettes/Covid19CU-EpiAnn.Rmd")

if (interactive()) browseURL("vignettes/Covid19CU-EpiAnn.html")

unlink(c("Covid19CU-EpiAnn.Rmd", "Covid19CU-EpiAnn.html", "Covid19CU-EpiAnn.md"))
