#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(ggradar)
library(ggplot2)
library(Rmisc)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  output$map <- renderLeaflet({
    if (input$state == 'All'){
      temp <- bus
    }
    else if (input$state != 'All' & input$city == 'All'){
      temp <- bus[bus$state == input$state, ]
    }
    else if (input$state != 'All' & input$city != 'All' & input$business_id == 'All') {
      temp <- bus[(bus$state == input$state)&(bus$city == input$city), ]
    }
    else {
      temp <- bus[(bus$state == input$state)&(bus$city == input$city)&(bus$business_id==input$business_id), ]
    }
    leaflet(temp) %>% addTiles() %>% addMarkers(temp$longitude, temp$latitude, 
                                                clusterOptions = markerClusterOptions(),
                                                popup=paste(temp$name,  temp$city, temp$state, 'Star:', temp$stars, sep="\n"))
  })
  
  
  city_choice <- reactive({
    c("All", as.character(unique(bus[bus$state==input$state, ]$city)))
  })
  
  bus_choice <- reactive({
    c("All", as.character(bus[(bus$state==input$state)&(bus$city==input$city), ]$business_id))
  })
  
  observe({
    updateSelectInput(session, 'city', choices=city_choice())
  })
  
  observe({
    updateSelectInput(session, 'business_id', choices=bus_choice())
  })
  
  output$ranking <- renderPlot({
    if (input$state == 'All'){
      temp <- bus
    }
    else if (input$state != 'All' & input$city == 'All'){
      temp <- bus[bus$state == input$state, ]
    }
    
    else if (input$state != 'All' & input$city != 'All' ) {
      ppp <- bus[(bus$state == input$state) & (bus$city == input$city),]$business_id
      temp <- bus[bus$business_id %in% ppp, ]
    }

    ch1 <- ggplot(temp, aes(x=stars,)) + geom_bar(color="darkorange", fill="orange") + coord_flip()
    ch2 <- ggplot(temp, aes(x=review_count,)) + geom_bar(color="darkorange", fill="orange") + coord_flip()
    multiplot(ch1,ch2, cols=2)
  })
  
  output$beats <- renderText({
    if (input$state=='All'){
      paste("The distribution of stars of all steakhouses in four states is shown in the left figure.")
    }
    else if (input$state != 'All' & input$city == 'All'){
      paste("The distribution of stars of all steakhouses in the selected state is shown in the left figure.")
    }
    else if (input$state != 'All' & input$city != 'All' & input$business_id == 'All') {
      paste("The distribution of stars of all steakhouses in the selected city is shown in the left figure.")
    }
    else {
      selected <- bus$stars[bus$business_id == input$business_id & bus$state == input$state & bus$city == input$city]
      p_all <- 100*round(sum(bus$stars<selected)/length(bus$stars),3)
      sc <- bus$name[bus$state==input$state & bus$city==input$city]
      city <- bus$stars[bus$name %in% sc]
      p_city <- 100*round(sum(city<selected)/length(city),3)
      st <- bus$name[bus$state==input$state]
      state <- bus$stars[bus$name %in% st]
      p_state <- 100*round(sum(state<selected)/length(state),3)
      paste("The distribution of stars of all steakhouses in the selected city is shown in the left figure. Your steakhouse is a",bus$stars[bus$business_id==input$business_id & bus$state==input$state & bus$city==input$city],"star restaurant.","You have beaten",p_city,"% steakhouses in the city,",p_state,"% steakhouses in the states, and",p_all,"% steakhouses in all four states.","\n","You may have a look at the distribution of the stars by reselecting in the sidebar.",sep=" ")
    }
  })
  
  output$pop <- renderText({
    if (input$state=='All'){
      paste("The distribution of review_counts of all steakhouses in four states is shown in the right figure.")
    }
    else if (input$state != 'All' & input$city == 'All'){
      paste("The distribution of review_counts of all steakhouses in the selected state is shown in the right figure.")
    }
    else if (input$state != 'All' & input$city != 'All' & input$business_id == 'All') {
      paste("The distribution of review_counts of all steakhouses in the selected city is shown in the right figure.")
    }
    else {
      selected1 <- bus$review_count[bus$business_id == input$business_id & bus$state == input$state & bus$city == input$city]
      p_all1 <- 100*round(sum(bus$review_count<selected1)/length(bus$review_count),3)
      sc1 <- bus$name[bus$state==input$state & bus$city==input$city]
      city1 <- bus$review_count[bus$name %in% sc1]
      p_city1 <- 100*round(sum(city1<selected1)/length(city1),3)
      st1 <- bus$named[bus$state==input$state]
      state1 <- bus$review_count[bus$name %in% st1]
      p_state1 <- 100*round(sum(state1<selected1)/length(state1),3)
      paste("The distribution of review_counts of all steakhouses in the selected city is shown in the right figure. Your steakhouse has ",bus$review_count[bus$business_id==input$business_id & bus$city==input$city & bus$state==input$state],"reviews in total.","You have beaten",p_city1,"% steakhouses in the city,",p_state1,"% steakhouses in the states, and",p_all1,"% steakhouses in all four states.","\n","You may have a look at the distribution of the stars by reselecting in the sidebar.",sep=" ")
    }
  })
  
  output$food <- renderImage({
    filename <- normalizePath(file.path('./food.jpg'))
    list(src = filename,         
         width = 500,
         height = 400)
  }, deleteFile = FALSE)
  
  output$service <- renderImage({
    filename <- normalizePath(file.path('./service.jpg'))
    list(src = filename,         
         width = 500,
         height = 400)
  }, deleteFile = FALSE)
  

  output$suggest <- renderText({
    name0 <- bus$name[bus$state==input$state & bus$city == input$city & bus$business_id == input$business_id]
    if (input$business_id=='All'){
      "Please select business_id first!"
    }
    else{
      if (name0 %in% bus$name){
        as.character(suggestions[suggestions$name==name0, 'suggestion'])
      }
      else{
        "Missing too many attributes to give suggestions!"
      }
    }
  })
  
  output$tt <- renderTable({
    name1 <- bus$name[bus$state==input$state & bus$city == input$city & bus$business_id == input$business_id]
    if (input$business_id=='All'){
      temp <- as.data.frame("Please select the restaurant first!")
    }
    else{
      if (name1 %in% bus$name){
        temp <- as.data.frame(strsplit(suggestions[suggestions$name==name1, 'suggestion'], "\n")[[1]])
        
        
      }
      else{
        temp <- as.data.frame("Missing too many attributes to give suggestions!")
      }
    }
    colnames(temp) <- 'Suggestions'
    temp
  })

  
})    



