library(shiny)
library(leaflet)
library(ggplot2)
library(Rmisc)


shinyServer(function(input, output, session) {
  sidebarcity <- reactive({
    c("All", as.character(unique(bus[bus$state==input$state, ]$city)))
  })
  
  steakhouse <- reactive({
    c("All", as.character(bus[(bus$state==input$state)&(bus$city==input$city), ]$name))
  })
  
  observe({
    updateSelectInput(session, 'city', choices=sidebarcity())
  })
  
  observe({
    updateSelectInput(session, 'name', choices=steakhouse())
  })
  
  output$ranking <- renderPlot({
    if (input$state == 'All'){
      oout <- bus
    }
    else if (input$state != 'All' & input$city == 'All'){
      oout <- bus[bus$state == input$state, ]
    }
    
    else if (input$state != 'All' & input$city != 'All' ) {
      ppp <- bus[(bus$state == input$state) & (bus$city == input$city),]$business_id
      oout <- bus[bus$business_id %in% ppp, ]
    }

    ch1 <- ggplot(oout, aes(x=stars,)) + geom_bar(color="darkorange", fill="orange") + coord_flip()
    ch2 <- ggplot(oout, aes(x=review_count,)) + geom_bar(color="darkorange", fill="orange") + coord_flip()
    multiplot(ch1,ch2, cols=2)
  })
  
  output$beats <- renderText({
    if (input$state=='All'){
      paste("The distribution of stars of all steakhouses in four states is shown in the left figure.")
    }
    else if (input$state != 'All' & input$city == 'All'){
      paste("The distribution of stars of all steakhouses in the selected state is shown in the left figure.")
    }
    else if (input$state != 'All' & input$city != 'All' & input$name == 'All') {
      paste("The distribution of stars of all steakhouses in the selected city is shown in the left figure.")
    }
    else {
      selected <- bus$stars[bus$name == input$name & bus$state == input$state & bus$city == input$city]
      p_all <- 100*round(sum(bus$stars<selected)/length(bus$stars),3)
      sc <- bus$business_id[bus$state==input$state & bus$city==input$city]
      city <- bus$stars[bus$business_id %in% sc]
      p_city <- 100*round(sum(city<selected)/length(city),3)
      st <- bus$business_id[bus$state==input$state]
      state <- bus$stars[bus$business_id %in% st]
      p_state <- 100*round(sum(state<selected)/length(state),3)
      paste("The distribution of stars of all steakhouses in the selected city is shown in the left figure. Your steakhouse is a",bus$stars[bus$name==input$name & bus$state==input$state & bus$city==input$city],"star restaurant.","You have beaten",p_city,"% steakhouses in the city,",p_state,"% steakhouses in the states, and",p_all,"% steakhouses in all four states.","\n","You may have a look at the distribution of the stars by reselecting in the sidebar.",sep=" ")
    }
  })
  
  output$pop <- renderText({
    if (input$state=='All'){
      paste("The distribution of review_counts of all steakhouses in four states is shown in the right figure.")
    }
    else if (input$state != 'All' & input$city == 'All'){
      paste("The distribution of review_counts of all steakhouses in the selected state is shown in the right figure.")
    }
    else if (input$state != 'All' & input$city != 'All' & input$name == 'All') {
      paste("The distribution of review_counts of all steakhouses in the selected city is shown in the right figure.")
    }
    else {
      selected1 <- bus$review_count[bus$name == input$name & bus$state == input$state & bus$city == input$city]
      p_all1 <- 100*round(sum(bus$review_count<selected1)/length(bus$review_count),3)
      sc1 <- bus$business_id[bus$state==input$state & bus$city==input$city]
      city1 <- bus$review_count[bus$business_id %in% sc1]
      p_city1 <- 100*round(sum(city1<selected1)/length(city1),3)
      st1 <- bus$business_id[bus$state==input$state]
      state1 <- bus$review_count[bus$business_id %in% st1]
      p_state1 <- 100*round(sum(state1<selected1)/length(state1),3)
      paste("The distribution of review_counts of all steakhouses in the selected city is shown in the right figure. Your steakhouse has ",bus$review_count[bus$name==input$name & bus$city==input$city & bus$state==input$state],"reviews in total.","You have beaten",p_city1,"% steakhouses in the city,",p_state1,"% steakhouses in the states, and",p_all1,"% steakhouses in all four states.","\n","You may have a look at the distribution of the stars by reselecting in the sidebar.",sep=" ")
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
    id0 <- bus$business_id[bus$state==input$state & bus$city == input$city & bus$name == input$name]
    if (input$name=='All'){
      "Please select your steakhouse first."
    }
    else{
      if (id0 %in% bus$business_id){
        as.character(suggestions[suggestions$business_id==id0, 'suggestion'])
      }
      else{
        "Missing too many attributes to give suggestions!"
      }
    }
  })
  
  output$tt <- renderTable({
    id1 <- bus$business_id[bus$state==input$state & bus$city == input$city & bus$name == input$name]
    if (input$name=='All'){
       ooout <- as.data.frame("Please select your steakhouse first.")
    }
    else{
      if (id1 %in% bus$business_id){
        ooout <- as.data.frame(strsplit(suggestions[suggestions$business_id==id1, 'suggestion'], "\n")[[1]])
      }
      else{
        ooout <- as.data.frame("Missing too many attributes to give suggestions!")
      }
    }
    colnames(ooout) <- 'Suggestions:'
    ooout
  })

  
})    



