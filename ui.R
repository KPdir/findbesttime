ui <- fluidPage(
        titlePanel("Want to know the best departure time for your trip you do? Ask the traffic Yoda!!"),
        sidebarLayout(
                sidebarPanel(
                        textInput("origin", label = h3("Origin"), 
                                  value = "Enter origin address here ...", width = '400px'),
                        textInput("destination", label = h3("Destination"), 
                                  value = "Enter destination address here ...", width = '400px'),
                        dateInput("tdate", label = h3("Travel date"), value = Sys.Date() + 1, 
                                  min = Sys.Date() + 1, max = Sys.Date() + 60, 
                                   startview = "month", language = "en"),
                        actionButton("Go", label = "Go" , width = '100%')
                , width = 3),
                mainPanel(
                        img(src="https://upload.wikimedia.org/wikipedia/en/9/9b/Yoda_Empire_Strikes_Back.png", height = 400, width = 400)
                        h4("Origin address detected"),
                        fluidRow(column(12 , verbatimTextOutput("value1"))),
                        h4("Destination address detected"),
                        fluidRow(column(12, verbatimTextOutput("value2"))),
                        plotOutput("tsplot")
                )
        )
)
