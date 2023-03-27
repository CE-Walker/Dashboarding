titleText <- function(type, clicked_dist) {
  if (type == "Statewide") {
    titleText <- paste0("STATEWIDE")
  } else if (type == "District") {
    titleText <- paste0("HD ", clicked_dist)
  }
  titleText
}

statewide_map <- function(df) {
  factpal <- colorFactor(
    palette = c(
      "#8fbfea", # Light Blue
      "#ea9999", # Light Red
      "#1d89ea", # Dark Blue
      "#CD2626", # Dark Red
      "#b4a7d6" # Purple
    ),
    domain = c(
      "Lean D",
      "Lean R",
      "Strong D",
      "Strong R",
      "Swing"
    )
  )

  Labels <- sprintf(
    paste0(
      "<b>", "House District ", as.numeric(df$District), "</b>",
      "<br/>", "(R) ", as.character(df$candidate_Republican), " ", dollar(as.numeric(df$total_cash_Republican)),
      "<br/>", "(D) ", as.character(df$candidate_Democratic), " ", dollar(as.numeric(df$total_cash_Democratic))
    )
  ) %>%
    lapply(function(x) HTML(x))

  m <- leaflet(
    options = leafletOptions(
      attributionControl = FALSE,
      doubleClickZoom = FALSE,
      zoomControl = FALSE,
      dragging = FALSE
    )
  ) %>%
    addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
    addPolygons(
      data = df,
      layerId = df$District,
      weight = 0.5,
      smoothFactor = 0.3,
      label = ~Labels,
      color = "black",
      fillColor = ~ factpal(result),
      fillOpacity = 0.75
    )

  m
}

statewide_map.proxy <- function(df) {
  factpal <- colorFactor(
    palette = c(
      "#8fbfea", # Light Blue
      "#ea9999", # Light Red
      "#1d89ea", # Dark Blue
      "#CD2626", # Dark Red
      "#b4a7d6" # Purple
    ),
    domain = c(
      "Lean D",
      "Lean R",
      "Strong D",
      "Strong R",
      "Swing"
    )
  )


  Labels <- sprintf(
    paste0(
      "<b>", "House District ", as.numeric(df$District), "</b>",
      "<br/>", "(R) ", as.character(df$candidate_Republican), " ", dollar(as.numeric(df$total_cash_Republican)),
      "<br/>", "(D) ", as.character(df$candidate_Democratic), " ", dollar(as.numeric(df$total_cash_Democratic))
    )
  ) %>%
    lapply(function(x) HTML(x))

  center <- st_bbox(df) %>% as.vector()

  m <- leafletProxy("map") %>%
    clearShapes() %>%
    addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
    addPolygons(
      data = df,
      layerId = df$District,
      weight = 0.5,
      smoothFactor = 0.3,
      label = ~Labels,
      color = "black",
      fillColor = ~ factpal(result),
      fillOpacity = 0.75
    )

  m <- m %>% fitBounds(center[1], center[2], center[3], center[4])

  m
}

district_map.proxy <- function(df, df.county, clicked_dist) {
  # Filter County List based on selected district (do not use until HD mapping file is 100% accurate)
  county.list <- unique(df.county$NAMELSAD[df.county[[paste0("D_", clicked_dist)]] == TRUE])
  df.county <- df.county %>% filter(NAMELSAD %in% county.list)

  factpal <- colorFactor(
    palette = c(
      "#8fbfea", # Light Blue
      "#ea9999", # Light Red
      "#1d89ea", # Dark Blue
      "#CD2626", # Dark Red
      "#b4a7d6" # Purple
    ),
    domain = c(
      "Lean D",
      "Lean R",
      "Strong D",
      "Strong R",
      "Swing"
    )
  )

  this_dist <- df %>% filter(District == clicked_dist)
  oth_dist <- df %>% filter(District != clicked_dist)

  Labels <- sprintf(
    paste0(
      "<b>", df.county$NAMELSAD, "</b>"
    )
  ) %>%
    lapply(function(x) HTML(x))

  center <- st_bbox(this_dist) %>% as.vector()

  m <- leafletProxy("map") %>%
    clearShapes() %>%
    addPolygons(
      data = df.county,
      fillColor = ~ factpal(result),
      fillOpacity = 0.75,
      weight = 0.5,
      color = "black",
      label = ~Labels,
    ) %>%
    addPolygons(
      data = oth_dist,
      weight = 0.5,
      color = "black",
      fillColor = "white",
      fillOpacity = 1
    )

  m <- m %>% fitBounds(center[1], center[2], center[3], center[4])

  m
}

