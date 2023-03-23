library(dplyr)

# precinct_paths <- file.path("Assets/election", list.files("Assets/election/", pattern="Daily_Registrant_Count*"))

# precinct_files <- lapply(precinct_paths, read.csv)

# precinct_c
house_precincts <- 
    read.csv(file.path("Assets/election", list.files("Assets/election/", "Daily_Registrant_Count_By_House*")), 
        fileEncoding = "UTF-8-BOM")

house_precincts$Locality <- sub("Locality: \\d{3} ", "", house_precincts$Locality)
house_precincts$District <- as.numeric(sub("HSE ", "", house_precincts$District))

corrections <- read.csv("Assets/election/Corrections_Table.csv")

for (i in seq_len((nrow(corrections)))) {
    print(corrections$PrecinctName[i])
    print(corrections$FormerName[i])     

    house_precincts$PrecinctName <- 
        sub(corrections$PrecinctName[i], corrections$FormerName[i], house_precincts$PrecinctName)
}

results <- read.csv("Assets/election/2021_November_General_Results.csv")



# df_in$key <- paste0(df_in$State_House_District,"_",df_in$Precinct)
# df_in %>% select(key) %>% unique() %>% nrow()

# mapping_table <- df_in %>%
#  distinct(State_House_District,Precinct) %>% arrange(State_House_District,Precinct)

# # mapping_table
# write.csv(mapping_table,"Assets\\election\\VA_HD-Precinct_MappingTable.csv",row.names=FALSE)
