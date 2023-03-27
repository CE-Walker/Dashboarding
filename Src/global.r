# rm(list=ls())
# cat("\014")

library(sf)
library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(stringr)
library(htmltools)
library(highcharter)
library(scales)
library(tidyr)




# # Set Working Directory
# setwd(dirname(rstudioapi::getSourceEditorContext()$path))

#define global variables
# df.hd <- NULL
# df.county <- NULL
# df.2020_election <- NULL
# df.2021_election <- NULL
# df.finance <- NULL


# Load Geo Data
geo.hd <- sf::st_read("Assets/geography/HD.json")
geo.county <- sf::st_read("Assets/geography/County.geojson")
geo.county$NAMELSAD <- str_to_title(geo.county$NAMELSAD)

# # Load 2022 Election Data
df.2021_election <- read.csv("Assets/election/2021_November_General_Adj.csv") # Partial Mapping File (not perfect)
df.2021_election$DistrictName <- df.2021_election$AdjHD
df.2021_election$LocalityName <- df.2021_election$LocalityName %>% str_replace_all("KING & QUEEN COUNTY", "King And Queen County")
df.2021_election$LocalityName <- str_to_title(df.2021_election$LocalityName)

# Load Finance Data
df.finance <- read.csv("Assets/finance/2022_House_Finances.csv")
df.finance$CandidateName <- str_to_title(df.finance$CandidateName)

summary_table <- function(df, distType, offTitle, df.geo, df.finance) {
  df <- df %>%
    filter(DistrictType == distType, TOTAL_VOTES != 0, OfficeTitle == offTitle) %>%
    group_by(DistrictName) %>%
    summarize(
      totVotes = sum(TOTAL_VOTES),
      rVotes   = sum(ifelse(Party == "Republican", TOTAL_VOTES, 0)),
      dVotes   = sum(ifelse(Party == "Democratic", TOTAL_VOTES, 0)),
      rCand    = last(LastName[Party == "Republican"][LastName[Party == "Republican"] != ""]),
      dCand    = last(LastName[Party == "Democratic"][LastName[Party == "Democratic"] != ""])
    ) %>%
    mutate(
      pcR = rVotes / totVotes,
      pcD = dVotes / totVotes,
      pcDiff = pcR - pcD,
      result =
        ifelse(pcDiff > .2, "Strong R",
          ifelse(pcDiff > .05, "Lean R",
            ifelse(pcDiff > -.05, "Swing",
              ifelse(pcDiff > -.2, "Lean D", "Strong D")
            )
          )
        )
    )
  colnames(df) <- stringr::str_replace_all(colnames(df), "DistrictName", "District")
  df$District <- as.numeric(df$District)
  df <- merge(df.geo, df, by.x = "DISTRICT", by.y = "District", all.x = TRUE)
  colnames(df) <- stringr::str_replace_all(colnames(df), "DISTRICT", "District")
  df$result <- ifelse(is.na(df$pcDiff), "No Data", df$result) # Remove NA's introduced from merging w/ geo file

  df.finSum <- df.finance %>%
    group_by(District, Party) %>%
    summarise(
      total_cash = sum(EndingBalance),
      total_exp = sum(TotalDisbursements),
      total_raised = sum(TotalExpendableFunds),
      candidate = first(CandidateName)
    ) %>%
    pivot_wider(names_from = Party, values_from = c(candidate, total_cash, total_exp, total_raised), names_sep = "_")

  df <- merge(df, df.finSum, by.x = "District", by.y = "District", all.x = TRUE)
  return(df)
}
df.hd <- summary_table(df = df.2021_election, distType = "House of Delegates", offTitle = "Member House of Delegates", df.geo = geo.hd, df.finance = df.finance)

county_summary <- function(df, distType, offTitle, groupDist) {
  df <- df %>% filter(DistrictType == distType, TOTAL_VOTES != 0, OfficeTitle == offTitle)

  if (groupDist) {
    df <- df %>% group_by(DistrictName, LocalityName)
  } else {
    df <- df %>% group_by(LocalityName)
  }

  df <- df %>%
    summarize(
      totVotes = sum(TOTAL_VOTES),
      rVotes   = sum(ifelse(Party == "Republican", TOTAL_VOTES, 0)),
      dVotes   = sum(ifelse(Party == "Democratic", TOTAL_VOTES, 0)),
      rCand    = last(LastName[Party == "Republican"][LastName[Party == "Republican"] != ""]),
      dCand    = last(LastName[Party == "Democratic"][LastName[Party == "Democratic"] != ""])
    ) %>%
    mutate(
      pcR = rVotes / totVotes,
      pcD = dVotes / totVotes,
      pcDiff = pcR - pcD,
      result =
        ifelse(pcDiff > .2, "Strong R",
          ifelse(pcDiff > .05, "Lean R",
            ifelse(pcDiff > -.05, "Swing",
              ifelse(pcDiff > -.2, "Lean D", "Strong D")
            )
          )
        )
    )
  colnames(df) <- stringr::str_replace_all(colnames(df), "LocalityName", "County")
  df <- merge(geo.county, df, by.x = "NAMELSAD", by.y = "County")

  return(df)
}
df.county <- county_summary(df = df.2021_election, distType = "House of Delegates", offTitle = "Member House of Delegates", groupDist = TRUE)

# Create a list of all unique districts in the election_data dataframe (do not use until mapping table is finished)
districts <- sort(unique(df.2021_election$DistrictName))
# Use apply() to create binary columns for each district
df.county[paste0("D_", districts)] <- t(apply(df.county, 1, function(x) {
  sapply(districts, function(y) {
    ifelse(x["NAMELSAD"] %in% df.2021_election$LocalityName[df.2021_election$DistrictName == y], TRUE, FALSE)
  })
}))
# Document this code

source("Src/functions.r")
source("Src/ui.r")
source("Src/server.r")

# Run Shiny App
shiny::shinyApp(ui, server)