rCand <- function(df, clicked_dist) {
  View(clicked_dist)
  if (clicked_dist == "\\d+") {
    "Republican"
  } else {
    data <- df %>%
      as.data.frame() %>%
      filter(District == clicked_dist) %>%
      select(candidate_Republican) %>%
      as.character()
  }
}

rCash <- function(df, clicked_dist) {
  if (clicked_dist == "\\d+") {
    ""
  } else {
    data <- df %>%
      as.data.frame() %>%
      filter(District == clicked_dist) %>%
      select(total_cash_Republican) %>%
      as.numeric() %>%

      dollar()
    paste0("Cash on Hand: ", data)
  }
}

rRaised <- function(df, clicked_dist) {
  if (clicked_dist == "\\d+") {
    ""
  } else {
    data <- df %>%
      as.data.frame() %>%
      filter(District == clicked_dist) %>%
      select(total_raised_Republican) %>%
      as.numeric() %>%
      dollar()
    paste0("Total Raised: ", data)
  }
}

dCand <- function(df, clicked_dist) {
  if (clicked_dist == "\\d+") {
    "Democrat"
  } else {
    data <- df %>%
      as.data.frame() %>%
      filter(District == clicked_dist) %>%
      select(candidate_Democratic) %>%
      as.character()
  }
}

dCash <- function(df, clicked_dist) {
  if (clicked_dist == "\\d+") {
    ""
  } else {
    data <- df %>%
      as.data.frame() %>%
      filter(District == clicked_dist) %>%
      select(total_cash_Democratic) %>%
      as.numeric() %>%
      dollar()
    paste0("Cash on Hand: ", data)
  }
}

dRaised <- function(df, clicked_dist) {
  if (clicked_dist == "\\d+") {
    ""
  } else {
    data <- df %>%
      as.data.frame() %>%
      filter(District == clicked_dist) %>%
      select(total_raised_Democratic) %>%
      as.numeric() %>%
      dollar()
    paste0("Total Raised: ", data)
  }
}



new_election_bar <- function(clicked_dist, df, election) {

  bar_data <- filter(df, grepl(clicked_dist, District)) %>% 
    filter(election == election) 


 my_theme <- hc_theme(
    chart = list(
      style = list(
        fontFamily = "Arial Black, sans-serif"
      )
    )
  )


  # Create highchart object with reversed column order
  highchart() %>%
    hc_title(
      text = paste(election),
      style = list(
        fontSize = "20px"
      ),
      align = "left"
    ) %>%
    # Set chart type to stacked bar chart and remove spacing on the right side
    hc_chart(
      type = "bar",
      marginTop = 10,
      marginBottom = -10
    ) %>%
    # Remove x-axis labels
    hc_xAxis(
      labels = list(enabled = FALSE),
      tickLength = 0,
      lineColor = "transparent" # Add this line to make the y-axis line transparent
    ) %>%
    # Remove y-axis labels and gridlines
    hc_yAxis(
      labels = list(enabled = FALSE),
      max = sum(bar_data$totVotes),
      tickInterval = 1,
      gridLineWidth = 0
    ) %>%
    # Add data series with reversed column order
    # hc_add_series(name = "Strong Democrat", data = data$value5,color = "#1d89ea",total = myTotal) %>%
    # hc_add_series(name = "Lean Democrat", data = data$value4,color = "#8fbfea",total = myTotal) %>%
    # hc_add_series(name = "Swing", data = data$value3,color = "#b4a7d6",total = myTotal) %>%
    hc_add_series(name = dCand(df, clicked_dist), data = sum(bar_data$dVotes), color = "#1d89ea", total = sum(bar_data$totVotes)) %>%
    hc_add_series(name = rCand(df, clicked_dist), data = sum(bar_data$rVote), color = "#CD2626", total = sum(bar_data$totVotes)) %>%
    hc_plotOptions(
      series = list(
        stacking = "normal",
        dataLabels = list(
          enabled = TRUE,
          style = list(
            fontSize = "12px",
            color = "white"
          ),
          formatter = JS(
            "function() {
          var percentage = (this.y / this.series.options.total) * 100;
          var s = '<b>' + this.series.name + '</b> ' +
                  Highcharts.numberFormat(percentage, 0) + '%';
          return s;
        }"
          )
        )
      )
    ) %>%
    # Remove chart legend
    hc_legend(enabled = FALSE) %>%
    hc_tooltip(
      useHTML = TRUE,
      formatter = JS(
        "function() {
       var percentage = (this.y / this.series.options.total) * 100;
       var s = '<b>' + this.series.name + '</b> ' +
               '<span >' + Highcharts.numberFormat(percentage, 1) + '%</span>';
       return s;
     }"
      )
    ) %>%
    hc_add_theme(my_theme)

  }

