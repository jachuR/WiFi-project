ui <- fluidPage(
  responsive = FALSE,
  titlePanel("locator prototype"),
  
  sidebarLayout(
    selectInput(inputId = "input",
                label = "choose map",
                choices = list("osm", "bing", "stamen-toner", "stamen-watercolor", "esri", "esri-topo")),
    sliderInput(inputId = "input2",
                label = "Zoom:", 10,19,15
                
    )
    
    
  ),
  mainPanel(
    
      box(
        textOutput("currentTime")
      
    ),
    
      box(
        plotOutput(outputId ="output_plot")
      
    )
  )
)




# Create Shiny app ----
shinyApp(ui, server)


