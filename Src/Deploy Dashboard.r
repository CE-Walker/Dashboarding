rm(list = ls())
cat("\014")
### USED THIS SCRIPT TO SET UP shinyapps.io
# source for instructions: https://www.shinyapps.io/admin/#/dashboard

# Step 1 - INSTALL & CALL RSCONNECT library
# install.packages('rsconnect')
library(rsconnect)

# Step 2 - AUTHORIZE ACCOUNT
rsconnect::setAccountInfo(
    name = "co-efficient",
    token = "AF6DB8E7B01B7C370A2F993383BE5FDB",
    secret = "fHOd8epcRR1Nh5VkgOEYTi27vmZFu405JXK4taxn"
)

# STEP 3 - DEPLOY
deployApp("C:/Users/ryanm/Desktop/co-efficient/6_ProductionTools/WIP/Interactive_Map_Dashboard_WIP",
    account = "co-efficient", forceUpdate = TRUE, launch.browser = FALSE
)
