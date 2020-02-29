ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    selectInput(inputId = "input",
                label = "choose map",
                choices = list("osm", "bing", "stamen-toner", "stamen-watercolor", "esri", "esri-topo")),
    sliderInput(inputId = "input2",
                label = "Zoom:", 14,18,16
                
                )
    
   
  ),
  dashboardBody(
    fluidRow(
      box(
        textOutput("currentTime")
      )
    ),
    fluidRow(
      box(
        plotOutput(outputId ="output_plot")
        )
      )
  )
)




# Create Shiny app ----
shinyApp(ui, server)


