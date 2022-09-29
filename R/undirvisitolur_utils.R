make_visitala_data <- function(input) {
  data <- d |> 
    group_by(date) |> 
    mutate(total_vaegi = sum(vaegi)) |> 
    ungroup() |> 
    filter(flokkur_3 %in% input$flokkur_3) |> 
    group_by(date) |> 
    mutate(vaegi = total_vaegi * vaegi / sum(vaegi),
           ahrif = vaegi * breyting) |> 
    summarise(
      ahrif = exp(sum(log(1 + ahrif))) - 1,
      .groups = "drop"
    ) |> 
    mutate(
      yearly_ahrif = exp(roll_sum(log(1 + ahrif), n = 12, align = "right", fill = NA)) - 1,
      type = "Þín vísitala"
    ) |> 
    bind_rows(
      d_comparison
    ) |> 
    drop_na(yearly_ahrif) |> 
    mutate(
      text = str_c(
        "<b style='text-align:center;'>", type, "</b>", "\n",
        "Dagsetning: ", date, "\n",
        "Verðbólga (árleg): ", hlutfall(yearly_ahrif), "\n",
        "Verðbólga (mánaðarleg): ", hlutfall(ahrif)
      )
    )
  
  data
  
}

make_visitala_plot <- function(data, input) {
  
  data |> 
    ggplot(aes(date, yearly_ahrif, text = text)) +
    geom_hline(yintercept = 0, lty = 2, alpha = 0.4) +
    geom_line(aes(col = type, group = type)) +
    scale_y_continuous(
      labels = hlutfall
    ) +
    scale_colour_manual(
      values = c(
        "#377eb8",
        "#e41a1c"
      )
    ) +
    theme(legend.position = "top") +
    labs(title = "Hver er þín persónulega verðbólga?",
         x = NULL,
         y = NULL,
         colour = NULL)
  
}

make_visitala_plotly <- function(my_plot, input) {
  ggplotly(
    my_plot,
    tooltip = "text"
  ) |> 
    layout(hoverlabel = list(align = "left"),
           margin = list(
             t = 60,
             r = 15,
             b = 120,
             l = 0
           ),
           legend = list(
             orientation = "h",
             yanchor = "bottom",
             y = 0.99, 
             x = 0
           ),
           annotations = list(
             list(x = 0.8, xanchor = "right", xref = "paper",
                  y = -0.15, yanchor = "bottom", yref = "paper",
                  showarrow = FALSE,
                  text = global_caption)
           ))
}

undirvisitolur_texti <- str_c(
  "Persónulega vísitalan er reiknuð með því að taka bara þá undirflokka vísitölunnar ",
  "sem eru valdir, reikna nýtt vægi þeirra í vísitölunni, og reikna svo nýja verðbólgu út frá verðbreytingu ",
  "flokkanna og vægi þeirra í nýrri vísitölu"
)
