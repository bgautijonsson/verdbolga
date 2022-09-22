ui <- navbarPage("Vísitala neysluverðs",
                 theme = bs_global_get(),
                 position = "fixed-top",
                 
                 tags$style(
                     type = "text/css", 
                     ".navbar {
                        font-family: Segoe UI;
                        font-face: bold;
                        font-size: 20px;
                        padding-top: 5px;
                        padding-bottom: 5px;
                     }"
                 ),
                 
                 #### UNDIRVÍSITÖLUR ####
                 tabPanel(
                   title = "Hver er þín verðbólga?",
                   undirvisitolur_ui("undirvisitolur")
                 ),
                 
                 #### HAFÐU SAMBAND ####
                 tabPanel(
                   title = "Hafðu samband",
                   hafdusamband_ui("hafdusamband")
                 )
)
