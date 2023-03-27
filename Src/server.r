server <- function(input, output, session) {
  ### Update if user changes map.type filter
  # observeEvent(input$view,{  -- removed input$view dropdown logic --> will replace later to vary b/w hd, cd, & sd
  observe({
    # Render Title Text Output
    output$title_text <- renderText({
      titleText(type = "Statewide", clicked_dist = "N/A")
    })

    # Render Statewide Leaflet Map for current map.type
    output$map <- renderLeaflet({
      statewide_map(df = df.house)
    })

    output$myimage1 <- renderImage({
      list(
        src = "Assets/test.png",
        width = "150px",
        height = "150px"
      )
    })

    output$myimage2 <- renderImage({
      list(
        src = "Assets/test.png",
        width = "150px",
        height = "150px"
      )
    })

    # Render Title Text Output
    output$r_cand <- renderText({
      rCand(df = df.house, clicked_dist = "\\d+")
    })
    # Render Title Text Output
    output$r_cash <- renderText({
      rCash(df = df.house, clicked_dist = "\\d+")
    })
    # Render Title Text Output
    output$r_raised <- renderText({
      rRaised(df = df.house, clicked_dist = "\\d+")
    })

    # Render Title Text Output
    output$d_cand <- renderText({
      dCand(df = df.house, clicked_dist = "\\d+")
    })
    # Render Title Text Output
    output$d_cash <- renderText({
      dCash(df = df.house, clicked_dist = "\\d+")
    })
    # Render Title Text Output
    output$d_raised <- renderText({
      dRaised(df = df.house, clicked_dist = "\\d+")
    })


    # Render Bar Chart
    output$mychart1 <- renderHighchart({
      new_election_bar("\\d+", df = df.congress, election = "2022 Congressional")
    })


    # Render Bar Chart
    output$mychart2 <- renderHighchart({
      new_election_bar("\\d+",df = df.prez, election = "2020 Presidential")
    })

    # Render Bar Chart
    output$mychart3 <- renderHighchart({
      new_election_bar("\\d+", df = df.gov, election = "2021 Governor")
    })

    # Render District Bar Chart
    output$mychart4 <- renderHighchart({
      new_election_bar("\\d+",df = df.house, election = "2019 House of Delegates")
    })
  })

  ### Update if user clicks a shape on the map
  observeEvent(input$map_shape_click, {
    # Capture info on clicked shape
    click <- input$map_shape_click

    # User clicked to zoom back out to the statewide view (this is because no layer id is defined for the county data-->user clicked county)
    if (is.null(click$id)) {
      # Render Title Text Output
      output$title_text <- renderText({
        titleText(type = "Statewide", clicked_dist = "\\d+")
      })

      # Render District Level Leaflet Proxy Map for current map.type
      statewide_map.proxy(df = df.house)

      output$myimage1 <- renderImage({
        list(
          src = "Assets/test.png",
          width = "150px",
          height = "150px"
        )
      })

      output$myimage2 <- renderImage({
        list(
          src = "Assets/test.png",
          width = "150px",
          height = "150px"
        )
      })

      # Render Title Text Output
      output$r_cand <- renderText({
        rCand(df = df.house, clicked_dist = "\\d+")
      })

      # Render Title Text Output
      output$r_cash <- renderText({
        rCash(df = df.house, clicked_dist = "\\d+")
      })
      # Render Title Text Output
      output$r_raised <- renderText({
        rRaised(df = df.house, clicked_dist = "\\d+")
      })

      # Render Title Text Output
      output$d_cand <- renderText({
        dCand(df = df.house, clicked_dist = "\\d+")
      })
      # Render Title Text Output
      output$d_cash <- renderText({
        dCash(df = df.house, clicked_dist = "\\d+")
      })
      # Render Title Text Output
      output$d_raised <- renderText({
        dRaised(df = df.house, clicked_dist = "\\d+")
      })

      # Render District Bar Chart
      output$mychart1 <- renderHighchart({
        new_election_bar("\\d+",df = df.congress, election = "2022 Congressional")
      })

      # Render District Bar Chart
      output$mychart2 <- renderHighchart({
        new_election_bar("\\d+",df = df.prez, election = "2020 Presidential")
      })

      # Render District Bar Chart
      output$mychart3 <- renderHighchart({
        new_election_bar("\\d+",df = df.gov, election = "2021 Governor")
      })

      # Render District Bar Chart
      output$mychart4 <- renderHighchart({
        new_election_bar("\\d+",df = df.house, election = "2019 House of Delegates")
      })

      # User clicked to drill down to the district level
    } else {
      # Render Title Text Output
      output$title_text <- renderText({
        titleText(type = "District", clicked_dist = click$id)
      })

      # Render District Map Proxy
      district_map.proxy(df = df.house, df.county = df.county, clicked_dist = click$id)

      output$myimage1 <- renderImage({
        list(
          src = "Assets/test.png",
          width = "150px",
          height = "150px"
        )
      })

      output$myimage2 <- renderImage({
        list(
          src = "Assets/test.png",
          width = "150px",
          height = "150px"
        )
      })

      # Render Title Text Output
      output$r_cand <- renderText({
        rCand(df = df.house, clicked_dist = click$id)
      })

      # Render Title Text Output
      output$r_cash <- renderText({
        rCash(df = df.house, clicked_dist = click$id)
      })
      # Render Title Text Output
      output$r_raised <- renderText({
        rRaised(df = df.house, clicked_dist = click$id)
      })

      # Render Title Text Output
      output$d_cand <- renderText({
        dCand(df = df.house, clicked_dist = click$id)
      })
      # Render Title Text Output
      output$d_cash <- renderText({
        dCash(df = df.house, clicked_dist = click$id)
      })
      # Render Title Text Output
      output$d_raised <- renderText({
        dRaised(df = df.house, clicked_dist = click$id)
      })
      # Render Bar Chart
      output$mychart1 <- renderHighchart({
        new_election_bar(click$id ,df = df.congress, election = "2022 Congressional")
      })

      # Render Bar Chart
      output$mychart2 <- renderHighchart({
        new_election_bar(click$id,df = df.prez, election = "2020 Presidential")
      })

      # Render Chart
      output$mychart3 <- renderHighchart({
        new_election_bar(click$id,df = df.gov, election = "2021 Governor")
      })

      # Render Chart
      output$mychart4 <- renderHighchart({
        new_election_bar(click$id,df = df.house, election = "2019 House of Delegates")
      })
    }
  })
}
