# turbulence vs insolation
# dew vs surface pressure
library(readxl)
library(dplyr)
library(tidyverse)
onionData = readRDS("cleandata/rainfall_data.rds")

yvars = c("actual", "normal", "deviation")
zvars = sort(unique(onionData$district))

ui <- fluidPage(
  selectInput('Yvarname', 'Select Name', yvars),
  selectInput('Zvarname', 'Select Name', zvars),
  
  # CODE BELOW: Add a plotly output named 'plot_trendy_names'
  plotly::plotlyOutput('plot_trendy_names')
  
)
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
    data = onionData %>% filter(district==input$Zvarname) 
    ggplot(data, aes(x = date, y = actual)) + geom_line()
  }
  # CODE BELOW: Render a plotly output named 'plot_trendy_names'
  output$plot_trendy_names <- plotly::renderPlotly({
    plot_trends()
  })
}
shinyApp(ui = ui, server = server)