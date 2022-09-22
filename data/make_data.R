library(tidyverse)
library(pxweb)
library(lubridate)
library(feather)


d <- pxweb_get(
  url ="https://px.hagstofa.is:443/pxis/api/v1/is/Efnahagur/visitolur/1_vnv/2_undirvisitolur/VIS01301.px", 
  query = list(
    "Mánuður" = c("*"),
    "Liður"  = c("effect", "change_M", "breakdown"),
    "Undirvísitala" = c("*")
  ),
  verbose = FALSE
) |> 
  as.data.frame() |> 
  as_tibble() |> 
  janitor::clean_names() |> 
  separate(manudur, into = c("ar", "manudur"), sep = "M", convert = T) |> 
  mutate(manudur = str_pad(manudur, width = 2, side = "left", pad = "0"),
         date = str_c(ar, "-", manudur, "-01") |> ymd(),
         visitala_neysluverds = visitala_neysluverds / 100) |> 
  select(date, undirvisitala, lidur, value = visitala_neysluverds)|> 
  mutate(
    flokkur_1 = ifelse(
      str_detect(undirvisitala, "^[0-9]{2} "),
      undirvisitala,
      NA
    ),
    flokkur_2 = ifelse(
      str_detect(undirvisitala, "^[0-9]{3} "),
      undirvisitala,
      NA
    ),
    flokkur_3 = ifelse(
      str_detect(undirvisitala, "^[0-9]{4} "),
      undirvisitala,
      NA
    )
  ) |> 
  group_by(date, lidur) |> 
  fill(flokkur_1, .direction = "down") |> 
  group_by(date, lidur, flokkur_1) |> 
  fill(flokkur_2, .direction = "down") |> 
  group_by(date, lidur, flokkur_1, flokkur_2) |> 
  fill(flokkur_3, .direction = "down") |> 
  ungroup() |> 
  mutate(
    flokkur_1 = ifelse(is.na(flokkur_1), "Heild", flokkur_1),
    flokkur_2 = ifelse(is.na(flokkur_2), flokkur_1, flokkur_2),
    flokkur_3 = ifelse(is.na(flokkur_3), flokkur_2, flokkur_3)
    ) |> 
  select(date, starts_with("flokkur"), name = lidur, value) |> 
  pivot_wider(names_from = name, values_from = value) |> 
  janitor::clean_names() |> 
  rename(vaegi = "vaegi_percent", "breyting" = "manadarbreyting_percent", "ahrif" = "ahrif_a_visitolu_percent") |> 
  filter(flokkur_1 != "Heild") |> 
  group_by(flokkur_1) |> 
  filter(
    (flokkur_2 != flokkur_1) | all(flokkur_2 == flokkur_1)
  ) |> 
  group_by(flokkur_2) |> 
  filter(
    (flokkur_3 != flokkur_2) | all(flokkur_3 == flokkur_2)
  )

d |> 
  write_feather("data/undirvisitolur.feather")
