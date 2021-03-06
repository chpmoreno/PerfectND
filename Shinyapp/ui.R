ui <- fluidPage(
      theme = shinytheme("journal"),
      navbarPage(title = div(img(src = "perfectnd.png",height = 28, width = 120)),
                 tabPanel(title = "Web app",
                          fluidRow(
                                column(width = 3,
                                       conditionalPanel(condition="input.conditionedPanels == 'Monitor'",
                                                        radioButtons("variable", "Variable:",
                                                                     c("Temperature-Humidity" = "temp_hum",
                                                                       "Temperature-Pression" = "temp_press",
                                                                       "Humidity" = "hum",
                                                                       "Pression" = "press")
                                                        ),
                                                        downloadButton('downloadData', 'Download Data')
                                       
                                       ),
                                       tags$br(),
                                       tags$iframe(width="250", height="200", src="//www.youtube.com/embed/pikXS9r0WRI?autoplay=1",
                                                   frameborder="0", allowfullscreen="true"),
                                       tags$br(),
                                       a(img(src = "github-mark.png", width="80", height="50", alt = "US CDC"),
                                         href = "https://github.com/chpmoreno/PerfectND",
                                         target = "_blank")
                                       ),
                                column(width = 9,
                                       tabsetPanel(
                                             tabPanel("Our Business", 
                                                      tags$iframe(style="height:450px; width:100%; scrolling=yes", 
                                                                  src="https://perfectndsa.blob.core.windows.net/example/presentation.pdf#zoom=67",
                                                                  view="FitH")
                                                      
                                             ),
                                             tabPanel("Monitor",
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