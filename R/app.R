options(shiny.port = 8050, shiny.autoreload = TRUE)

# library(shiny)
library(bslib)
library(shinythemes)
source("01-data_preprocessing.R")
source("02-ploting_functions.R")

#### App Layout ####
ui <- fluidPage(theme = shinytheme("spacelab"),
  
  titlePanel("How Much Are Manager Getting Paid Around the World?"),
  
  layout_sidebar(
    sidebar = sidebar(
      position = "left",
      
      h3("Filter Options"),
      
      selectizeInput(
        "industry", "Select Industry / Industries:", unique(df$industry),
        multiple = TRUE,
        selected = NULL
      ),
      
      selectizeInput(
        "country", "Select Country / Countries:", unique(df$country_cleaned),
        multiple = TRUE,
        selected = NULL
      )
    ),
    
    mainPanel(
      
      fluidRow(
        column(
          12,
          plotlyOutput("world_map_plot", height = "480px", width = "1050px"),
        ),
        div(style = "height:500px"),
      ),

      fluidRow(
        column(
          8,
          plotOutput("salary_plot", height = "300px"),
        ),
        column(
          4,
          plotOutput("gender_plot",  height = "350px"),
        )
      )
    )
  )
)




#### Server side callbacks/reactivity ####

server <- function(input, output, session) {
  
  #### Filter ####
  DataFilter <- reactive({
    if(is.null(input$industry) &
       is.null(input$country)){
      df
    } else if(is.null(input$industry)){
      df |> 
        filter(country_cleaned %in% input$country)
    } else if(is.null(input$country)){
      df |> 
        filter(industry %in% input$industry)
    } else {
      df |> 
        filter(industry %in% input$industry,
               country_cleaned %in% input$country)
    }
  })
  
  
  #### Plot 1: Country Region ####
  output$world_map_plot <- renderPlotly({
    req(DataFilter())
    p <- plot_world_map(DataFilter())
    ggplotly(p, tooltip = c("label"))
  })
  
  #### Plot 2: Salary Plot ####
  output$salary_plot <- renderPlot({
    req(DataFilter())
    plot_salary(DataFilter())
  })
  
  #### Plot 3: Gender Ratio ####
  output$gender_plot <- renderPlot({
    req(DataFilter())
    plot_gender_ratio(DataFilter())
  })
}

# Run the app/dashboard
shinyApp(ui, server)
