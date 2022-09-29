##### UI #####

undirvisitolur_ui <- function(id) {
  tabPanel("Dreifing",
           
           sidebarLayout(
             sidebarPanel(
               selectInput(
                 inputId = NS(id, "flokkur_3"),
                 label = "Undirvísitala",
                 choices = flokkur_3,
                 multiple = TRUE,
                 selectize = TRUE,
                 selected = "042 Reiknuð húsaleiga"
               ),
               
               div(
                 actionButton(
                   inputId = NS(id, "goButton"),
                   label = "Sækja gögn",
                   width = "120px"
                 ),
                 class = "center", align = "middle"
               ),
               
               br(),
               undirvisitolur_texti,
               br(),
               
               HTML(sidebar_info)
             ),
             
             
             mainPanel(
               plotlyOutput(NS(id, "compare_plot"), height = 600, width = "100%")
             )
           )
           
  )
}


##### SERVER #####

undirvisitolur_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    visitala_df <- reactive({
      
      make_visitala_data(input)
      
    }) 
    
    visitala_plot <- reactive({
      
      make_visitala_data(input) |> 
        make_visitala_plot(input)
      
    })
    
    
    output$compare_plot <- renderPlotly({
      
      make_visitala_plotly(
        visitala_plot()
      )
      
    }) |> 
      bindEvent(
        input$goButton,
        ignoreNULL = FALSE
      )
    
    
  })
}