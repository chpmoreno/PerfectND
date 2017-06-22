ui <- fluidPage(
      theme = shinytheme("journal"),
      navbarPage(title = div(img(src = "perfectnd.png",height = 28, width = 120)),
                 tabPanel(title = "Web app",
                          fluidRow(
                                column(width = 3,
                                       radioButtons("variable", "Variable:",
                                                    c("Temperature-Humidity" = "temp_hum",
                                                      "Temperature-Pression" = "temp_press",
                                                      "Humidity" = "hum",
                                                      "Pression" = "press")
                                       ),
                                       tags$iframe(width="250", height="200", src="//www.youtube.com/embed/j8Y2zAj9moY?autoplay=1",
                                                   frameborder="0", allowfullscreen="true")
                                       ),
                                column(width = 9,
                                       tabsetPanel(
                                             tabPanel("Our Business", 
                                                      tags$iframe(style="height:400px; width:100%; scrolling=yes", 
                                                                  src="https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf")
                                             ),
                                             tabPanel("Potential risks",
                                                      fluidRow(
                                                            column(width = 2.2,
                                                                   valueBoxOutput("min")
                                                            ),
                                                            column(width = 2.2,
                                                                   valueBoxOutput("max")
                                                            ),
                                                            column(width = 2.2,
                                                                   valueBoxOutput("mean")
                                                            )
                                                      ),
                                                      plotlyOutput("plot")
                                             ),
                                             id = "conditionedPanels"
                                       )
                                       
                                )
                          )
                 )
      )
)