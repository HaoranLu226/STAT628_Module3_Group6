library(shiny)
library(leaflet)
library(ggplot2)
library(Rmisc)

navbarPage('Data-driven Business Plan for Steakhouses',inverse = T,collapsible = T,
               tabPanel("Group 6",
                        h1(span("Yelp Steakhouse Business Analysis", style = "font-weight: 300"), 
                                  style = "font-family: 'Source Sans Pro'; text-align: center;padding: 15px"),
                               sidebarLayout(position = "right",
                                   sidebarPanel(
                                       p("Please choose your steakhouse:"),
                                       selectInput("state", "State:",choices = c("All", as.character(unique(bus$state)))),
                           
                                       selectInput("city", "City:", choices = c("All", as.character(unique(bus$city)))),
                           
                                       selectInput("name", "Steakhouse Name:", choices = c("All", as.character(bus$name))),
                                       h5("If any question, please contact us:"),
                                       p("Haoran Lu, hlu226@wisc.edu"),
                                       p("Mengkun Chen, mchen373@wisc.edu"),
                                       p("Rui Huang, rhuang95@wisc.edu")
                                       ),
                        mainPanel(
                            tabsetPanel(
                                tabPanel("Guide",h1(" Guide for this app"),plotOutput('steak', width = "80%", height = 220),
                                         p("This app is designed to provide valuable information and actionable advice about the steakhouses in OH, PA, WI, and IL. The main functions are as follow:"),
                                         p("Rankings——You can have an intuitive understanding of the star ranking and popularity ranking of your steak house in the city located. At the same time, through the selecting function of the sidebar, you can obtain the distribution of star ratings and review counts of a specified city or state, to better understand the position of restaurant operations in the entire industry."),
                                         p("Food Advice--You can intuitively understand which attributes of the steakhouse are more crucial in terms of food through the word cloud diagram. And accordingly, specific food-related suggestions for the entire steakhouse industry are provided."),
                                         p("Service Advice--You can intuitively understand which attributes of the steakhouse are more crucial in terms of service through the word cloud diagram. And accordingly, specific service-related suggestions for the entire steakhouse industry are provided."),
                                         p("Personalized Business Advice--This is the most valuable part of this app, where you will get very detailed and actionable suggestions on your steakhouse to improve the operations."),
                                         ),
                                
                                tabPanel("Rankings", plotOutput('ranking', width = "100%", height = 300),h2("Stars Ranking:"),textOutput('beats'),h2("Popularity:"),textOutput('pop')),
                                tabPanel("Food Advice",h2("Food-related Keywords"),
                                         imageOutput("food"),
                                         h2("Food-related Suggestions"),p("Steak Quality! For a steak house, the priority is to ensure the quality of the steak. This is what customers pay most attention to."),
                                        # br(),
                                         p("Design your desserts! Please pay attention to the whole procedure of the dinner, including appetizer, side dish, soup, salads. Especially, we found customers have special interests in desserts, so serving creative desserts may greatly help to attract customers."),
                                        # br(),
                                         p("Serve sea foods! Besides beef, customers often consider our type of meats. We found sea foods is seafood is the most popular besides steaks. It will be a good idea to serve crabs, shrimps, tuna, salmon and oysters."),
                                        # br(),
                                         p("Special foods are a good idea! We found sushi is very popular to the customers. Serving some special foods like Asian foods or Italian foods can make your restaurant unique to the others."),
                                        # br(),
                                         p("Good Drinks! A good bartender can bring a lot of praise to the restaurant. Please pay extra attention to make good martinis, people like them!")),
                                tabPanel("Service Advice",h2("Service-related Keywords"),
                                         imageOutput("service"),
                                         h2("Service-related Suggestions"),p("Service well! Service is always important for a fine restaurant. Please serve friendly and quickly. Offering convenient reservation and delivery will also help a lot."),
                                         # br(),
                                         p("Nice Atmosphere! Atmosphere is found to be the most important non-food factor for a steak house. Comfortable music, warm lighting and beautiful tableware etc., will make a pleasant dining atmosphere."),
                                         # br(),
                                         p("Make prices reasonable! People always cares about prices. We recommend setting relatively high prices for high-quality ingredients and designing some affordable dishes. This allows customers to choose for themselves."),
                                         # br(),
                                         p("Special foods are a good idea! We found sushi is very popular to the customers. Serving some special foods like Asian foods or Italian foods can make your restaurant unique to the others."),
                                         # br(),
                                         p("Brunch is a good idea! Customers like brunch and it will bring extra income to the restaurant.")),
                                
                                tabPanel("Personalized Business Advice", tableOutput('tt'))
                            )
                           
                        )
               ))
)