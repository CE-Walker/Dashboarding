library(dplyr)


#### Read all data from Assets folder
data_path <- file.path("Assets/finance", list.files("Assets/finance", pattern = "*ScheduleH.csv"))
dominion_path <- file.path("Assets/finance", list.files("Assets/finance", pattern = "*ScheduleA.csv"))
map_path <- file.path("Assets/finance", list.files("Assets/finance", pattern = "*Report.csv"))

data_files <- lapply(data_path, read.csv)
dominion_files <- lapply(dominion_path, read.csv)
map_files <- lapply(map_path, read.csv)

finance_data <- do.call(rbind, data_files)
dominion <- do.call(rbind, dominion_files)
finance_map <- do.call(rbind, map_files)



### Union on ReportUID
mapped_data <- left_join(finance_data, finance_map, by = join_by(ReportUID == ReportUID))
mapped_dom <- left_join(dominion, finance_map, by = join_by(ReportUID == ReportUID))

#### Only use candidates whose cycle ends this year
mapped_data <- subset(mapped_data, mapped_data$ElectionCycleEndDate == "2023-12-31 00:00:00")

mapped_dom <- subset(mapped_dom, mapped_dom$CommitteeType == "Candidate Campaign Committee")
mapped_dom <- subset(mapped_dom, mapped_dom$IsIndividual == "False")
mapped_dom <- subset(mapped_dom, grepl("Dominion|DE", mapped_dom$LastOrCompanyName))
mapped_dom$District <- as.numeric(gsub("\\D+", "", mapped_dom$District))

hod_dom <- subset(mapped_dom, grepl("Delegate", mapped_dom$OfficeSought))


View(mapped_dom)

#### Making dataframes for each type of district, but only using HoD right now.
# sd <- subset(mapped_data, mapped_data$OfficeSought == "Member Senate of Virginia")
# sd$District <- as.numeric(gsub("\\D", "", sd$District))

hod <- subset(mapped_data, mapped_data$OfficeSought == "Member House of Delegates")
hod$District <- as.numeric(gsub("\\D", "", hod$District))

#### None this year
# cd <- subset(mapped_data, mapped_data$OfficeSought == "Member Senate of Virginia")
# cd$District <- as.numeric(gsub("\\D", "", hod$District))

# View(sd)

#### Commented out so you can run and view the table without overwriting any files
write.csv(hod, "Assets/election/2022_House_Finances.csv")
write.csv(hod_dom, "Assets/election/2022_House_Dom.csv")