# election_bar <- function(df, election) {
#   # df <- df.hd
#   # election <- "2020 Presidential"

  

#   if (election == "2020 Presidential") {
#     rCand <- "Trump"
#     dCand <- "Biden"
#   } else if (election == "2021 Governor") {
#     rCand <- "Youngkin"
#     dCand <- "McAuiliffe"
#   } else {
#     rCand <- "Republican"
#     dCand <- "Democrat"
#   }

#   data <- df %>%
#     as.data.frame() %>%
#     filter(election == election) %>%
#     group_by(result) %>%
#     summarize(res_count = n())



#   # data <- df %>%
#   #   as.data.frame() %>%
#   #   group_by(result) %>%
#   #   summarize(res_count = n())



#   #data <- data.frame(
#    # category = "Cateory 1",
#     # value5 = as.numeric(data[data$result == "Strong D",2]),
#     # value4 = as.numeric(data[data$result == "Lean D",2]),
#     # value3 = as.numeric(data[data$result == "Swing",2]),
#     #value2 = as.numeric(data[data$result == "Lean R", 2]),
#     #value1 = as.numeric(data[data$result == "Strong R", 2])
#   #)

#   # myTotal <- data$value5 + data$value4 + data$value3 + data$value2 + data$value1
#   myTotal <- data$value2 + data$value1

#   my_theme <- hc_theme(
#     chart = list(
#       style = list(
#         fontFamily = "Arial Black, sans-serif"
#       )
#     )
#   )

#   # Create highchart object with reversed column order
#   highchart() %>%
#     hc_title(
#       text = paste(election),
#       style = list(
#         fontSize = "20px"
#       ),
#       align = "left"
#     ) %>%
#     # Set chart type to stacked bar chart and remove spacing on the right side
#     hc_chart(
#       type = "bar",
#       marginTop = 10,
#       marginBottom = -10
#     ) %>%
#     # Remove x-axis labels
#     hc_xAxis(
#       labels = list(enabled = FALSE),
#       tickLength = 0,
#       lineColor = "transparent" # Add this line to make the y-axis line transparent
#     ) %>%
#     # Remove y-axis labels and gridlines
#     hc_yAxis(
#       labels = list(enabled = FALSE),
#       max = myTotal,
#       tickInterval = 1,
#       gridLineWidth = 0
#     ) %>%
#     # Add data series with reversed column order
#     # hc_add_series(name = "Strong Democrat", data = data$value5,color = "#1d89ea",total = myTotal) %>%
#     # hc_add_series(name = "Lean Democrat", data = data$value4,color = "#8fbfea",total = myTotal) %>%
#     # hc_add_series(name = "Swing", data = data$value3,color = "#b4a7d6",total = myTotal) %>%
#     hc_add_series(name = dCand, data = data$value2, color = "#1d89ea", total = myTotal) %>%
#     hc_add_series(name = rCand, data = data$value1, color = "#CD2626", total = myTotal) %>%
#     hc_plotOptions(
#       series = list(
#         stacking = "normal",
#         dataLabels = list(
#           enabled = TRUE,
#           style = list(
#             fontSize = "12px",
#             color = "white"
#           ),
#           formatter = JS(
#             "function() {
#           var percentage = (this.y / this.series.options.total) * 100;
#           var s = '<b>' + this.series.name + '</b> ' +
#                   Highcharts.numberFormat(percentage, 0) + '%';
#           return s;
#         }"
#           )
#         )
#       )
#     ) %>%
#     # Remove chart legend
#     hc_legend(enabled = FALSE) %>%
#     hc_tooltip(
#       useHTML = TRUE,
#       formatter = JS(
#         "function() {
#        var percentage = (this.y / this.series.options.total) * 100;
#        var s = '<b>' + this.series.name + '</b> ' +
#                '<span >' + Highcharts.numberFormat(percentage, 1) + '%</span>';
#        return s;
#      }"
#       )
#     ) %>%
#     hc_add_theme(my_theme)
# }
# function to filter data by election

