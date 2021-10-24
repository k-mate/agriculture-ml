# turbulence vs insolation
# dew vs surface pressure
library(readxl)
library(dplyr)
library(tidyverse)
mandiData = readRDS("cleandata/mandi_top10_data.rds")

marketVars = sort(unique(mandiData$market))

ui <- fluidPage(
  selectInput('Yvarname', 'Select Name', marketVars),

  # CODE BELOW: Add a plotly output named 'plot_trendy_names'
  plotly::plotlyOutput('plot_trendy_names')
)



server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
    mandiData %>% filter(market==input$Yvarname) %>% 
      ggplot(aes(x = date, mod_price)) + geom_bar(stat = "identity") +
      geom_point(size=0.5)
  }
  # CODE BELOW: Render a plotly output named 'plot_trendy_names'
  output$plot_trendy_names <- plotly::renderPlotly({
    plot_trends()
  })
}
shinyApp(ui = ui, server = server)