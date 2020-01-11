# Define UI for application that draws a histogram
daneWoj<-read.csv("mieszkania-woj.csv", encoding = "UTF-8")

library(shiny)
regions<-factor(daneWoj$Wojewodztwo)%>%levels()
years<-factor(daneWoj$Rok)%>%levels()

`%!in%` = Negate(`%in%`)

ui <- fluidPage(
    titlePanel(title="Analiza rynkowej sprzedaży lokali mieszkalnych"),
    navbarPage("Projekt AWD 2019",
               tabPanel("Województwa",
                        sidebarLayout(
                            sidebarPanel(
                                selectInput("modeWoj",
                                            choices=list(
                                                "średnie ceny za m2" = 1,
                                                "liczba sprzedanych mieszkań(rok/woj)" = 2,
                                                "liczba sprzedanych mieszkań(cena)" = 3
                                            ),
                                            label="Wybierz dane do Analizy",
                                            selected=1
                                            
                                ),
                                
                                
                                checkboxGroupInput("WojewodztwaCheckGroup",
                                                   label="Wybierz województwa",
                                                   choices=regions,
                                                   selected=c(regions[2], regions[7])
                                                   
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
                                                       selected=years
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
                                ),
                                conditionalPanel(
                                    condition="input.modeWoj == 3",
                                    selectInput("RokSelectInput3",
                                                label="Wybierz rok",
                                                choices=years,
                                                selected=years[1]
                                    ),
                                ),
                                width = 4
                            ),
                            mainPanel(
                                plotOutput(outputId = "plotWoj1",
                                           width = "100%",
                                           height = "100%")
                            )
                        )   
               )
               
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$plotWoj1<-renderPlot({
        
        if(input$modeWoj == 1){
            plotDataWoj<-filter(daneWoj, Wojewodztwo %in% input$WojewodztwaCheckGroup)
            plotDataMarket<-filter(plotDataWoj, Rynek==input$RynekInput)
            plotDataArea<-filter(plotDataMarket, Metraz %!in% c("do 40 m2","od 40,1 do 60 m2", "od 60,1 do 80 m2","od 80,1 m2"))
            plotDataYear<-filter(plotDataArea, Rok %in% input$RokCheckGroup)
            plotData<-plotDataYear
            ymax<-round(max(as.vector(plotData[,9])),digits=-4)
            ystep<-ymax/10
            
            gout <- ggplot(plotData, aes(x=Wojewodztwo, y=Srednia.Cena.m2, fill=factor(Rok))) +
                geom_bar(stat="identity", position=position_dodge()) + theme(axis.text.x = element_text(angle = 65, hjust = 1)) +
                labs(title="Średnie ceny w wojewodztwach", fill="Rok") + 
                scale_y_continuous(limits=c(0, ymax)) +
                geom_point(aes(y=Mediana.m2), position=position_dodge(width=0.9), shape=4) +
                ylab("Średnia cena za 1 m2")
            
        }else if(input$modeWoj == 2){
            plotDataWoj<-filter(daneWoj, Wojewodztwo %in% input$WojewodztwaCheckGroup)
            plotDataMarket<-filter(plotDataWoj, Rynek==input$RynekInput)
            plotDataArea<-filter(plotDataMarket, Metraz %in% input$MetrazeGroup)
            plotDataYear<-filter(plotDataArea, Rok == input$RokSelectInput)
            plotData<-plotDataYear
            
            gout <- ggplot(plotData, aes(x=Wojewodztwo, y=Liczba.Sprzedanych.M, fill=factor(Metraz))) +
                geom_bar(stat="identity", position=position_dodge()) + theme(axis.text.x = element_text(angle = 65, hjust = 1)) +
                labs(title="Liczba sprzedanych mieszkan", fill="Metraz") + 
                ylab("Liczba sprzedanych mieszkan")
        }else{
            plotDataWoj<-filter(daneWoj, Wojewodztwo %in% input$WojewodztwaCheckGroup)
            plotDataMarket<-filter(plotDataWoj, Rynek==input$RynekInput)
            plotDataArea<-filter(plotDataMarket, Metraz %!in% c("do 40 m2","od 40,1 do 60 m2", "od 60,1 do 80 m2","od 80,1 m2"))
            plotDataYear<-filter(plotDataArea, Rok %in% input$RokSelectInput3)
            plotData<-plotDataYear
            ymax<-round(max(as.vector(plotData[,6])))
            ystep<-ymax/10
            
            gout <- ggplot(plotData, aes(x=Srednia.Cena.m2, y=Liczba.Sprzedanych.M, color=Wojewodztwo, label=Wojewodztwo)) +
                geom_point(show.legend = F, size=10) + geom_text(show.legend = F, angle=45, hjust=0.5, vjust=2, size=7) +
                labs(title="Liczba sprzedanych mieszkań w zależności od ceny za 1 m2") +
                xlab("Średnia cena za 1 m2") + ylab("Liczba sprzedanych mieszkan") + 
                scale_y_continuous(limits=c(0, ymax))
        }
        gout + theme(axis.text=element_text(size=14),
                  axis.title=element_text(size=16,face="bold"),
                  plot.title = element_text(size=28, face="bold"))
        
    }, height = 700)
}


# Run the application 
shinyApp(ui = ui, server = server)
