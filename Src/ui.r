ui <- fluidPage(
  tags$head(
    tags$style(
      HTML("
        .custom-title {
          background-color: #3D75BE;
          color: white;
          text-align: center;
          height: 100px;
          display: flex;
          align-items: center;
          justify-content: center;
        }

        h1 {
          font-family: 'Arial Black', sans-serif;
          font-size: 24px;
          text-align: left;
        }

      .title-text {
        background-color: #A9A9A9;
        font-family: 'Arial Black', sans-serif;
        font-size: 32px;
        text-align: center;
        color: #FFFFFF;
        width: 40%;
        height: 60px;
        padding: 5px;
        border-radius: 0 0 20px 0;
        margin-top: 0px; /* remove top margin */
        margin-left: 0px; /* remove left margin */
        padding-top: 10px; /* reduce padding on top of text */
      }

      ")
    )
  ),
  div(
    class = "custom-title",
    titlePanel("Virginia 2023 Dashboard")
  ),
  div(
    class = "title-text",
    textOutput("title_text")
  ),
  fluidRow(
    column(
      width = 6,
      tags$h1("DISTRICT MAP"),
      leaflet::leafletOutput("map", height = 300)
    ),
    column(
      width = 6,
      tags$h1("CANDIDATES"),
      br(), br(),
      column(
        width = 6,
        align = "center",
        div(
          style = "margin-bottom: 20px;",
          imageOutput("myimage1", height = 150, width = 150)
        ),
        textOutput("r_cand"),
        textOutput("r_cash"),
        textOutput("r_raised")
      ),
      column(
        width = 6,
        align = "center",
        div(
          style = "margin-bottom: 20px;",
          imageOutput("myimage2", height = 150, width = 150)
        ),
        textOutput("d_cand"),
        textOutput("d_cash"),
        textOutput("d_raised"),
      )
    )
  ),
  fluidRow(
    column(
      width = 12,
      br(),
      tags$h1("DISTRICT ELECTION HISTORY"),
      fluidRow(
        column(
          width = 6,
          highchartOutput("mychart1", height = 150)
        ),
        column(
          width = 6,
          highchartOutput("mychart2", height = 150)
        )
      ),
      fluidRow(
        column(
          width = 6,
          highchartOutput("mychart3", height = 150)
        ),
        column(
          width = 6,
          highchartOutput("mychart4", height = 150)
        )
      )
    )
  ),
  fluidRow(
    column(
      width = 12,
      tags$h1("DE CONTRIBUTIONS"),
      #dynamic list of text outputs
      textOutput("de_contributions"),
      br(), br(), br(), br(), br(), br(), br(), br(), br(), br()
    )
  ),
  fluidRow(
    column(
      width = 12,
      tags$h1("RECENT POLLING"),
      #table of polling data
      tableOutput("polling_table"),
      br(), br(), br(), br(), br(), br(), br(), br(), br(), br()
    )
  ),
  fluidRow(
    column(
      width = 12,
      tags$h1("KEY PRECINCTS"),
      #table of competitive precincts
      tableOutput("precinct_table"),
      br(), br(), br(), br(), br(), br(), br(), br(), br(), br()
    )
  )
)
