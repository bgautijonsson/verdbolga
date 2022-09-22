library(shiny)
library(plotly)
library(cowplot)
library(tidyverse)
library(scales)
library(ggthemes)
library(kableExtra)
library(gganimate)
library(lubridate)
library(geomtextpath)
library(ggtext)
library(here)
library(readxl)
library(janitor)
library(DT)
library(bslib)
library(thematic)
library(shinycssloaders)
library(feather)
library(metill)
library(RcppRoll)

shinyOptions(plot.autocolor = TRUE)

#### DATA ####

d <- read_feather("data/undirvisitolur.feather")

flokkur_1 <- unique(d$flokkur_1)
flokkur_2 <- unique(d$flokkur_2)
flokkur_3 <- unique(d$flokkur_3)

d_comparison <- d |> 
  group_by(date) |> 
  summarise(ahrif = sum(ahrif)) |> 
  mutate(yearly_ahrif = roll_sum(ahrif, n = 12, align = "right", fill = NA),
         type = "Vísitala neysluverðs")

##### Sidebar Info and Plot Captions #####
# This is pasted into the sidebar on each page
sidebar_info <- paste0(
  br(" "),
  h5("Höfundur:"),
  p("Brynjólfur Gauti Guðrúnar Jónsson"),
  HTML("<a href='https://github.com/bgautijonsson/skattagogn'> Kóði og gögn </a>")
)
# This is the caption for plots
global_caption <- ""


##### THEMES #####
# Making a light and dark theme in case I want to offer the option later
theme_set(theme_metill())



bs_global_theme(
  bootswatch = "flatly"
)

bs_global_add_variables(
  primary = "#484D6D",
  secondary = "#969696",
  success = "#969696",
  # danger = "#FF8CC6",
  # info = "#FF8CC6",
  light = "#faf9f9",
  dark = "#484D6D",
  bg = "#faf9f9",
  fg = "#737373",
  "body-bg" = "#faf9f9",
  base_font = "Lato",
  heading_font = "Segoe UI",
  "navbar-brand-font-family" = "Playfair Display",
  code_font = "SFMono-Regular"
)


