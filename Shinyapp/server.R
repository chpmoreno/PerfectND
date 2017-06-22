shinyServer(function(input, output, session) {
      data_request <- reactive({
            invalidateLater(5000)
            data_raspberrypi <- read_csv("https://perfectndsa.blob.core.windows.net/example/final_output.csv")
            colnames(data_raspberrypi) <- c("time", "temp_hum", "temp_press", "hum", "press")
            data_raspberrypi$time <- as.POSIXct(data_raspberrypi$time)
            data_raspberrypi
      })
      
      plot_reactive <- reactive({
            if(input$variable == "temp_hum") {
                  plot_variable <- plot_ly(x = ~data_request()$time, y = ~data_request()$temp_hum) %>% 
                        layout(xaxis = list(title = ""), yaxis = list(title = "Temperature - Humidity (C°)"))
            }
            if(input$variable == "temp_press") {
                  plot_variable <- plot_ly(x = ~data_request()$time, y = ~data_request()$temp_press) %>% 
                        layout(xaxis = list(title = ""), yaxis = list(title = "Temperature - Pression (C°)"))
            }
            if(input$variable == "hum") {
                  plot_variable <- plot_ly(x = ~data_request()$time, y = ~data_request()$hum) %>% 
                        layout(xaxis = list(title = ""), yaxis = list(title = "Humidity (%rH)"))
            }
            if(input$variable == "press") {
                  plot_variable <- plot_ly(x = ~data_request()$time, y = ~data_request()$press) %>% 
                        layout(xaxis = list(title = ""), yaxis = list(title = "Pression (mBars)"))
            }
            plot_variable
      })
      
      min_ind <- reactive({
            if(input$variable == "temp_hum") {
                  min_value <- min(data_request()$temp_hum, na.rm = TRUE)
            }
            if(input$variable == "temp_press") {
                  min_value <- min(data_request()$temp_press, na.rm = TRUE)
            }
            if(input$variable == "hum") {
                  min_value <- min(data_request()$hum, na.rm = TRUE)
            }
            if(input$variable == "press") {
                  min_value <- min(data_request()$press, na.rm = TRUE)
            }
            min_value
      })
      
      output$min <- renderValueBox({
            valueBox(round(min_ind(), 2),
                     "Minimum",
                     icon = icon("thermometer-0")
                  )      
      })
      
      max_ind <- reactive({
            if(input$variable == "temp_hum") {
                  max_value <- max(data_request()$temp_hum, na.rm = TRUE)
            }
            if(input$variable == "temp_press") {
                  max_value <- max(data_request()$temp_press, na.rm = TRUE)
            }
            if(input$variable == "hum") {
                  max_value <- max(data_request()$hum, na.rm = TRUE)
            }
            if(input$variable == "press") {
                  max_value <- max(data_request()$press, na.rm = TRUE)
            }
            max_value
      })
      
      output$max <- renderValueBox({
            valueBox(round(max_ind(), 2),
                     "Maximum",
                     icon = icon("thermometer-4")
            )      
      })
      
      mean_ind <- reactive({
            if(input$variable == "temp_hum") {
                  mean_value <- mean(data_request()$temp_hum, na.rm = TRUE)
            }
            if(input$variable == "temp_press") {
                  mean_value <- mean(data_request()$temp_press, na.rm = TRUE)
            }
            if(input$variable == "hum") {
                  mean_value <- mean(data_request()$hum, na.rm = TRUE)
            }
            if(input$variable == "press") {
                  mean_value <- mean(data_request()$press, na.rm = TRUE)
            }
            mean_value
      })
      
      output$mean <- renderValueBox({
            valueBox(round(mean_ind(), 2),
                     "Mean",
                     icon = icon("thermometer-2")
            )      
      })
      
      output$plot <- renderPlotly({
            plot_reactive()
      })
      
})

