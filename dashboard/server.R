FinnalTable_F_C <- readRDS("C:/Users/jator/Desktop/Ubiqum/3.2/Data/Results/FinnalTable_F_C.RDS")

server <- function(input, output, session) {
  
  
  output$currentTime <- renderText({
    invalidateLater(1000, session)
    paste("The time is:", Sys.time())

  })

   # mp <- reactive ({openmap(c(39.99410,-0.06990),
   #               c(39.99156,-0.06481),input$input2,input$input)})
    

  output$output_plot <- renderPlot({
    invalidateLater(10000, session)
    r <- sample(1:1111, 1)
    aaa <-  FinnalTable_F_C[r,313:325]
    mp <-openmap(c(39.99410,-0.06990),
            c(39.99156,-0.06481),input$input2,input$input)

    

    p <- autoplot(mp,expand=T) +
      geom_point(aes(x=LONGITUDE_PRED,y=LATITUDE_PRED), data=aaa,shape = 21,color = "deepskyblue",size =3, fill = "blue", stroke = 4) +
      geom_point(aes(x=LONGITUDE,y=LATITUDE),data=aaa, size =2,fill = "red", shape = 23)+
      theme_void() # usuwanie osi #theme_bw() - czarna ramka
    p

  })
  
  

}


