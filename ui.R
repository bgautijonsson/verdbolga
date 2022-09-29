ui <- shinyUI(
  tagList(
    tags$head(
      tags$style(
        type = "text/css",
        "
                .navbar-brand {
                    display: none;
                }
                .navbar {
                        font-family: Optima;
                        font-weight: 300;
                        font-size: 20px;
                        padding-top: 5px;
                        padding-bottom: 5px;
                }
                "
      )
    ),
    navbarPage("Vísitala neysluverðs",
               theme = bs_global_get(),
               
               
               #### UNDIRVÍSITÖLUR ####
               tabPanel(
                 title = "Hver er þín verðbólga?",
                 undirvisitolur_ui("undirvisitolur")
               )
    )
  )
)
