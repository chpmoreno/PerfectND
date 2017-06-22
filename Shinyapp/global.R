usePackage <- function(p) {
      if ( !is.element(p, installed.packages()[,1]) ) {
            install.packages(p, dep = TRUE)}
      require(p, character.only = TRUE)}

packages <- c("tidyverse", "visNetwork", "stringr", "shiny", "shinythemes", "scales",
              "shinydashboard", "data.table", "plotly")

for (p in packages) {
      usePackage(p) 
}
