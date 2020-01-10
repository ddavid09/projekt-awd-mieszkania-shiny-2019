# Define UI for application that draws a histogram
#source("loadData.R")
daneWoj<-read.csv("mieszkania-woj.csv", encoding = "UTF-8")
daneBydWaw<-read.csv("mieszkania-bydwaw.csv", encoding = "UTF-8")

library(shiny)
regions<-factor(daneWoj$Wojewodztwo)%>%levels()
years<-factor(daneWoj$Rok)%>%levels()

ui <- fluidPage(
    titlePanel(title="Analiza rynkowej sprzedaży lokali mieszkalnych"),
    navbarPage("Projekt AWD 2019",
               tabPanel("Województwa",
                        sidebarLayout(
                            sidebarPanel(
                                selectInput("modeWoj",
                                            choices=list(
                                                "średnie ceny za m2" = 1,
                                                "liczba sprzedanych mieszkań" = 2
                                            ),
                                            label="Wybierz dane do Analizy",
                                            selected="Wybierz dane"
                                    
                                ),
                                
                                
                                checkboxGroupInput("WojewodztwaCheckGroup",
                                                   label="Wybierz województwa",
                                                   choices=regions,
                                                   selected=regions[7]
                                                   
                                ),
                                
                                selectInput("RynekInput",
                                             label="Wybierz rynek",
                                             choices=factor(daneWoj$Rynek)%>%levels()
                                ),
                                conditionalPanel(
                                    condition="input.modeWoj == 1",
                                    checkboxGroupInput("RokCheckGroup",
                                                       label="Wybierz rok/lata",
                                                       choices=years,
                                                       selected=years[4]
                                    ) 
                                ),
                                conditionalPanel(
                                    condition="input.modeWoj == 2",
                                    selectInput("RokSelectInput",
                                                       label="Wybierz rok",
                                                       choices=years,
                                                       selected=years[1]
                                    ),
                                    checkboxGroupInput("MetrazeGroup",
                                                       label="Wybierz metraż",
                                                       choices=c(
                                                           "do 40 m2",
                                                           "od 40,1 do 60 m2", 
                                                           "od 60,1 do 80 m2",
                                                           "od 80,1 m2" ,
                                                           "ogółem"
                                                       ),
                                                       selected="do 40 m2"
                                    )
                                )
                            ),
                            mainPanel(
                                
                            )
                        )   
               ),
               tabPanel("Warszawa/Bydgoszcz",
                        sidebarLayout(
                            sidebarPanel(
                                
                            ),
                            mainPanel(
                                
                            )
                        )
                        
               )
               
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
}


# Run the application 
shinyApp(ui = ui, server = server)
