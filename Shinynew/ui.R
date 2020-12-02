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
                                     
                        ),
                        mainPanel(
                            tabsetPanel(
                                tabPanel("Rankings & Popularity", plotOutput('ranking', width = "100%", height = 300),h2("Stars Ranking:"),textOutput('beats'),h2("Popularity:"),textOutput('pop')),
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