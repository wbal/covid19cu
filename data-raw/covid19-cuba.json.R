#
# This script downloads data from
#   https://covid19cubadata.github.io/data/covid19-cuba.json
#   Created by Yudivian and his team.
#

# Yudivian: "introducidos" = introduced are cases diagnosed as positives to COVID-19
#    who probably acquired the disease in Cuba
#    (They have no history of recent travel abroad )
#

library(dplyr)
library(jsonlite)
library(data.table)
library(stringr)     #  I am using stringr::str_extract()

url <- "https://covid19cubadata.github.io/data/covid19-cuba.json"
tryCatch({
  code <- download.file(url, "data-raw/covid19-cuba.json")
  if (code != 0) {
    stop("Error downloading file")
  }
},
error = function(e) {
  stop(sprintf("Error downloading file '%s': %s, please check %s",
               url, e$message, url_page))
})


ljson <- fromJSON(txt = "data-raw/covid19-cuba.json")

df1  <- lapply( X = ljson$casos$dias, "[[", "diagnosticados" ) %>% rbindlist(., fill=TRUE, idcol = TRUE)


ulfechas <- unlist ( lapply( X = ljson$casos$dias, "[[", "fecha" ) )

dffechas<-data.frame( DateReport =as.Date( as.character( ulfechas ) ,format= "%Y/%m/%d"  ), id = names(ulfechas) )


df2 <-merge(df1, dffechas, by.x = ".id", by.y = "id" )

df3 <- df2 %>% mutate( escontacto= grepl( "contacto", info ), novienedelexterior = is.na( arribo_a_cuba_foco), escontact_noviajo= escontacto &  novienedelexterior )

saveRDS(object = df3,file = "data/cases-cv19cu.rds")

